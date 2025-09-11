import '../models/car.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'https://api.bondauto.com';
  static const Duration timeout = Duration(seconds: 30);


  // Cars API
  static Future<List<Car>> getCars({
    String? search,
    String? country,
    String? sellerType,
    double? minPrice,
    double? maxPrice,
    int? minYear,
    int? maxYear,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // Заглушка - возвращаем пустой список
      return [];
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  static Future<Car> getCar(String id) async {
    try {
      // Заглушка - возвращаем пустой автомобиль
      return Car(
        id: id,
        title: 'Заглушка',
        subtitle: 'Заглушка',
        price: '0',
        year: '2023',
        km: '0 км',
        imageUrl: '',
        vin: '',
        fuelType: 'Бензин',
        transmission: 'Автомат',
        color: 'Белый',
        country: 'Россия',
        city: 'Москва',
        sellerType: 'dealer',
        sellerId: '1',
        sellerName: 'Заглушка',
        sellerRating: 5.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  // User API
  static Future<User> getUser(String userId) async {
    try {
      // Заглушка - возвращаем тестового пользователя
      return User(
        id: userId,
        email: 'user@example.com',
        firstName: 'Тест',
        lastName: 'Пользователь',
        phone: '+7 777 123 45 67',
        country: 'Казахстан',
        city: 'Алматы',
        avatar: '',
        rating: 4.8,
        completedDeals: 12,
        role: UserRole.buyer,
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        lastActive: DateTime.now(),
      );
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  static Future<User> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      // Заглушка - возвращаем обновленного пользователя
      return getUser(userId);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}




