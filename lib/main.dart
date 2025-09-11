import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'services/app_state.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/seller_dashboard.dart';
import 'screens/dealer_dashboard.dart';
import 'screens/logistics_dashboard.dart';
import 'screens/broker_dashboard.dart';
import 'screens/admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const BondAutoApp());
}

class BondAutoApp extends StatelessWidget {
  const BondAutoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: 'Bond Авто',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appState.themeMode,
            home: StreamBuilder(
              stream: AuthService.authStateChanges,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final firebaseUser = snapshot.data;
                if (firebaseUser != null) {
                  // Если профиль ещё не загружен в AppState — подтянем из Firestore
                  if (appState.currentUser == null) {
                    AuthService.fetchUserModel(firebaseUser.uid).then((userModel) {
                      if (context.mounted) {
                        context.read<AppState>().setCurrentUser(userModel);
                      }
                    });
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final user = appState.currentUser!;
                  if (user.isSeller) {
                    return const SellerDashboard();
                  }
                  if (user.isDealer) {
                    return const DealerDashboard();
                  }
                  if (user.isLogistics) {
                    return const LogisticsDashboard();
                  }
                  if (user.isBroker) {
                    return const BrokerDashboard();
                  }
                  if (user.isAdmin) {
                    return const AdminDashboard();
                  }
                  return const HomeScreen();
                } else {
                  // Неавторизован: показать экран входа/регистрации
                  return const LoginScreen();
                }
              },
            ),
            routes: {
              '/home': (context) => const HomeScreen(),
              '/login': (context) => const LoginScreen(),
            },
          );
        },
      ),
    );
  }
}
