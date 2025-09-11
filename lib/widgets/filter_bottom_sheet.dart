import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final int minYear;
  final int maxYear;
  final double minPrice;
  final double maxPrice;
  final int minKm;
  final int maxKm;
  final String source; // 'all' | 'auction' | 'dealer' | 'private'
  final void Function({
    required int minYear,
    required int maxYear,
    required double minPrice,
    required double maxPrice,
    required int minKm,
    required int maxKm,
    required String source,
  }) onApply;

  const FilterBottomSheet({
    super.key,
    required this.minYear,
    required this.maxYear,
    required this.minPrice,
    required this.maxPrice,
    required this.minKm,
    required this.maxKm,
    required this.source,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late RangeValues _year;
  late RangeValues _price;
  late RangeValues _km;
  late String _source;

  @override
  void initState() {
    super.initState();
    _year = RangeValues(widget.minYear.toDouble(), widget.maxYear.toDouble());
    _price = RangeValues(widget.minPrice, widget.maxPrice);
    _km = RangeValues(widget.minKm.toDouble(), widget.maxKm.toDouble());
    _source = widget.source;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Фильтры', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _sectionTitle('Год выпуска'),
            RangeSlider(
              values: _year,
              min: 1990,
              max: DateTime.now().year.toDouble(),
              labels: RangeLabels(_year.start.toInt().toString(), _year.end.toInt().toString()),
              onChanged: (v) => setState(() => _year = v),
            ),
            _valueRow('${_year.start.toInt()}', '${_year.end.toInt()}'),
            const SizedBox(height: 8),
            _sectionTitle('Цена, EUR'),
            RangeSlider(
              values: _price,
              min: 0,
              max: 100000,
              divisions: 100,
              labels: RangeLabels(_price.start.toInt().toString(), _price.end.toInt().toString()),
              onChanged: (v) => setState(() => _price = v),
            ),
            _valueRow('${_price.start.toInt()}', '${_price.end.toInt()}'),
            const SizedBox(height: 8),
            _sectionTitle('Пробег, км'),
            RangeSlider(
              values: _km,
              min: 0,
              max: 300000,
              divisions: 100,
              labels: RangeLabels(_km.start.toInt().toString(), _km.end.toInt().toString()),
              onChanged: (v) => setState(() => _km = v),
            ),
            _valueRow('${_km.start.toInt()}', '${_km.end.toInt()}'),
            const SizedBox(height: 8),
            _sectionTitle('Источник'),
            Wrap(
              spacing: 8,
              children: [
                _choice('all', 'Все'),
                _choice('dealer', 'Дилеры'),
                _choice('auction', 'Аукционы'),
                _choice('private', 'Частники'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(
                    minYear: _year.start.toInt(),
                    maxYear: _year.end.toInt(),
                    minPrice: _price.start,
                    maxPrice: _price.end,
                    minKm: _km.start.toInt(),
                    maxKm: _km.end.toInt(),
                    source: _source,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Применить'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _valueRow(String from, String to) {
    final style = TextStyle(color: Colors.grey[600]);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(from, style: style), Text(to, style: style)],
    );
  }

  Widget _choice(String value, String label) {
    final theme = Theme.of(context);
    final selected = _source == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _source = value),
      selectedColor: theme.colorScheme.primary.withOpacity(0.2),
      labelStyle: TextStyle(color: selected ? theme.colorScheme.primary : theme.colorScheme.onSurface),
    );
  }
}


