import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/deal.dart';
import '../models/car.dart';
import 'deal_detail_screen.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> with SingleTickerProviderStateMixin {
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
        title: const Text('Мои сделки'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Активные'),
            Tab(text: 'Завершенные'),
            Tab(text: 'Отмененные'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDealsList('Активные'),
          _buildDealsList('Завершенные'),
          _buildDealsList('Отмененные'),
        ],
      ),
    );
  }

  Widget _buildDealsList(String status) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final List<Deal> deals = appState.deals.where((deal) {
          switch (status) {
            case 'Активные':
              return deal.status != DealStatus.completed && deal.status != DealStatus.cancelled;
            case 'Завершенные':
              return deal.status == DealStatus.completed;
            case 'Отмененные':
              return deal.status == DealStatus.cancelled;
          }
          return false;
        }).toList();

        if (deals.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.handshake_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'Нет ${status.toLowerCase()} сделок',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: deals.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final deal = deals[index];
            // Найдём краткую инфу об авто
            Car? car;
            try {
              car = Provider.of<AppState>(context, listen: false)
                  .allCars
                  .firstWhere((c) => c.id == deal.carId);
            } catch (_) {
              car = null;
            }

            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DealDetailScreen(deal: deal),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: car != null
                          ? Image.network(
                              car.imageUrl,
                              width: 84,
                              height: 64,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _imageFallback(),
                            )
                          : _imageFallback(width: 84, height: 64),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            car != null ? '${car.title} ${car.subtitle}' : 'Сделка ${deal.id}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.place, size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${deal.sourceCity} → ${deal.destinationCity}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Создана: ${_formatDate(deal.createdAt)}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${deal.totalPrice.toStringAsFixed(0)} ${deal.currency}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _statusColor(deal.status).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _statusText(deal.status),
                            style: TextStyle(
                              color: _statusColor(deal.status),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

Widget _imageFallback({double width = 84, double height = 64}) {
  return Container(
    width: width,
    height: height,
    color: Colors.grey[300],
    child: const Icon(Icons.directions_car),
  );
}

String _statusText(DealStatus status) {
  switch (status) {
    case DealStatus.created:
      return 'Создана';
    case DealStatus.paymentPending:
      return 'Ожидает оплаты';
    case DealStatus.carPurchased:
      return 'Выкуплен';
    case DealStatus.inTransit:
      return 'В пути';
    case DealStatus.atCustoms:
      return 'Таможня';
    case DealStatus.registration:
      return 'Регистрация';
    case DealStatus.completed:
      return 'Завершена';
    case DealStatus.cancelled:
      return 'Отменена';
  }
}

Color _statusColor(DealStatus status) {
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
