import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import 'profile_screen.dart';
import '../widgets/profile_header.dart';
import '../services/auth_service.dart';

class SellerDashboard extends StatefulWidget {
  const SellerDashboard({super.key});

  @override
  State<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _SellerHome(),
    const _AddListing(),
    const _MyListings(),
    const _Analytics(),
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
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Дашборд',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle),
              label: 'Добавить',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              activeIcon: Icon(Icons.list),
              label: 'Мои лоты',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              activeIcon: Icon(Icons.analytics),
              label: 'Аналитика',
            ),
          ],
        ),
      ),
    );
  }
}

class _SellerHome extends StatelessWidget {
  const _SellerHome();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Панель продавца'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SellerSettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Статистика
            _buildStatsCard(theme),
            const SizedBox(height: 20),

            // Быстрые действия
            Text(
              'Быстрые действия',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildQuickActions(theme),
            const SizedBox(height: 20),

            // Последние лоты
            Text(
              'Последние лоты',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildRecentListings(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Активные лоты', '12', Icons.car_rental, theme),
              ),
              Expanded(
                child: _buildStatItem('Продано', '8', Icons.check_circle, theme),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Просмотры', '1.2K', Icons.visibility, theme),
              ),
              Expanded(
                child: _buildStatItem('Рейтинг', '4.8', Icons.star, theme),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, ThemeData theme) {
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(ThemeData theme) {
    final actions = [
      {'title': 'Добавить лот', 'icon': Icons.add, 'color': Colors.blue},
      {'title': 'Загрузить фото', 'icon': Icons.photo_camera, 'color': Colors.green},
      {'title': 'Настройки', 'icon': Icons.settings, 'color': Colors.orange},
      {'title': 'Помощь', 'icon': Icons.help, 'color': Colors.purple},
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Обработка нажатия
          },
          child: Container(
            decoration: BoxDecoration(
              color: (action['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (action['color'] as Color).withOpacity(0.3),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  action['icon'] as IconData,
                  color: action['color'] as Color,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  action['title'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentListings(ThemeData theme) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: appState.allCars.take(3).length,
          itemBuilder: (context, index) {
            final car = appState.allCars[index];
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
                title: Text(car.title),
                subtitle: Text('${car.year} • ${car.km} • ${car.price} EUR'),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AddListing extends StatelessWidget {
  const _AddListing();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Добавление лота (в разработке)'),
      ),
    );
  }
}

class _MyListings extends StatelessWidget {
  const _MyListings();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Мои лоты (в разработке)'),
      ),
    );
  }
}

class _Analytics extends StatelessWidget {
  const _Analytics();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Аналитика (в разработке)'),
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
