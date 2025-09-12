import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Мои авто')),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final cars = appState.allCars;
          if (cars.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.directions_car_outlined, size: 48, color: theme.colorScheme.primary),
                    const SizedBox(height: 12),
                    Text('Пока нет лотов', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text('Добавьте авто во вкладке "Добавить".', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      car.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Container(
                        width: 60,
                        height: 60,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.directions_car),
                      ),
                    ),
                  ),
                  title: Text('${car.title} • ${car.subtitle}'),
                  subtitle: Row(
                    children: [
                      _statusChip(theme, car.onOrder ? 'в пути' : 'активно', car.onOrder ? Colors.orange : Colors.green),
                      const SizedBox(width: 8),
                      Text('${car.price} €', style: theme.textTheme.labelLarge),
                    ],
                  ),
                  trailing: const Icon(Icons.more_vert),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _statusChip(ThemeData theme, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(text, style: theme.textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w700)),
    );
  }
}


