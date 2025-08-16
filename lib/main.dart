import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/injector.dart' as di;
import 'core/providers/global_branch_provider.dart';
import 'core/themes/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/main_menu/presentation/providers/main_menu_provider.dart';
import 'features/shared/providers/product_list_provider.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/stock_opname/presentation/providers/stock_opname_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<AuthProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<StockOpnameProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MainMenuProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<ProductListProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => GlobalBranchProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Initialize auth state when app starts (only once)
          if (!_isInitialized) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_isInitialized) {
                _isInitialized = true;
                authProvider.initializeAuth();
              }
            });
          }

          return MaterialApp(
            title: 'EnakEco SO',
            theme: AppTheme.lightTheme,
            home: const SplashPage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
