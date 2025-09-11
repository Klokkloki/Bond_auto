enum UserRole {
  buyer,
  seller,
  dealer,
  logistics,
  broker,
  admin,
}

class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String country;
  final String city;
  final String avatar;
  final double rating;
  final int completedDeals;
  final UserRole role;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime lastActive;
  final Map<String, dynamic> preferences;
  final List<String> languages;
  final String? kycStatus; // 'pending', 'approved', 'rejected'
  final List<String> kycDocuments; // Список загруженных документов

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.country,
    required this.city,
    required this.avatar,
    required this.rating,
    required this.completedDeals,
    required this.role,
    required this.isVerified,
    required this.createdAt,
    required this.lastActive,
    this.preferences = const {},
    this.languages = const ['ru'],
    this.kycStatus,
    this.kycDocuments = const [],
  });

  String get fullName => '$firstName $lastName';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      avatar: json['avatar'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      completedDeals: json['completedDeals'] ?? 0,
      role: UserRole.values.firstWhere(
            (e) => e.toString().split('.').last == json['role'],
        orElse: () => UserRole.buyer,
      ),
      isVerified: json['isVerified'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      lastActive: DateTime.parse(json['lastActive'] ?? DateTime.now().toIso8601String()),
      preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
      languages: List<String>.from(json['languages'] ?? ['ru']),
      kycStatus: json['kycStatus'],
      kycDocuments: List<String>.from(json['kycDocuments'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'country': country,
      'city': city,
      'avatar': avatar,
      'rating': rating,
      'completedDeals': completedDeals,
      'role': role.toString().split('.').last,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      'preferences': preferences,
      'languages': languages,
      'kycStatus': kycStatus,
      'kycDocuments': kycDocuments,
    };
  }

  // Проверка роли
  bool get isBuyer => role == UserRole.buyer;
  bool get isSeller => role == UserRole.seller;
  bool get isDealer => role == UserRole.dealer;
  bool get isLogistics => role == UserRole.logistics;
  bool get isBroker => role == UserRole.broker;
  bool get isAdmin => role == UserRole.admin;

  // Проверка KYC статуса
  bool get isKycApproved => kycStatus == 'approved';
  bool get isKycPending => kycStatus == 'pending';
  bool get isKycRejected => kycStatus == 'rejected';
}

// Обратная совместимость
typedef User = UserModel;

