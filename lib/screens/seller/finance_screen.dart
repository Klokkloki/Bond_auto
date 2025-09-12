import 'package:flutter/material.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Финансы')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(icon: Icons.bar_chart, title: 'Доходы по месяцам', subtitle: 'Демонстрационные данные'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Сентябрь 2025'),
              trailing: Text('+1 250 €', style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.w700)),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Август 2025'),
              trailing: Text('+980 €', style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 16),
          _SectionHeader(icon: Icons.account_balance, title: 'Выплаты из эскроу', subtitle: 'Статусы переводов'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.payments_outlined),
              title: const Text('Выплата #28431'),
              subtitle: const Text('Ожидает подтверждения'),
              trailing: _statusChip(theme, 'в обработке', Colors.orange),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.payments_outlined),
              title: const Text('Выплата #28412'),
              subtitle: const Text('Зачислено 12.09'),
              trailing: _statusChip(theme, 'зачислено', Colors.green),
            ),
          ),
          const SizedBox(height: 16),
          _SectionHeader(icon: Icons.handshake, title: 'Активные сделки', subtitle: 'Статусы и суммы'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.directions_car_filled_outlined),
              title: const Text('BMW 3 Series'),
              subtitle: const Text('Эскроу: 25 000 €'),
              trailing: _statusChip(theme, 'в пути', Colors.blue),
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

Widget _statusChip(ThemeData theme, String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withOpacity(0.4)),
    ),
    child: Text(
      text,
      style: theme.textTheme.labelSmall?.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}


