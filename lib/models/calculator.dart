class ImportCalculator {
  final String carId;
  final String sourceCountry;
  final String destinationCountry;
  final String sourceCity;
  final String destinationCity;
  final double carPrice;
  final String currency;
  final DateTime calculationDate;
  // Расширенные параметры
  final String fuelType; // petrol | diesel | hybrid | electric
  final double engineVolumeLiters; // объём двигателя в литрах (для EV = 0)
  final int manufactureYear; // год выпуска
  final bool isAuction;

  ImportCalculator({
    required this.carId,
    required this.sourceCountry,
    required this.destinationCountry,
    required this.sourceCity,
    required this.destinationCity,
    required this.carPrice,
    required this.currency,
    required this.calculationDate,
    required this.fuelType,
    required this.engineVolumeLiters,
    required this.manufactureYear,
    required this.isAuction,
  });

  CalculationResult calculate() {
    // Простая модель расчёта (демо):
    // - аукционный сбор: 5% если покупка на аукционе
    final double auctionFee = isAuction ? carPrice * 0.05 : 0.0;
    // - конвертация валюты: 1.5%
    final double currencyConversion = carPrice * 0.015;
    // - логистика (заглушка): внутренняя + море/автовоз
    const double inlandTransport = 200.0;
    const double seaTransport = 800.0;

    // - пошлина: ставка зависит от топлива и объёма; множитель по возрасту
    final int currentYear = calculationDate.year;
    final int ageYears = (currentYear - manufactureYear).clamp(0, 30);
    final double ageFactor = (1.0 + (ageYears / 20.0)).clamp(1.0, 2.0);
    double perLiterRate;
    switch (fuelType.toLowerCase()) {
      case 'diesel':
        perLiterRate = 120.0;
        break;
      case 'hybrid':
        perLiterRate = 60.0;
        break;
      case 'electric':
        perLiterRate = 0.0;
        break;
      default: // petrol
        perLiterRate = 100.0;
    }
    final double customsDuty = (perLiterRate * engineVolumeLiters) * ageFactor;

    // - НДС: 12% от (цена + пошлина + логистика)
    final double vatBase = carPrice + customsDuty + inlandTransport + seaTransport;
    final double vat = vatBase * 0.12;

    // - Эко-сбор: надбавка за большие моторы
    final double ecoTax = engineVolumeLiters > 3.0 ? 150.0 : 50.0;

    // - Сертификация и регистрация (заглушки)
    const double certification = 300.0;
    const double registration = 150.0;

    final double totalPrice = carPrice + auctionFee + currencyConversion + inlandTransport + seaTransport + customsDuty + vat + ecoTax + certification + registration;

    return CalculationResult(
      carPrice: carPrice,
      auctionFee: auctionFee,
      currencyConversion: currencyConversion,
      inlandTransport: inlandTransport,
      seaTransport: seaTransport,
      customsDuty: customsDuty,
      vat: vat,
      ecoTax: ecoTax,
      certification: certification,
      registration: registration,
      totalPrice: totalPrice,
      estimatedDays: 21,
      currency: currency,
    );
  }
}

class CalculationResult {
  final double carPrice;
  final double auctionFee;
  final double currencyConversion;
  final double inlandTransport;
  final double seaTransport;
  final double customsDuty;
  final double vat;
  final double ecoTax;
  final double certification;
  final double registration;
  final double totalPrice;
  final int estimatedDays;
  final String currency;

  CalculationResult({
    required this.carPrice,
    required this.auctionFee,
    required this.currencyConversion,
    required this.inlandTransport,
    required this.seaTransport,
    required this.customsDuty,
    required this.vat,
    required this.ecoTax,
    required this.certification,
    required this.registration,
    required this.totalPrice,
    required this.estimatedDays,
    required this.currency,
  });

  List<CalculationItem> get items => [
    CalculationItem('Цена автомобиля', carPrice, currency),
    CalculationItem('Аукционный сбор', auctionFee, currency),
    CalculationItem('Конвертация валюты', currencyConversion, currency),
    CalculationItem('Доставка до порта', inlandTransport, currency),
    CalculationItem('Морская перевозка', seaTransport, currency),
    CalculationItem('Таможенная пошлина', customsDuty, currency),
    CalculationItem('НДС', vat, currency),
    CalculationItem('Экологический сбор', ecoTax, currency),
    CalculationItem('Сертификация', certification, currency),
    CalculationItem('Регистрация', registration, currency),
  ];
}

class CalculationItem {
  final String name;
  final double amount;
  final String currency;

  CalculationItem(this.name, this.amount, this.currency);
}

class LogisticsProvider {
  final String id;
  final String name;
  final String logo;
  final double rating;
  final int completedDeals;
  final double price;
  final int days;
  final String description;
  final List<String> services;

  LogisticsProvider({
    required this.id,
    required this.name,
    required this.logo,
    required this.rating,
    required this.completedDeals,
    required this.price,
    required this.days,
    required this.description,
    required this.services,
  });

  factory LogisticsProvider.fromJson(Map<String, dynamic> json) {
    return LogisticsProvider(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      completedDeals: json['completedDeals'] ?? 0,
      price: (json['price'] ?? 0.0).toDouble(),
      days: json['days'] ?? 0,
      description: json['description'] ?? '',
      services: List<String>.from(json['services'] ?? []),
    );
  }
}

class CustomsBroker {
  final String id;
  final String name;
  final String logo;
  final double rating;
  final int completedDeals;
  final double price;
  final int days;
  final String description;
  final List<String> countries;

  CustomsBroker({
    required this.id,
    required this.name,
    required this.logo,
    required this.rating,
    required this.completedDeals,
    required this.price,
    required this.days,
    required this.description,
    required this.countries,
  });

  factory CustomsBroker.fromJson(Map<String, dynamic> json) {
    return CustomsBroker(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      completedDeals: json['completedDeals'] ?? 0,
      price: (json['price'] ?? 0.0).toDouble(),
      days: json['days'] ?? 0,
      description: json['description'] ?? '',
      countries: List<String>.from(json['countries'] ?? []),
    );
  }
}
