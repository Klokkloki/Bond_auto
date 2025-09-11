enum DealStatus {
  created,
  paymentPending,
  carPurchased,
  inTransit,
  atCustoms,
  registration,
  completed,
  cancelled,
}

enum DealType {
  auction,
  dealer,
  private,
}

class Deal {
  final String id;
  final String carId;
  final String buyerId;
  final String sellerId;
  final DealType type;
  final DealStatus status;
  final double carPrice;
  final double totalPrice;
  final String currency;
  final String sourceCountry;
  final String destinationCountry;
  final String sourceCity;
  final String destinationCity;
  final String logisticsProviderId;
  final String customsBrokerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> tracking;
  final List<DealMessage> messages;
  final Map<String, dynamic> documents;

  Deal({
    required this.id,
    required this.carId,
    required this.buyerId,
    required this.sellerId,
    required this.type,
    required this.status,
    required this.carPrice,
    required this.totalPrice,
    required this.currency,
    required this.sourceCountry,
    required this.destinationCountry,
    required this.sourceCity,
    required this.destinationCity,
    required this.logisticsProviderId,
    required this.customsBrokerId,
    required this.createdAt,
    required this.updatedAt,
    this.tracking = const {},
    this.messages = const [],
    this.documents = const {},
  });

  factory Deal.fromJson(Map<String, dynamic> json) {
    return Deal(
      id: json['id'] ?? '',
      carId: json['carId'] ?? '',
      buyerId: json['buyerId'] ?? '',
      sellerId: json['sellerId'] ?? '',
      type: DealType.values.firstWhere(
        (e) => e.toString() == 'DealType.${json['type']}',
        orElse: () => DealType.private,
      ),
      status: DealStatus.values.firstWhere(
        (e) => e.toString() == 'DealStatus.${json['status']}',
        orElse: () => DealStatus.created,
      ),
      carPrice: (json['carPrice'] ?? 0.0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'EUR',
      sourceCountry: json['sourceCountry'] ?? '',
      destinationCountry: json['destinationCountry'] ?? '',
      sourceCity: json['sourceCity'] ?? '',
      destinationCity: json['destinationCity'] ?? '',
      logisticsProviderId: json['logisticsProviderId'] ?? '',
      customsBrokerId: json['customsBrokerId'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      tracking: Map<String, dynamic>.from(json['tracking'] ?? {}),
      messages: (json['messages'] as List<dynamic>?)
          ?.map((m) => DealMessage.fromJson(m))
          .toList() ?? [],
      documents: Map<String, dynamic>.from(json['documents'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'carId': carId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'carPrice': carPrice,
      'totalPrice': totalPrice,
      'currency': currency,
      'sourceCountry': sourceCountry,
      'destinationCountry': destinationCountry,
      'sourceCity': sourceCity,
      'destinationCity': destinationCity,
      'logisticsProviderId': logisticsProviderId,
      'customsBrokerId': customsBrokerId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'tracking': tracking,
      'messages': messages.map((m) => m.toJson()).toList(),
      'documents': documents,
    };
  }
}

class DealMessage {
  final String id;
  final String dealId;
  final String senderId;
  final String message;
  final String originalLanguage;
  final DateTime createdAt;
  final bool isSystem;

  DealMessage({
    required this.id,
    required this.dealId,
    required this.senderId,
    required this.message,
    required this.originalLanguage,
    required this.createdAt,
    this.isSystem = false,
  });

  factory DealMessage.fromJson(Map<String, dynamic> json) {
    return DealMessage(
      id: json['id'] ?? '',
      dealId: json['dealId'] ?? '',
      senderId: json['senderId'] ?? '',
      message: json['message'] ?? '',
      originalLanguage: json['originalLanguage'] ?? 'ru',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      isSystem: json['isSystem'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dealId': dealId,
      'senderId': senderId,
      'message': message,
      'originalLanguage': originalLanguage,
      'createdAt': createdAt.toIso8601String(),
      'isSystem': isSystem,
    };
  }
}

