import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../widgets/profile_header.dart';
import '../services/auth_service.dart';
import 'seller/my_listings_screen.dart';
import 'seller/add_listing_screen.dart';
import 'seller/messages_screen.dart';
import 'seller/analytics_screen.dart';
import 'seller/finance_screen.dart';

class SellerDashboard extends StatefulWidget {
  const SellerDashboard({super.key});

  @override
  State<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    MyListingsScreen(),
    AddListingScreen(),
    MessagesScreen(),
    AnalyticsScreen(),
    FinanceScreen(),
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
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.colorScheme.onSurfaceVariant,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car_outlined),
              activeIcon: Icon(Icons.directions_car),
              label: 'Мои авто',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle),
              label: 'Добавить',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Сообщения',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              activeIcon: Icon(Icons.analytics),
              label: 'Статистика',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet),
              label: 'Финансы',
            ),
          ],
        ),
      ),
    );
  }
}

class SellerSettingsScreen extends StatelessWidget {
  const SellerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки продавца'),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final user = appState.currentUser;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (user != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: ProfileHeader(user: user),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.badge_outlined),
                    title: const Text('Роль'),
                    subtitle: Text(user.role.toString().split('.').last),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: const Text('Локация'),
                    subtitle: Text('${user.city}, ${user.country}'),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: const Text('Email'),
                    subtitle: Text(user.email),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await AuthService.signOut();
                  } catch (_) {}
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
