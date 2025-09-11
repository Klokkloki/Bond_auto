import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../widgets/profile_header.dart';
import '../services/auth_service.dart';

class LogisticsDashboard extends StatefulWidget {
  const LogisticsDashboard({super.key});

  @override
  State<LogisticsDashboard> createState() => _LogisticsDashboardState();
}

class _LogisticsDashboardState extends State<LogisticsDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _LogiOrders(),
    _RoutesAndRates(),
    _LogiChat(),
    _LogiDocs(),
    _LogiAnalytics(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 10, offset: const Offset(0, -2)),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.colorScheme.onSurfaceVariant,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.local_shipping_outlined), label: 'Заказы'),
            BottomNavigationBarItem(icon: Icon(Icons.alt_route_outlined), label: 'Тарифы'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), label: 'Чат'),
            BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Документы'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Аналитика'),
          ],
        ),
      ),
    );
  }
}

class _LogiOrders extends StatelessWidget {
  const _LogiOrders();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заказы логистики'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LogisticsSettingsScreen())),
          )
        ],
      ),
      body: const Center(child: Text('Список перевозок: статусы, фотофиксация, QR-коды')),
    );
  }
}

class _RoutesAndRates extends StatelessWidget {
  const _RoutesAndRates();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Маршруты и тарифы')),
      body: const Center(child: Text('Направления, тип транспорта, расчёт стоимости')),
    );
  }
}

class _LogiChat extends StatelessWidget {
  const _LogiChat();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Чат')),
      body: const Center(child: Text('Чат с клиентами, отправка фото/видео')),
    );
  }
}

class _LogiDocs extends StatelessWidget {
  const _LogiDocs();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Документы')),
      body: const Center(child: Text('Транспортные накладные, PDF, подпись')),
    );
  }
}

class _LogiAnalytics extends StatelessWidget {
  const _LogiAnalytics();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Аналитика')),
      body: const Center(child: Text('Кол-во перевозок, рейтинг, SLA')),
    );
  }
}

class LogisticsSettingsScreen extends StatelessWidget {
  const LogisticsSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки логиста')),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final user = appState.currentUser;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (user != null) ...[
                Card(child: Padding(padding: const EdgeInsets.all(12), child: ProfileHeader(user: user))),
                const SizedBox(height: 12),
                Card(child: ListTile(leading: const Icon(Icons.badge_outlined), title: const Text('Роль'), subtitle: Text(user.role.toString().split('.').last))),
                const SizedBox(height: 12),
                Card(child: ListTile(leading: const Icon(Icons.location_on_outlined), title: const Text('Локация'), subtitle: Text('${user.city}, ${user.country}'))),
                const SizedBox(height: 12),
                Card(child: ListTile(leading: const Icon(Icons.email_outlined), title: const Text('Email'), subtitle: Text(user.email))),
              ],
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  try { await AuthService.signOut(); } catch (_) {}
                  if (context.mounted) {
                    context.read<AppState>().signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Выйти из аккаунта'),
              ),
            ],
          );
        },
      ),
    );
  }
}
