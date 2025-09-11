import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../widgets/profile_header.dart';
import '../services/auth_service.dart';

class BrokerDashboard extends StatefulWidget {
  const BrokerDashboard({super.key});

  @override
  State<BrokerDashboard> createState() => _BrokerDashboardState();
}

class _BrokerDashboardState extends State<BrokerDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _BrokerQueue(),
    _DutiesCalc(),
    _BrokerDocs(),
    _BrokerChat(),
    _BrokerReports(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 10, offset: const Offset(0, -2))],
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
            BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Очередь'),
            BottomNavigationBarItem(icon: Icon(Icons.calculate_outlined), label: 'Пошлины'),
            BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Документы'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), label: 'Чат'),
            BottomNavigationBarItem(icon: Icon(Icons.assessment_outlined), label: 'Отчёты'),
          ],
        ),
      ),
    );
  }
}

class _BrokerQueue extends StatelessWidget {
  const _BrokerQueue();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Очередь заказов'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BrokerSettingsScreen())),
          )
        ],
      ),
      body: const Center(child: Text('Список авто для растаможки, приоритеты')),
    );
  }
}

class _DutiesCalc extends StatelessWidget {
  const _DutiesCalc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Расчёт пошлин')),
      body: const Center(child: Text('Интеграция с калькулятором, ручная корректировка')),
    );
  }
}

class _BrokerDocs extends StatelessWidget {
  const _BrokerDocs();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Документы')),
      body: const Center(child: Text('Генерация ПТС, акты, шаблоны для печати')),
    );
  }
}

class _BrokerChat extends StatelessWidget {
  const _BrokerChat();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Чат')),
      body: const Center(child: Text('Консультации с клиентами, отправка чеков')),
    );
  }
}

class _BrokerReports extends StatelessWidget {
  const _BrokerReports();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Отчёты')),
      body: const Center(child: Text('Статистика операций, история заказов')),
    );
  }
}

class BrokerSettingsScreen extends StatelessWidget {
  const BrokerSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки брокера')),
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
