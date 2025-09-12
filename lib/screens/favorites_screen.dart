import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../widgets/car_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.tune_outlined),
            onSelected: (v) {},
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'sort_price', child: Text('Сортировать по цене')),
              PopupMenuItem(value: 'sort_year', child: Text('Сортировать по году')),
              PopupMenuItem(value: 'clear', child: Text('Очистить избранное')),
            ],
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final items = appState.favoriteCars;
          if (items.isEmpty) {
            return _EmptyState(theme: theme);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final car = items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CarCard(car: car, isHorizontal: true),
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ThemeData theme;
  const _EmptyState({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text('Пока пусто', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('Добавляйте авто в избранное с карточек на главной.', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}


