import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/helpers/navigation_helper.dart';
import '../../../../core/models/branch_model.dart';
import '../../../../core/providers/global_branch_provider.dart';
import '../../../../core/widgets/branch_selector.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../grs/presentation/pages/grs_list_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../profile/presentation/pages/settings_page.dart';
import '../../../rsk/presentation/pages/rsk_list_page.dart';
import '../../../rtl/presentation/pages/rtl_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();

    // Auto search based on selected branch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final globalBranchProvider =
          Provider.of<GlobalBranchProvider>(context, listen: false);
      // Here you can add logic to handle branch selection
      print(
          'Home page loaded with branch: ${globalBranchProvider.currentBranchName} (ID: ${globalBranchProvider.currentBranchId})');
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _onBranchSelected(BranchModel branch) {
    // Branch selection is handled globally by GlobalBranchProvider
    print('Branch selected: ${branch.branchName} (ID: ${branch.branchId})');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(AppConstants.lightGray),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Logo Section
              Image.asset(
                'assets/images/enak-eco-logo.png',
                height: 60,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),

              // User & Branch Section
              FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(AppConstants.primaryRed),
                          Color(AppConstants.secondaryRed),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(AppConstants.primaryRed)
                              .withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // User Profile Row
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              final currentUser = authProvider.currentUser;
                              if (currentUser != null) {
                                return Row(
                                  children: [
                                    // Profile Avatar
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // User Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            currentUser.cNamaus.isNotEmpty
                                                ? currentUser.cNamaus
                                                : 'User',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.3),
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              currentUser.isAdmin == 1
                                                  ? 'Administrator'
                                                  : 'Pengguna',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Profile Button
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: IconButton(
                                        onPressed: () => toDetail(
                                          context,
                                          page: const ProfilePage(),
                                        ),
                                        icon: const Icon(
                                          Icons.settings_outlined,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        constraints: const BoxConstraints(
                                          minWidth: 32,
                                          minHeight: 32,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          const SizedBox(height: 16),
                          // Divider
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withOpacity(0.3),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Branch Selector
                          BranchSelector(
                            onBranchSelected: _onBranchSelected,
                            title: 'Pilih Cabang',
                            hintText: 'Cabang',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Menu utama dengan animasi slide
              Expanded(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      _buildModernMenuItem(
                        context,
                        title: 'RTL (Toko)',
                        subtitle: 'Manajemen toko retail',
                        icon: Icons.store_outlined,
                        gradient: [
                          const Color(0xFF667eea),
                          const Color(0xFF764ba2)
                        ],
                        onTap: () => toDetail(
                          context,
                          page: const RTLListPage(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildModernMenuItem(
                        context,
                        title: 'GRS',
                        subtitle: 'Goods Receipt System',
                        icon: Icons.inbox_outlined,
                        gradient: [
                          const Color(0xFFf093fb),
                          const Color(0xFFf5576c)
                        ],
                        onTap: () => toDetail(
                          context,
                          page: const GRSListPage(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildModernMenuItem(
                        context,
                        title: 'RSK',
                        subtitle: 'Return Stock System',
                        icon: Icons.assignment_return_outlined,
                        gradient: [
                          const Color(0xFF4facfe),
                          const Color(0xFF00f2fe)
                        ],
                        onTap: () => toDetail(
                          context,
                          page: const RSKListPage(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Pengaturan akun di bawah dengan styling modern - Hanya untuk Admin
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  // Hanya tampilkan jika user adalah admin
                  if (authProvider.currentUser != null &&
                      authProvider.currentUser!.isAdmin == 1) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                        child: _buildModernMenuItem(
                          context,
                          title: 'Pengaturan Akun',
                          subtitle: 'Profil dan preferensi',
                          icon: Icons.settings_outlined,
                          gradient: [
                            const Color(0xFFfa709a),
                            const Color(0xFFfee140)
                          ],
                          onTap: () => toDetail(
                            context,
                            page: const SettingsPage(),
                          ),
                        ),
                      ),
                    );
                  }
                  // Jika bukan admin, tidak tampilkan apa-apa
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernMenuItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Icon container with gradient
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A202C),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
