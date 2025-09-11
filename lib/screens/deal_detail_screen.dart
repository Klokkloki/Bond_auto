import 'package:flutter/material.dart';
import '../models/deal.dart';
import '../widgets/deal_timeline.dart';
import '../widgets/deal_chat.dart';
import '../widgets/deal_documents.dart';

class DealDetailScreen extends StatefulWidget {
  final Deal deal;

  const DealDetailScreen({super.key, required this.deal});

  @override
  State<DealDetailScreen> createState() => _DealDetailScreenState();
}

class _DealDetailScreenState extends State<DealDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Сделка #${widget.deal.id}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Статус'),
            Tab(text: 'Чат'),
            Tab(text: 'Документы'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStatusTab(),
          _buildChatTab(),
          _buildDocumentsTab(),
        ],
      ),
    );
  }

  Widget _buildStatusTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDealInfo(),
          const SizedBox(height: 20),
          _buildPriceBreakdown(),
          const SizedBox(height: 20),
          DealTimeline(deal: widget.deal),
        ],
      ),
    );
  }

  Widget _buildDealInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getStatusText(widget.deal.status),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(widget.deal.status),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(widget.deal.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(widget.deal.status),
                    style: TextStyle(
                      color: _getStatusColor(widget.deal.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Автомобиль', 'BMW 3 Series'),
            _buildInfoRow('Откуда', '${widget.deal.sourceCity}, ${widget.deal.sourceCountry}'),
            _buildInfoRow('Куда', '${widget.deal.destinationCity}, ${widget.deal.destinationCountry}'),
            _buildInfoRow('Создана', _formatDate(widget.deal.createdAt)),
            _buildInfoRow('Обновлена', _formatDate(widget.deal.updatedAt)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Стоимость',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPriceRow('Цена автомобиля', widget.deal.carPrice, widget.deal.currency),
            _buildPriceRow('Доставка', 1200.0, widget.deal.currency),
            _buildPriceRow('Таможня', 800.0, widget.deal.currency),
            _buildPriceRow('Оформление', 300.0, widget.deal.currency),
            const Divider(),
            _buildPriceRow(
              'Итого',
              widget.deal.totalPrice,
              widget.deal.currency,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, String currency, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${amount.toStringAsFixed(0)} $currency',
            style: TextStyle(
              color: isTotal
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    return DealChat(deal: widget.deal);
  }

  Widget _buildDocumentsTab() {
    return DealDocuments(deal: widget.deal);
  }

  String _getStatusText(DealStatus status) {
    switch (status) {
      case DealStatus.created:
        return 'Создана';
      case DealStatus.paymentPending:
        return 'Ожидает оплаты';
      case DealStatus.carPurchased:
        return 'Автомобиль выкуплен';
      case DealStatus.inTransit:
        return 'В пути';
      case DealStatus.atCustoms:
        return 'На таможне';
      case DealStatus.registration:
        return 'Регистрация';
      case DealStatus.completed:
        return 'Завершена';
      case DealStatus.cancelled:
        return 'Отменена';
    }
  }

  Color _getStatusColor(DealStatus status) {
    switch (status) {
      case DealStatus.created:
        return Colors.blue;
      case DealStatus.paymentPending:
        return Colors.orange;
      case DealStatus.carPurchased:
        return Colors.purple;
      case DealStatus.inTransit:
        return Colors.indigo;
      case DealStatus.atCustoms:
        return Colors.teal;
      case DealStatus.registration:
        return Colors.green;
      case DealStatus.completed:
        return Colors.green;
      case DealStatus.cancelled:
        return Colors.red;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}
