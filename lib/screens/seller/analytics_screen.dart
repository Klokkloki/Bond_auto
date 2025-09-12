import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Статистика')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StatTile(icon: Icons.visibility, title: 'Просмотры', value: '1 245'),
          _StatTile(icon: Icons.favorite, title: 'Лайки', value: '312'),
          _StatTile(icon: Icons.chat, title: 'Сообщения', value: '78'),
          const SizedBox(height: 16),
          _SectionHeader(icon: Icons.price_change, title: 'Рекомендации по цене', subtitle: 'На основе рынка'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.lightbulb_outline),
              title: const Text('Снизить цену на BMW 3 Series на 3%'),
              subtitle: const Text('Средняя цена аналогов: 24 300 €'),
              trailing: TextButton(onPressed: () {}, child: const Text('Применить')),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  const _SectionHeader({required this.icon, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              if (subtitle != null)
                Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon; final String title; final String value;
  const _StatTile({required this.icon, required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title),
        trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
    );
  }
}


