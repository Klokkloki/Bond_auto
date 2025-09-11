import 'package:flutter/material.dart';
import '../models/deal.dart';

class DealDocuments extends StatelessWidget {
  final Deal deal;

  const DealDocuments({super.key, required this.deal});

  @override
  Widget build(BuildContext context) {
    final documents = _getDocuments();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents[index];
        return _buildDocumentCard(document);
      },
    );
  }

  Widget _buildDocumentCard(DocumentItem document) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getDocumentColor(document.type),
          child: Icon(
            _getDocumentIcon(document.type),
            color: Colors.white,
          ),
        ),
        title: Text(document.name),
        subtitle: Text(document.description),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (document.isReady)
              const Icon(Icons.check_circle, color: Colors.green)
            else
              const Icon(Icons.schedule, color: Colors.orange),
            Text(
              document.isReady ? 'Готов' : 'В процессе',
              style: TextStyle(
                fontSize: 10,
                color: document.isReady ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
        onTap: () {
          // Открыть документ
        },
      ),
    );
  }

  List<DocumentItem> _getDocuments() {
    return [
      DocumentItem(
        name: 'Договор купли-продажи',
        description: 'Основной договор между покупателем и продавцом',
        type: DocumentType.contract,
        isReady: true,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      DocumentItem(
        name: 'Инвойс',
        description: 'Счет-фактура на автомобиль',
        type: DocumentType.invoice,
        isReady: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      DocumentItem(
        name: 'Страховой полис',
        description: 'Страхование груза на время транспортировки',
        type: DocumentType.insurance,
        isReady: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      DocumentItem(
        name: 'Таможенная декларация',
        description: 'Документы для таможенного оформления',
        type: DocumentType.customs,
        isReady: false,
        createdAt: null,
      ),
      DocumentItem(
        name: 'Сертификат соответствия',
        description: 'Сертификат технического соответствия',
        type: DocumentType.certificate,
        isReady: false,
        createdAt: null,
      ),
      DocumentItem(
        name: 'Акт приема-передачи',
        description: 'Акт передачи автомобиля покупателю',
        type: DocumentType.transfer,
        isReady: false,
        createdAt: null,
      ),
    ];
  }

  IconData _getDocumentIcon(DocumentType type) {
    switch (type) {
      case DocumentType.contract:
        return Icons.description;
      case DocumentType.invoice:
        return Icons.receipt;
      case DocumentType.insurance:
        return Icons.security;
      case DocumentType.customs:
        return Icons.account_balance;
      case DocumentType.certificate:
        return Icons.verified;
      case DocumentType.transfer:
        return Icons.handshake;
    }
  }

  Color _getDocumentColor(DocumentType type) {
    switch (type) {
      case DocumentType.contract:
        return Colors.blue;
      case DocumentType.invoice:
        return Colors.green;
      case DocumentType.insurance:
        return Colors.purple;
      case DocumentType.customs:
        return Colors.orange;
      case DocumentType.certificate:
        return Colors.teal;
      case DocumentType.transfer:
        return Colors.red;
    }
  }
}

class DocumentItem {
  final String name;
  final String description;
  final DocumentType type;
  final bool isReady;
  final DateTime? createdAt;

  DocumentItem({
    required this.name,
    required this.description,
    required this.type,
    required this.isReady,
    this.createdAt,
  });
}

enum DocumentType {
  contract,
  invoice,
  insurance,
  customs,
  certificate,
  transfer,
}




