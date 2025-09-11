import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import 'kyc_verification_screen.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.currentUser == null) {
            return const SizedBox.shrink();
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(user: appState.currentUser!),
                const SizedBox(height: 20),
                _buildMenuSection(context),
                const SizedBox(height: 20),
                _buildStatsSection(appState),
                const SizedBox(height: 20),
                _buildSupportSection(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ProfileMenuItem(
            icon: Icons.favorite_outline,
            title: 'Избранное',
            onTap: () {
              // Открыть избранное
            },
          ),
          const Divider(height: 1),
          ProfileMenuItem(
            icon: Icons.history,
            title: 'История поиска',
            onTap: () {
              // Открыть историю
            },
          ),
          const Divider(height: 1),
          ProfileMenuItem(
            icon: Icons.notifications_outlined,
            title: 'Уведомления',
            onTap: () {
              // Открыть уведомления
            },
          ),
          const Divider(height: 1),
          ProfileMenuItem(
            icon: Icons.payment_outlined,
            title: 'Способы оплаты',
            onTap: () {
              // Открыть способы оплаты
            },
          ),
          const Divider(height: 1),
          ProfileMenuItem(
            icon: Icons.language,
            title: 'Язык',
            onTap: () {
              // Открыть выбор языка
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(AppState appState) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Статистика',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Сделок',
                  '0',
                  Icons.handshake,
                ),
                _buildStatItem(
                  'Избранных',
                  '12',
                  Icons.favorite,
                ),
                _buildStatItem(
                  'Поисков',
                  '45',
                  Icons.search,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.red, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ProfileMenuItem(
            icon: Icons.help_outline,
            title: 'Помощь и поддержка',
            onTap: () {
              // Открыть помощь
            },
          ),
          const Divider(height: 1),
          ProfileMenuItem(
            icon: Icons.verified_user_outlined,
            title: 'Верификация личности',
            subtitle: 'Подтвердите документы',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const KycVerificationScreen(),
                ),
              );
            },
          ),
          const Divider(height: 1),
          ProfileMenuItem(
            icon: Icons.info_outline,
            title: 'О приложении',
            onTap: () {
              // Открыть о приложении
            },
          ),
          const Divider(height: 1),
          ProfileMenuItem(
            icon: Icons.logout,
            title: 'Выйти',
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выйти из аккаунта'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await AuthService.signOut();
              } catch (_) {}
              if (context.mounted) {
                context.read<AppState>().signOut();
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }

}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          final isDark = appState.themeMode == ThemeMode.dark;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: SwitchListTile(
                  title: const Text('Тёмная тема'),
                  subtitle: const Text('Переключить светлую/тёмную тему'),
                  value: isDark,
                  onChanged: (value) => appState.toggleDarkMode(value),
                  secondary: const Icon(Icons.dark_mode_outlined),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.color_lens_outlined),
                  title: const Text('Цвет акцента'),
                  subtitle: const Text('В разработке'),
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('Уведомления'),
                  subtitle: const Text('Базовые настройки уведомлений'),
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Язык'),
                  subtitle: const Text('В разработке'),
                  onTap: () {},
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}