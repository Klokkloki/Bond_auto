import 'package:flutter/material.dart';
import '../models/calculator.dart';
import '../widgets/calculation_result_card.dart';
import '../widgets/logistics_provider_card.dart';
import '../widgets/customs_broker_card.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _sourceCountry = 'Германия';
  String _destinationCountry = 'Казахстан';
  String _sourceCity = 'Мюнхен';
  String _destinationCity = 'Алматы';
  double _carPrice = 25000.0;
  String _currency = 'EUR';
  // Расширенные параметры
  String _fuelType = 'petrol'; // petrol | diesel | hybrid | electric
  double _engineVolumeLiters = 2.0;
  int _manufactureYear = 2021;
  bool _isAuction = true;
  
  CalculationResult? _calculationResult;
  List<LogisticsProvider> _logisticsProviders = [];
  List<CustomsBroker> _customsBrokers = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
    _calculate();
  }

  void _loadMockData() {
    _logisticsProviders = [
      LogisticsProvider(
        id: '1',
        name: 'AutoLogistics Pro',
        logo: 'https://via.placeholder.com/50',
        rating: 4.8,
        completedDeals: 1250,
        price: 1200.0,
        days: 12,
        description: 'Быстрая доставка по Европе и СНГ',
        services: ['Морская перевозка', 'Страхование', 'Отслеживание'],
      ),
      LogisticsProvider(
        id: '2',
        name: 'Global Transport',
        logo: 'https://via.placeholder.com/50',
        rating: 4.6,
        completedDeals: 890,
        price: 1450.0,
        days: 9,
        description: 'Премиум сервис с гарантией',
        services: ['Экспресс доставка', 'VIP сопровождение', 'Страхование'],
      ),
    ];

    _customsBrokers = [
      CustomsBroker(
        id: '1',
        name: 'Customs Expert',
        logo: 'https://via.placeholder.com/50',
        rating: 4.9,
        completedDeals: 2100,
        price: 300.0,
        days: 3,
        description: 'Полное оформление документов',
        countries: ['Казахстан', 'Россия', 'Беларусь'],
      ),
      CustomsBroker(
        id: '2',
        name: 'Import Solutions',
        logo: 'https://via.placeholder.com/50',
        rating: 4.7,
        completedDeals: 1650,
        price: 250.0,
        days: 5,
        description: 'Быстрое оформление',
        countries: ['Казахстан', 'Узбекистан', 'Кыргызстан'],
      ),
    ];
  }

  void _calculate() {
    final calculator = ImportCalculator(
      carId: '1',
      sourceCountry: _sourceCountry,
      destinationCountry: _destinationCountry,
      sourceCity: _sourceCity,
      destinationCity: _destinationCity,
      carPrice: _carPrice,
      currency: _currency,
      calculationDate: DateTime.now(),
      fuelType: _fuelType,
      engineVolumeLiters: _engineVolumeLiters,
      manufactureYear: _manufactureYear,
      isAuction: _isAuction,
    );
    
    setState(() {
      _calculationResult = calculator.calculate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор импорта'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputSection(),
            const SizedBox(height: 20),
            if (_calculationResult != null) ...[
              CalculationResultCard(result: _calculationResult!),
              const SizedBox(height: 20),
              _buildLogisticsSection(),
              const SizedBox(height: 20),
              _buildCustomsSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Параметры расчета',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _sourceCountry,
                    decoration: const InputDecoration(labelText: 'Страна источника'),
                    items: ['Германия', 'США', 'ОАЭ', 'Япония']
                        .map((country) => DropdownMenuItem(
                              value: country,
                              child: Text(country),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _sourceCountry = value!;
                        _calculate();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _destinationCountry,
                    decoration: const InputDecoration(labelText: 'Страна назначения'),
                    items: ['Казахстан', 'Россия', 'Беларусь', 'Узбекистан']
                        .map((country) => DropdownMenuItem(
                              value: country,
                              child: Text(country),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _destinationCountry = value!;
                        _calculate();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Город источника'),
                    initialValue: _sourceCity,
                    onChanged: (value) {
                      _sourceCity = value;
                      _calculate();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Город назначения'),
                    initialValue: _destinationCity,
                    onChanged: (value) {
                      _destinationCity = value;
                      _calculate();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Цена автомобиля'),
                    keyboardType: TextInputType.number,
                    initialValue: _carPrice.toString(),
                    onChanged: (value) {
                      _carPrice = double.tryParse(value) ?? 0.0;
                      _calculate();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _currency,
                    decoration: const InputDecoration(labelText: 'Валюта'),
                    items: ['EUR', 'USD', 'AED', 'JPY', 'RUB']
                        .map((currency) => DropdownMenuItem(
                              value: currency,
                              child: Text(currency),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _currency = value!;
                        _calculate();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Расширенные параметры (топливо/объём/год/аукцион)
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _fuelType,
                    decoration: const InputDecoration(labelText: 'Топливо'),
                    items: const [
                      DropdownMenuItem(value: 'petrol', child: Text('Бензин')),
                      DropdownMenuItem(value: 'diesel', child: Text('Дизель')),
                      DropdownMenuItem(value: 'hybrid', child: Text('Гибрид')),
                      DropdownMenuItem(value: 'electric', child: Text('Электро')),
                    ],
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() {
                        _fuelType = v;
                        _calculate();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Объём, л'),
                    initialValue: _engineVolumeLiters.toStringAsFixed(1),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (v) {
                      final parsed = double.tryParse(v.replaceAll(',', '.'));
                      if (parsed != null) {
                        _engineVolumeLiters = parsed;
                        _calculate();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _manufactureYear,
                    decoration: const InputDecoration(labelText: 'Год выпуска'),
                    items: List<int>.generate(30, (i) => DateTime.now().year - i)
                        .map((y) => DropdownMenuItem(value: y, child: Text(y.toString())))
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() {
                        _manufactureYear = v;
                        _calculate();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CheckboxListTile(
                    value: _isAuction,
                    onChanged: (v) {
                      setState(() {
                        _isAuction = v ?? false;
                        _calculate();
                      });
                    },
                    dense: true,
                    title: const Text('Покупка на аукционе'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Логистические компании',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ..._logisticsProviders.map(
          (provider) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: LogisticsProviderCard(provider: provider),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Таможенные брокеры',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ..._customsBrokers.map(
          (broker) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CustomsBrokerCard(broker: broker),
          ),
        ),
      ],
    );
  }
}
