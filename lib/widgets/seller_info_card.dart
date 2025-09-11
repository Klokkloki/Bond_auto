import 'package:flutter/material.dart';

class SellerInfoCard extends StatelessWidget {
  final String sellerName;
  final String sellerType;
  final double rating;
  final int completedDeals;

  const SellerInfoCard({
    super.key,
    required this.sellerName,
    required this.sellerType,
    required this.rating,
    required this.completedDeals,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Информация о продавце',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sellerName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _getSellerTypeText(sellerType),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getSellerTypeColor(sellerType),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getSellerTypeText(sellerType),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.star, size: 20, color: Colors.amber[600]),
                const SizedBox(width: 8),
                Text(
                  rating.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '($completedDeals сделок)',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Открыть профиль продавца
                },
                icon: const Icon(Icons.person_outline),
                label: const Text('Посмотреть профиль'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSellerTypeText(String type) {
    switch (type) {
      case 'auction':
        return 'Аукцион';
      case 'dealer':
        return 'Дилер';
      case 'private':
        return 'Частное лицо';
      default:
        return 'Продавец';
    }
  }

  Color _getSellerTypeColor(String type) {
    switch (type) {
      case 'auction':
        return Colors.blue;
      case 'dealer':
        return Colors.green;
      case 'private':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}




