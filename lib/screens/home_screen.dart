import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../widgets/car_card.dart';
import '../widgets/search_bar.dart' as custom;
// Убраны старые виджеты главной, вместо них — новый дизайн секций
import 'search_screen.dart';
import 'calculator_screen.dart';
import 'deals_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _HomeContent(),
    const SearchScreen(),
    const CalculatorScreen(),
    const DealsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _currentIndex == 0 ? _buildFloatingActionButton() : null,
    );
  }

  Widget _buildBottomNav() {
    final theme = Theme.of(context);
    final navTheme = theme.bottomNavigationBarTheme;

    return Container(
      decoration: BoxDecoration(
        color: navTheme.backgroundColor ?? theme.colorScheme.surface,
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
        selectedItemColor: navTheme.selectedItemColor ?? theme.colorScheme.primary,
        unselectedItemColor: navTheme.unselectedItemColor ?? theme.colorScheme.onSurfaceVariant,
        selectedIconTheme: navTheme.selectedIconTheme ?? IconThemeData(color: theme.colorScheme.primary),
        unselectedIconTheme: navTheme.unselectedIconTheme ?? IconThemeData(color: theme.colorScheme.onSurfaceVariant),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Поиск',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
            activeIcon: Icon(Icons.calculate),
            label: 'Калькулятор',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake_outlined),
            activeIcon: Icon(Icons.handshake),
            label: 'Сделки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    final theme = Theme.of(context);
    return FloatingActionButton(
      onPressed: () {
        // Открыть калькулятор
        setState(() => _currentIndex = 2);
      },
      backgroundColor: theme.colorScheme.primary,
      child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const _BackgroundDecor(),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopRow(theme),
                  const SizedBox(height: 16),
                  // Поле поиска (используем существующий компонент, он уже тема-агностичен)
                  const custom.SearchBar(),
                  const SizedBox(height: 16),
                  // Карточка спецпредложения
                  const _SpecialOfferCard(),
                  const SizedBox(height: 20),
                  // Горизонтальная карусель промо
                  const _PromoCarousel(),
                  const SizedBox(height: 20),
                  // Сетка брендов
                  const _BrandGrid(),
                  const SizedBox(height: 20),
                  // Топовые предложения в виде чипов
                  const _TopDealsChips(),
                  const SizedBox(height: 16),
                  Text(
                    'Персонально для вас',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildCarsGrid(),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow(ThemeData theme) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return Row(
          children: [
            // Аватар пользователя
            CircleAvatar(
              radius: 18,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
              child: Icon(Icons.person, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 12),
            // Имя + бейдж
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    appState.currentUser?.fullName ?? 'Гость',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Row(
                    children: [
                      Icon(Icons.verified, color: Colors.amber[600], size: 16),
                      const SizedBox(width: 4),
                      Text('Премиум', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  )
                ],
              ),
            ),
            _glassCircle(context, icon: Icons.brightness_6_outlined),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                // открыть профиль/настройки
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
              child: _glassCircle(context, icon: Icons.settings_outlined),
            ),
          ],
        );
      },
    );
  }

  Widget _glassCircle(BuildContext context, {required IconData icon}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            // Нейтральное стекло, подстраивается под тему
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
    );
  }

  Widget _buildCarsGrid() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: appState.featuredCars.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.86,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final car = appState.featuredCars[index];
            return CarCard(car: car);
          },
        );
      },
    );
  }
}

class _BackgroundDecor extends StatelessWidget {
  const _BackgroundDecor();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF141516), const Color(0xFF1B1C1E)] // тёмная мягкая заливка
              : [const Color(0xFFFCFCFD), const Color(0xFFF1F4F8)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: (isDark ? Colors.white : Colors.pinkAccent).withOpacity(0.05),
                borderRadius: BorderRadius.circular(120),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: (isDark ? Colors.white : Colors.blueAccent).withOpacity(0.04),
                borderRadius: BorderRadius.circular(120),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Карточка «Special Offer» в стиле мокапа
class _SpecialOfferCard extends StatelessWidget {
  const _SpecialOfferCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.10),
            theme.colorScheme.secondary.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.colorScheme.primary.withOpacity(0.25)),
                  ),
                  child: Text('Скидка 20%', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 12),
                Text('Спецпредложение недели', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(
                  'Доставка и оформление выбранных моделей по выгодной цене. Успейте до конца недели!',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Text('Осталось 3 дня', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 96,
              width: 132,
              child: Image.network(
                'https://images.unsplash.com/photo-1555215695-3004980ad54e?q=80&w=800&auto=format&fit=crop',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(
                  color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  child: Icon(Icons.directions_car, color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoCarousel extends StatelessWidget {
  const _PromoCarousel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final promos = [
      {'title': 'Подбор Mercedes', 'image': 'https://images.unsplash.com/photo-1502877338535-766e1452684a?q=80&w=800&auto=format&fit=crop'},
      {'title': 'Tesla – электродрайв', 'image': 'https://images.unsplash.com/photo-1549921296-3fd62a3bba45?q=80&w=800&auto=format&fit=crop'},
      {'title': 'BMW – динамика', 'image': 'https://images.unsplash.com/photo-1619767886558-efdc259b6b3c?q=80&w=800&auto=format&fit=crop'},
    ];
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: promos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final item = promos[i];
          return AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    item['image']!,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black54, Colors.transparent],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    bottom: 10,
                    right: 12,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item['title']!,
                            style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Круглые кнопки брендов
class _BrandGrid extends StatelessWidget {
  const _BrandGrid();

  IconData _brandIcon(String brand) {
    switch (brand) {
      case 'Mercedes':
        return Icons.star_outline; // стилизованно под звезду
      case 'Tesla':
        return Icons.bolt_outlined;
      case 'BMW':
        return Icons.blur_circular_outlined;
      case 'Toyota':
        return Icons.toys_outlined;
      case 'Audi':
        return Icons.circle_outlined;
      case 'Bentley':
        return Icons.waves_outlined;
      case 'Honda':
        return Icons.h_mobiledata; // условная «H»
      case 'Mini':
        return Icons.flight_takeoff_outlined;
      default:
        return Icons.directions_car;
    }
  }

  Color _brandColor(BuildContext context, String brand) {
    final scheme = Theme.of(context).colorScheme;
    switch (brand) {
      case 'Mercedes':
        return Colors.blueGrey;
      case 'Tesla':
        return Colors.redAccent;
      case 'BMW':
        return Colors.lightBlueAccent;
      case 'Toyota':
        return Colors.red;
      case 'Audi':
        return Colors.black87;
      case 'Bentley':
        return Colors.teal;
      case 'Honda':
        return Colors.indigo;
      case 'Mini':
        return scheme.primary;
      default:
        return scheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brands = ['Mercedes', 'Tesla', 'BMW', 'Toyota', 'Audi', 'Bentley', 'Honda', 'Mini'];
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: brands.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisExtent: 90,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemBuilder: (context, index) {
        final label = brands[index];
        final color = _brandColor(context, label);
        final icon = _brandIcon(label);
        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => SearchScreen(initialBrand: label)),
            );
          },
          child: Column(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color.withOpacity(0.18), color.withOpacity(0.38)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.45)),
                  boxShadow: [
                    BoxShadow(color: color.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 6)),
                  ],
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

// Чипы «Top Deals»
class _TopDealsChips extends StatelessWidget {
  const _TopDealsChips();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = ['Mercedes', 'Tesla', 'BMW', 'Audi', 'Toyota'];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((e) {
        return InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => SearchScreen(initialBrand: e)),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.35)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_fire_department_outlined, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Text(e, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

