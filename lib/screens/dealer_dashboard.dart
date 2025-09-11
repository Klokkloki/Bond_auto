import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../widgets/profile_header.dart';
import '../services/auth_service.dart';

class DealerDashboard extends StatefulWidget {
  const DealerDashboard({super.key});

  @override
  State<DealerDashboard> createState() => _DealerDashboardState();
}

class _DealerDashboardState extends State<DealerDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _DealerShowcase(),
    _ImportCars(),
    _StaffManagement(),
    _DealerAnalytics(),
    _DealerFinance(),
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
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
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
            BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), label: 'Витрина'),
            BottomNavigationBarItem(icon: Icon(Icons.upload_file_outlined), label: 'Импорт'),
            BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: 'Персонал'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Аналитика'),
            BottomNavigationBarItem(icon: Icon(Icons.payments_outlined), label: 'Финансы'),
          ],
        ),
      ),
    );
  }
}

class _DealerShowcase extends StatelessWidget {
  const _DealerShowcase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Витрина дилера'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const DealerSettingsScreen()),
              );
            },
          )
        ],
      ),
      body: const Center(child: Text('Публичный профиль салона (логотип, контакты, отзывы)')),
    );
  }
}

class _ImportCars extends StatelessWidget {
  const _ImportCars();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Импорт авто')),
      body: const Center(child: Text('Excel / API, проверка VIN, предпросмотр импорта')),
    );
  }
}

class _StaffManagement extends StatelessWidget {
  const _StaffManagement();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Персонал')),
      body: const Center(child: Text('Добавление менеджеров, роли и права')),
    );
  }
}

class _DealerAnalytics extends StatelessWidget {
  const _DealerAnalytics();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Аналитика')),
      body: const Center(child: Text('Продажи по моделям, отчёты по регионам, спрос')),
    );
  }
}

class _DealerFinance extends StatelessWidget {
  const _DealerFinance();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Финансы')),
      body: const Center(child: Text('Выплаты по сделкам, распределение доходов')),
    );
  }
}

class DealerSettingsScreen extends StatelessWidget {
  const DealerSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки дилера')),
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
