import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/app_state.dart';
import '../../models/user.dart';
import '../../screens/home_screen.dart';
import '../../screens/seller_dashboard.dart';
import '../../screens/dealer_dashboard.dart';
import '../../screens/logistics_dashboard.dart';
import '../../screens/broker_dashboard.dart';
import '../../screens/admin_dashboard.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  UserRole _selectedRole = UserRole.buyer;
  String _selectedCountry = 'Казахстан';
  String _selectedCity = 'Алматы';

  final List<String> _countries = [
    'Казахстан',
    'Россия',
    'Узбекистан',
    'Кыргызстан',
    'Таджикистан',
  ];

  final Map<String, List<String>> _cities = {
    'Казахстан': ['Алматы', 'Нур-Султан', 'Шымкент', 'Актобе', 'Тараз'],
    'Россия': ['Москва', 'Санкт-Петербург', 'Новосибирск', 'Екатеринбург', 'Казань'],
    'Узбекистан': ['Ташкент', 'Самарканд', 'Бухара', 'Наманган', 'Андижан'],
    'Кыргызстан': ['Бишкек', 'Ош', 'Джалал-Абад', 'Каракол', 'Токмок'],
    'Таджикистан': ['Душанбе', 'Худжанд', 'Куляб', 'Бохтар', 'Истаравшан'],
  };

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = await AuthService.registerWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        country: _selectedCountry,
        city: _selectedCity,
        role: _selectedRole.toString().split('.').last,
      );

      // Обновляем состояние приложения
      if (mounted) {
        context.read<AppState>().setCurrentUser(user);
        // Мгновенная навигация по роли
        if (user.isSeller) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const SellerDashboard()),
                (route) => false,
          );
        } else if (user.isDealer) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const DealerDashboard()),
                (route) => false,
          );
        } else if (user.isLogistics) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LogisticsDashboard()),
                (route) => false,
          );
        } else if (user.isBroker) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const BrokerDashboard()),
                (route) => false,
          );
        } else if (user.isAdmin) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const AdminDashboard()),
                (route) => false,
          );
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Заголовок
                Text(
                  'Создать аккаунт',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Заполните форму для регистрации',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 32),

                // Имя и фамилия
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'Имя',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите имя';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Фамилия',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите фамилию';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите email';
                    }
                    if (!value.contains('@')) {
                      return 'Введите корректный email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Телефон
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Телефон',
                    prefixIcon: Icon(Icons.phone_outlined),
                    hintText: '+7 777 123 45 67',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите номер телефона';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Страна и город
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedCountry,
                        decoration: const InputDecoration(
                          labelText: 'Страна',
                          prefixIcon: Icon(Icons.public),
                        ),
                        items: _countries.map((country) {
                          return DropdownMenuItem(
                            value: country,
                            child: Text(country),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCountry = value!;
                            _selectedCity = _cities[value]!.first;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedCity,
                        decoration: const InputDecoration(
                          labelText: 'Город',
                        ),
                        items: _cities[_selectedCountry]!.map((city) {
                          return DropdownMenuItem(
                            value: city,
                            child: Text(city),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCity = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Роль
                DropdownButtonFormField<UserRole>(
                  initialValue: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Тип аккаунта',
                    prefixIcon: Icon(Icons.business),
                  ),
                  items: UserRole.values.map((role) {
                    String label;
                    switch (role) {
                      case UserRole.buyer:
                        label = 'Покупатель';
                        break;
                      case UserRole.seller:
                        label = 'Продавец';
                        break;
                      case UserRole.dealer:
                        label = 'Дилер';
                        break;
                      case UserRole.logistics:
                        label = 'Логист';
                        break;
                      case UserRole.broker:
                        label = 'Брокер';
                        break;
                      case UserRole.admin:
                        label = 'Администратор';
                        break;
                    }
                    return DropdownMenuItem(
                      value: role,
                      child: Text(label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // Пароль
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите пароль';
                    }
                    if (value.length < 6) {
                      return 'Пароль должен содержать минимум 6 символов';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Подтверждение пароля
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Подтвердите пароль',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Подтвердите пароль';
                    }
                    if (value != _passwordController.text) {
                      return 'Пароли не совпадают';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Кнопка регистрации
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Зарегистрироваться'),
                ),

                const SizedBox(height: 16),

                // Ссылка на вход
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Уже есть аккаунт? Войти'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
