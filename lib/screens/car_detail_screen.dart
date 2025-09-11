import 'package:flutter/material.dart';
import '../models/car.dart';
import '../models/calculator.dart';
import '../widgets/car_image_gallery.dart';
import '../widgets/calculation_result_card.dart';
import '../widgets/seller_info_card.dart';

class CarDetailScreen extends StatefulWidget {
  final Car car;

  const CarDetailScreen({super.key, required this.car});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  CalculationResult? _calculationResult;
  bool _isCalculating = false;
  // Управляемые параметры для расчёта
  double _engineVolume = 2.0;
  String _fuel = 'Бензин';

  @override
  void initState() {
    super.initState();
    _calculateImport();
  }

  void _calculateImport() {
    setState(() {
      _isCalculating = true;
    });

    // Имитация расчета
    Future.delayed(const Duration(seconds: 1), () {
      final calculator = ImportCalculator(
        carId: widget.car.id,
        sourceCountry: widget.car.country,
        destinationCountry: 'Казахстан', // По умолчанию
        sourceCity: widget.car.city,
        destinationCity: 'Алматы',
        carPrice: double.tryParse(widget.car.price.replaceAll(RegExp(r'[^\d]'), '')) ?? 0.0,
        currency: 'EUR',
        calculationDate: DateTime.now(),
        fuelType: widget.car.fuelType,
        engineVolumeLiters: _engineVolume,
        manufactureYear: int.tryParse(widget.car.year) ?? DateTime.now().year,
        isAuction: widget.car.sellerType == 'auction',
      );

      setState(() {
        _calculationResult = calculator.calculate();
        _isCalculating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarImageGallery(images: widget.car.images),
                _buildCarInfo(),
                _buildSpecifications(),
                _buildSellerInfo(),
                if (_isCalculating) _buildCalculatingIndicator(),
                if (_calculationResult != null) _buildCalculationResult(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.car.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.directions_car, size: 64),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.car.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.car.subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  widget.car.price,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              if (widget.car.onOrder)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'На заказ',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildInfoChip(Icons.calendar_today, widget.car.year),
              _buildInfoChip(Icons.speed, widget.car.km),
              _buildInfoChip(Icons.local_gas_station, widget.car.fuelType),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildInfoChip(Icons.settings, widget.car.transmission),
              _buildInfoChip(Icons.palette, widget.car.color),
              _buildInfoChip(Icons.location_on, '${widget.car.city}, ${widget.car.country}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildSpecifications() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Характеристики',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSpecRow('VIN', widget.car.vin),
                  const Divider(),
                  _buildSpecRow('Тип кузова', 'Седан'),
                  const Divider(),
                  _buildSpecRow('Объем двигателя', '2.0 л'),
                  const Divider(),
                  _buildSpecRow('Мощность', '184 л.с.'),
                  const Divider(),
                  _buildSpecRow('Привод', 'Полный'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSellerInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SellerInfoCard(
        sellerName: widget.car.sellerName,
        sellerType: widget.car.sellerType,
        rating: widget.car.sellerRating,
        completedDeals: 150,
      ),
    );
  }

  Widget _buildCalculatingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text('Рассчитываем стоимость доставки...'),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculationResult() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Стоимость доставки',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildCalculatorControls(),
          const SizedBox(height: 12),
          CalculationResultCard(result: _calculationResult!),
        ],
      ),
    );
  }

  Widget _buildCalculatorControls() {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Параметры расчёта', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _fuel,
                    items: const [
                      DropdownMenuItem(value: 'Бензин', child: Text('Бензин')),
                      DropdownMenuItem(value: 'Дизель', child: Text('Дизель')),
                      DropdownMenuItem(value: 'Гибрид', child: Text('Гибрид')),
                      DropdownMenuItem(value: 'Электро', child: Text('Электро')),
                    ],
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() {
                        _fuel = v;
                        _calculateImport();
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Топливо'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    initialValue: _engineVolume.toStringAsFixed(1),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Объём, л'),
                    onFieldSubmitted: (v) {
                      final parsed = double.tryParse(v.replaceAll(',', '.'));
                      if (parsed != null) {
                        setState(() {
                          _engineVolume = parsed;
                          _calculateImport();
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // Добавить в избранное
              },
              icon: const Icon(Icons.favorite_border),
              label: const Text('В избранное'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // Начать сделку
              },
              icon: const Icon(Icons.handshake),
              label: const Text('Купить'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
