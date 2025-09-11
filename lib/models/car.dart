class Car {
  final String id;
  final String title;
  final String subtitle;
  final String price;
  final String year;
  final String km;
  final String imageUrl;
  final String vin;
  final String fuelType;
  final String transmission;
  final String color;
  final String country;
  final String city;
  final String sellerType; // 'auction', 'dealer', 'private'
  final String sellerId;
  final String sellerName;
  final double sellerRating;
  final bool onOrder;
  final bool hasHistory;
  final List<String> images;
  final Map<String, dynamic> specifications;
  final DateTime createdAt;
  final DateTime updatedAt;

  Car({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.year,
    required this.km,
    required this.imageUrl,
    required this.vin,
    required this.fuelType,
    required this.transmission,
    required this.color,
    required this.country,
    required this.city,
    required this.sellerType,
    required this.sellerId,
    required this.sellerName,
    required this.sellerRating,
    this.onOrder = false,
    this.hasHistory = false,
    this.images = const [],
    this.specifications = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      price: json['price'] ?? '',
      year: json['year'] ?? '',
      km: json['km'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      vin: json['vin'] ?? '',
      fuelType: json['fuelType'] ?? '',
      transmission: json['transmission'] ?? '',
      color: json['color'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      sellerType: json['sellerType'] ?? '',
      sellerId: json['sellerId'] ?? '',
      sellerName: json['sellerName'] ?? '',
      sellerRating: (json['sellerRating'] ?? 0.0).toDouble(),
      onOrder: json['onOrder'] ?? false,
      hasHistory: json['hasHistory'] ?? false,
      images: List<String>.from(json['images'] ?? []),
      specifications: Map<String, dynamic>.from(json['specifications'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'price': price,
      'year': year,
      'km': km,
      'imageUrl': imageUrl,
      'vin': vin,
      'fuelType': fuelType,
      'transmission': transmission,
      'color': color,
      'country': country,
      'city': city,
      'sellerType': sellerType,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerRating': sellerRating,
      'onOrder': onOrder,
      'hasHistory': hasHistory,
      'images': images,
      'specifications': specifications,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

