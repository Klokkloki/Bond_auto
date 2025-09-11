import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../widgets/profile_header.dart';
import '../services/auth_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _AdminHome(),
    _Moderation(),
    _AdminFinance(),
    _AdminAnalytics(),
    _Support(),
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
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Дашборд'),
            BottomNavigationBarItem(icon: Icon(Icons.verified_user_outlined), label: 'Модерация'),
            BottomNavigationBarItem(icon: Icon(Icons.payments_outlined), label: 'Финансы'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Аналитика'),
            BottomNavigationBarItem(icon: Icon(Icons.support_agent_outlined), label: 'Поддержка'),
          ],
        ),
      ),
    );
  }
}

class _AdminHome extends StatelessWidget {
  const _AdminHome();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Админ: дашборд'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminSettingsScreen())),
          )
        ],
      ),
      body: const Center(child: Text('Пользователи, сделки, проблемные заказы')),
    );
  }
}

class _Moderation extends StatelessWidget {
  const _Moderation();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Модерация')),
      body: const Center(child: Text('Проверка объявлений, блокировки')),
    );
  }
}

class _AdminFinance extends StatelessWidget {
  const _AdminFinance();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Финансы')),
      body: const Center(child: Text('Комиссии, расчёты с партнёрами')),
    );
  }
}

class _AdminAnalytics extends StatelessWidget {
  const _AdminAnalytics();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Аналитика')),
      body: const Center(child: Text('Страны, регионы, топ-участники')),
    );
  }
}

class _Support extends StatelessWidget {
  const _Support();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Техподдержка')),
      body: const Center(child: Text('Обращения пользователей, SLA')),
    );
  }
}

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки администратора')),
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
