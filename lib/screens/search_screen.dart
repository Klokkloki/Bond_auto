import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/car.dart';
import '../services/app_state.dart';
import '../widgets/car_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import 'car_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final String? initialBrand;

  const SearchScreen({super.key, this.initialBrand});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCountry = 'Все страны';
  String _selectedSellerType = 'Все типы';
  // Расширенные фильтры
  int _minYear = 1990;
  int _maxYear = 2025;
  double _minPrice = 0;
  double _maxPrice = 100000;
  int _minKm = 0;
  int _maxKm = 300000;
  String _source = 'all';

  @override
  void initState() {
    super.initState();
    if (widget.initialBrand != null && widget.initialBrand!.isNotEmpty) {
      _searchController.text = widget.initialBrand!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск автомобилей'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _showFilterBottomSheet(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchSection(),
          _buildFilterChips(),
          Expanded(
            child: _buildCarsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Марка, модель, VIN',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => _searchController.clear(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.35),
        ),
        onChanged: (value) {
          // Обновить результаты поиска
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('Все страны', _selectedCountry),
          const SizedBox(width: 8),
          _buildFilterChip('Германия', _selectedCountry),
          const SizedBox(width: 8),
          _buildFilterChip('США', _selectedCountry),
          const SizedBox(width: 8),
          _buildFilterChip('ОАЭ', _selectedCountry),
          const SizedBox(width: 8),
          _buildFilterChip('Аукционы', _selectedSellerType),
          const SizedBox(width: 8),
          _buildFilterChip('Дилеры', _selectedSellerType),
          const SizedBox(width: 8),
          _buildFilterChip('Частники', _selectedSellerType),
          const SizedBox(width: 8),
          ActionChip(
            label: const Text('Расширенные'),
            onPressed: () => _showFilterBottomSheet(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String selectedValue) {
    final isSelected = selectedValue == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (label.contains('страны') || label == 'Германия' || label == 'США' || label == 'ОАЭ') {
            _selectedCountry = selected ? label : 'Все страны';
          } else {
            _selectedSellerType = selected ? label : 'Все типы';
          }
        });
      },
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.20),
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildCarsList() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final all = appState.allCars;
        final brand = widget.initialBrand;
        List<Car> cars = all;

        if (brand != null && brand.isNotEmpty) {
          cars = all.where((c) => c.title.toLowerCase().contains(brand.toLowerCase())).toList();
        }
        if (_searchController.text.isNotEmpty) {
          final q = _searchController.text.toLowerCase();
          cars = cars.where((c) => c.title.toLowerCase().contains(q) || c.subtitle.toLowerCase().contains(q) || c.vin.toLowerCase().contains(q)).toList();
        }

        // Источник
        if (_source != 'all') {
          cars = cars.where((c) => c.sellerType == _source).toList();
        }
        // Год
        cars = cars.where((c) {
          final year = int.tryParse(c.year) ?? 0;
          return year >= _minYear && year <= _maxYear;
        }).toList();
        // Цена
        cars = cars.where((c) {
          final price = double.tryParse(c.price.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
          return price >= _minPrice && price <= _maxPrice;
        }).toList();
        // Пробег
        cars = cars.where((c) {
          final km = int.tryParse(c.km.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
          return km >= _minKm && km <= _maxKm;
        }).toList();
        
        if (cars.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Автомобили не найдены',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: cars.length,
          itemBuilder: (context, index) {
            final car = cars[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => CarDetailScreen(car: car)),
                  );
                },
                child: CarCard(car: car, isHorizontal: true),
              ),
            );
          },
        );
      },
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(
        minYear: _minYear,
        maxYear: _maxYear,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        minKm: _minKm,
        maxKm: _maxKm,
        source: _source,
        onApply: ({required minYear, required maxYear, required minPrice, required maxPrice, required minKm, required maxKm, required source}) {
          setState(() {
            _minYear = minYear;
            _maxYear = maxYear;
            _minPrice = minPrice;
            _maxPrice = maxPrice;
            _minKm = minKm;
            _maxKm = maxKm;
            _source = source;
          });
        },
      ),
    );
  }
}
