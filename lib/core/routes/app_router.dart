import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/grs/presentation/pages/grs_list_page.dart';
import '../../features/main_menu/presentation/pages/home_page.dart';
import '../../features/permissions/presentation/pages/permissions_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/rsk/presentation/pages/rsk_list_page.dart';
import '../../features/rtl/presentation/pages/product_information.dart';
import '../../features/rtl/presentation/pages/rtl_list_page.dart';
import '../../features/rtl/presentation/pages/rtl_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Splash Screen
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      // Permissions Screen
      GoRoute(
        path: '/permissions',
        name: 'permissions',
        builder: (context, state) => const PermissionsPage(),
      ),

      // Login Screen
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // Home Screen
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      // Profile Screen
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),

      // RTL (Toko) Routes
      GoRoute(
        path: '/rtl',
        name: 'rtl',
        builder: (context, state) => const RTLPage(),
      ),

      // QR Scanner Route - Removed because now using Navigator.push with parameters

      // QR Result Route
      GoRoute(
        path: '/qr-result',
        name: 'qr-result',
        builder: (context, state) {
          final qrCode = state.extra as String? ?? 'No QR Code';
          return ProductInformationPage(qrCode: qrCode);
        },
      ),

      // RTL List Page
      GoRoute(
        path: '/rtl-list',
        name: 'rtl-list',
        builder: (context, state) => const RTLListPage(),
      ),
      // GRS List Page
      GoRoute(
        path: '/grs-list',
        name: 'grs-list',
        builder: (context, state) => const GRSListPage(),
      ),
      // RSK List Page
      GoRoute(
        path: '/rsk-list',
        name: 'rsk-list',
        builder: (context, state) => const RSKListPage(),
      ),

      // GRS Routes
      GoRoute(
        path: '/grs',
        name: 'grs',
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('GRS'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/home'),
            ),
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 80,
                  color: Color(0xFF48BB78),
                ),
                SizedBox(height: 16),
                Text(
                  'GRS (Goods Receipt)',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Coming Soon',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // RSK Routes
      GoRoute(
        path: '/rsk',
        name: 'rsk',
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('RSK'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/home'),
            ),
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_return_outlined,
                  size: 80,
                  color: Color(0xFFED8936),
                ),
                SizedBox(height: 16),
                Text(
                  'RSK (Return Stock)',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Coming Soon',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Settings Routes
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/home'),
            ),
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.settings_outlined,
                  size: 80,
                  color: Color(0xFF9F7AEA),
                ),
                SizedBox(height: 16),
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Coming Soon',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
