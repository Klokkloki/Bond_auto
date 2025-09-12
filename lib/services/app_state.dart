import 'package:flutter/material.dart';
import '../models/car.dart';
import '../models/user.dart';
import '../models/deal.dart';

class AppState extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  UserModel? _currentUser;
  bool _isAuthenticated = false;

  List<Car> _allCars = [];
  List<Car> _featuredCars = [];
  List<Deal> _deals = [];
  final Set<String> _favoriteCarIds = <String>{};

  ThemeMode get themeMode => _themeMode;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  List<Car> get allCars => _allCars;
  List<Car> get featuredCars => _featuredCars;
  List<Deal> get deals => _deals;
  List<Car> get favoriteCars => _allCars.where((c) => _favoriteCarIds.contains(c.id)).toList();
  bool isCarFavorite(String carId) => _favoriteCarIds.contains(carId);

  AppState() {
    _loadMockData();
  }

  // Методы аутентификации
  void setCurrentUser(UserModel? user) {
    _currentUser = user;
    _isAuthenticated = user != null;
    notifyListeners();
  }

  void signOut() {
    _currentUser = null;
    _isAuthenticated = false;
    _favoriteCarIds.clear();
    notifyListeners();
  }

  void _loadMockData() {
    _allCars = [
      Car(
        id: '1',
        title: 'BMW 3 Series',
        subtitle: '320d xDrive',
        price: '25 000',
        year: '2021',
        km: '45 000 км',
        imageUrl: 'http://cdn.motorpage.ru/Photos/800/11614.jpg',
        vin: 'WBA3A5C5XJ1234567',
        fuelType: 'Дизель',
        transmission: 'Автомат',
        color: 'Белый',
        country: 'Германия',
        city: 'Мюнхен',
        sellerType: 'dealer',
        sellerId: 'dealer1',
        sellerName: 'BMW Center Munich',
        sellerRating: 4.9,
        onOrder: false,
        hasHistory: true,
        images: [
          'http://cdn.motorpage.ru/Photos/800/11614.jpg',
          'https://picsum.photos/seed/bmw-320d-2/1200/800',
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Car(
        id: '2',
        title: 'Mercedes-Benz C-Class',
        subtitle: 'C200 AMG Line',
        price: '28 500',
        year: '2022',
        km: '32 000 км',
        imageUrl: 'http://cdn.motorpage.ru/Photos/800/4F8E.jpg',
        vin: 'WDD2050461A123456',
        fuelType: 'Бензин',
        transmission: 'Автомат',
        color: 'Черный',
        country: 'Германия',
        city: 'Штутгарт',
        sellerType: 'dealer',
        sellerId: 'dealer2',
        sellerName: 'Mercedes-Benz Stuttgart',
        sellerRating: 4.7,
        onOrder: true,
        hasHistory: true,
        images: [
          'http://cdn.motorpage.ru/Photos/800/4F8E.jpg',
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now(),
      ),
      Car(
        id: '3',
        title: 'Audi A4',
        subtitle: '40 TDI Quattro',
        price: '22 000',
        year: '2020',
        km: '58 000 км',
        imageUrl: 'http://cdn.motorpage.ru/Photos/800/2DE2.jpg',
        vin: 'WAUZZZ8V0LA123456',
        fuelType: 'Дизель',
        transmission: 'Автомат',
        color: 'Серый',
        country: 'Германия',
        city: 'Ингольштадт',
        sellerType: 'auction',
        sellerId: 'auction1',
        sellerName: 'AutoAuction Munich',
        sellerRating: 4.5,
        onOrder: false,
        hasHistory: false,
        images: [
          'http://cdn.motorpage.ru/Photos/800/2DE2.jpg',
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];

    _featuredCars = _allCars.take(2).toList();

    _deals = [
      Deal(
        id: 'd1',
        carId: '1',
        buyerId: 'demo_user',
        sellerId: 'dealer1',
        type: DealType.dealer,
        status: DealStatus.inTransit,
        carPrice: 25000,
        totalPrice: 31200,
        currency: 'EUR',
        sourceCountry: 'Германия',
        destinationCountry: 'Казахстан',
        sourceCity: 'Мюнхен',
        destinationCity: 'Алматы',
        logisticsProviderId: 'log1',
        customsBrokerId: 'broker1',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Deal(
        id: 'd2',
        carId: '2',
        buyerId: 'demo_user',
        sellerId: 'dealer2',
        type: DealType.dealer,
        status: DealStatus.completed,
        carPrice: 28500,
        totalPrice: 34900,
        currency: 'EUR',
        sourceCountry: 'Германия',
        destinationCountry: 'Казахстан',
        sourceCity: 'Штутгарт',
        destinationCity: 'Алматы',
        logisticsProviderId: 'log2',
        customsBrokerId: 'broker2',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      Deal(
        id: 'd3',
        carId: '3',
        buyerId: 'demo_user',
        sellerId: 'auction1',
        type: DealType.auction,
        status: DealStatus.cancelled,
        carPrice: 22000,
        totalPrice: 0,
        currency: 'EUR',
        sourceCountry: 'Германия',
        destinationCountry: 'Казахстан',
        sourceCity: 'Ингольштадт',
        destinationCity: 'Алматы',
        logisticsProviderId: 'log3',
        customsBrokerId: 'broker3',
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
        updatedAt: DateTime.now().subtract(const Duration(days: 11)),
      ),
    ];
  }

  void updateUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  void toggleDarkMode(bool isDark) {
    setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void addCar(Car car) {
    _allCars.add(car);
    notifyListeners();
  }

  void toggleFavorite(String carId) {
    if (_favoriteCarIds.contains(carId)) {
      _favoriteCarIds.remove(carId);
    } else {
      _favoriteCarIds.add(carId);
    }
    notifyListeners();
  }


  List<Car> searchCars(String query) {
    if (query.isEmpty) return _allCars;

    return _allCars.where((car) {
      return car.title.toLowerCase().contains(query.toLowerCase()) ||
          car.subtitle.toLowerCase().contains(query.toLowerCase()) ||
          car.vin.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  List<Car> filterCars({
    String? country,
    String? sellerType,
    double? minPrice,
    double? maxPrice,
    int? minYear,
    int? maxYear,
  }) {
    return _allCars.where((car) {
      if (country != null && car.country != country) return false;
      if (sellerType != null && car.sellerType != sellerType) return false;

      final carPrice = double.tryParse(car.price.replaceAll(RegExp(r'[^\d]'), '')) ?? 0.0;
      if (minPrice != null && carPrice < minPrice) return false;
      if (maxPrice != null && carPrice > maxPrice) return false;

      final carYear = int.tryParse(car.year) ?? 0;
      if (minYear != null && carYear < minYear) return false;
      if (maxYear != null && carYear > maxYear) return false;

      return true;
    }).toList();
  }
}
