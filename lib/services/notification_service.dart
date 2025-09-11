class NotificationService {
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    // Простая заглушка для уведомлений
    print('Notification: $title - $body');
  }

  static Future<void> showDealStatusNotification({
    required String dealId,
    required String status,
    required String carTitle,
  }) async {
    await showNotification(
      id: dealId.hashCode,
      title: 'Обновление сделки',
      body: 'Статус сделки по $carTitle изменен на: $status',
      payload: 'deal:$dealId',
    );
  }

  static Future<void> showMessageNotification({
    required String dealId,
    required String senderName,
    required String message,
  }) async {
    await showNotification(
      id: '${dealId}_${DateTime.now().millisecondsSinceEpoch}'.hashCode,
      title: 'Новое сообщение от $senderName',
      body: message,
      payload: 'message:$dealId',
    );
  }

  static Future<void> showCalculationReadyNotification({
    required String carTitle,
    required double totalPrice,
    required String currency,
  }) async {
    await showNotification(
      id: 'calculation_${DateTime.now().millisecondsSinceEpoch}'.hashCode,
      title: 'Расчет готов',
      body: 'Стоимость доставки $carTitle: ${totalPrice.toStringAsFixed(0)} $currency',
      payload: 'calculation',
    );
  }
}
