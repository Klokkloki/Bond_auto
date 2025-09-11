import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthService {
  static final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Получить текущего пользователя
  static firebase_auth.User? get currentUser => _auth.currentUser;

  // Стрим состояния аутентификации
  static Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();

  // Регистрация с email/паролем
  static Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String country,
    required String city,
    required String role,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserModel(
        id: credential.user!.uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        country: country,
        city: city,
        avatar: '',
        rating: 0.0,
        completedDeals: 0,
        role: UserRole.values.firstWhere(
              (e) => e.toString().split('.').last == role,
          orElse: () => UserRole.buyer,
        ),
        isVerified: false,
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
      );

      // Сохраняем в Firestore
      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(user.toJson());

      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw AuthException('Этот email уже зарегистрирован. Выполните вход.');
      }
      if (e.code == 'weak-password') {
        throw AuthException('Слишком слабый пароль (минимум 6 символов).');
      }
      if (e.code == 'invalid-email') {
        throw AuthException('Некорректный email.');
      }
      throw AuthException('Ошибка регистрации: ${e.message ?? e.code}');
    } on FirebaseException catch (e) {
      throw AuthException('Ошибка Firestore: ${e.message ?? e.code}');
    } catch (e) {
      throw AuthException('Неизвестная ошибка: $e');
    }
  }

  // Вход с email/паролем
  static Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return await _getUserFromFirestore(credential.user!.uid);
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Пользователь не найден. Зарегистрируйтесь.');
      }
      if (e.code == 'wrong-password') {
        throw AuthException('Неверный пароль.');
      }
      if (e.code == 'too-many-requests') {
        throw AuthException('Слишком много попыток. Попробуйте позже.');
      }
      throw AuthException('Ошибка входа: ${e.message ?? e.code}');
    } on FirebaseException catch (e) {
      throw AuthException('Ошибка Firestore: ${e.message ?? e.code}');
    } catch (e) {
      throw AuthException('Неизвестная ошибка: $e');
    }
  }

  // Вход с номером телефона (SMS)
  static Future<void> sendPhoneVerification({
    required String phoneNumber,
    required Function(String) onCodeSent,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (firebase_auth.PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (firebase_auth.FirebaseAuthException e) {
          throw AuthException('Ошибка верификации: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      throw AuthException('Ошибка отправки SMS: $e');
    }
  }

  // Подтверждение SMS кода
  static Future<UserModel> verifyPhoneCode({
    required String verificationId,
    required String smsCode,
    required UserModel userData,
  }) async {
    try {
      final credential = firebase_auth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Сохраняем данные пользователя
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userData.toJson());

      return userData;
    } catch (e) {
      throw AuthException('Ошибка подтверждения кода: $e');
    }
  }

  // Выход
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException('Ошибка выхода: $e');
    }
  }

  // Получить пользователя из Firestore
  static Future<UserModel> _getUserFromFirestore(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      } else {
        // Если профиль отсутствует (могла не пройти запись при регистрации) — создаём минимальный профиль
        final firebaseUser = _auth.currentUser;
        final fallbackUser = UserModel(
          id: uid,
          email: firebaseUser?.email ?? '',
          firstName: '',
          lastName: '',
          phone: '',
          country: '',
          city: '',
          avatar: '',
          rating: 0.0,
          completedDeals: 0,
          role: UserRole.buyer,
          isVerified: firebaseUser?.emailVerified ?? false,
          createdAt: DateTime.now(),
          lastActive: DateTime.now(),
        );
        await _firestore.collection('users').doc(uid).set(fallbackUser.toJson());
        return fallbackUser;
      }
    } catch (e) {
      throw AuthException('Ошибка загрузки пользователя: $e');
    }
  }

  // Обновить профиль пользователя
  static Future<void> updateProfile(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.id)
          .update(user.toJson());
    } catch (e) {
      throw AuthException('Ошибка обновления профиля: $e');
    }
  }

  // Проверить, верифицирован ли пользователь
  static Future<bool> isUserVerified(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final user = UserModel.fromJson(doc.data()!);
        return user.isVerified;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Отправить email для сброса пароля
  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw AuthException('Ошибка отправки email: $e');
    }
  }

  static Future<UserModel> fetchUserModel(String uid) async {
    return _getUserFromFirestore(uid);
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}
