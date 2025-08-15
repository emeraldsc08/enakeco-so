import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/injector.dart' as di;
import 'core/providers/global_branch_provider.dart';
import 'core/routes/app_router.dart';
import 'core/themes/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/main_menu/presentation/providers/main_menu_provider.dart';
import 'features/shared/providers/product_list_provider.dart';
import 'features/stock_opname/presentation/providers/stock_opname_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          // Initialize auth state when app starts
          WidgetsBinding.instance.addPostFrameCallback((_) {
            authProvider.initializeAuth();
          });

          return MaterialApp.router(
            title: 'EnakEco SO',
            theme: AppTheme.lightTheme,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
