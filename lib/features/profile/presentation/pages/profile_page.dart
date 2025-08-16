import 'package:enakeco_so/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/global_branch_provider.dart';
import '../../../../core/services/session_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _logout(BuildContext context) async {
    try {
      // Show confirmation dialog
      final shouldLogout = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.logout,
                color: Color(AppConstants.primaryRed),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Keluar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari aplikasi?',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(AppConstants.primaryRed),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Keluar',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );

      // If user confirmed logout, proceed with logout process
      if (shouldLogout == true) {
        print('[PROFILE] User confirmed logout, starting logout process...');

        // Clear session directly
        await SessionService.clearSession();
        print('[PROFILE] Session cleared directly');

        // Navigate immediately using multiple approaches
        if (context.mounted) {
          // Try multiple navigation approaches
          try {
            // Approach 1: Direct Navigator
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
            print('[PROFILE] Navigation approach 1 completed');
          } catch (e) {
            print('[PROFILE] Navigation approach 1 failed: $e');

            // Approach 2: Using context directly
            try {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
              print('[PROFILE] Navigation approach 2 completed');
            } catch (e2) {
              print('[PROFILE] Navigation approach 2 failed: $e2');

              // Approach 3: Using MaterialApp navigator
              try {
                final navigator = Navigator.of(context, rootNavigator: true);
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
                print('[PROFILE] Navigation approach 3 completed');
              } catch (e3) {
                print('[PROFILE] All navigation approaches failed: $e3');
                // Show error message
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Navigation failed. Please restart the app.'),
                      backgroundColor: Color(AppConstants.primaryRed),
                    ),
                  );
                }
              }
            }
          }
        } else {
          print('[PROFILE] Context no longer mounted, cannot navigate');
        }
      }
    } catch (e) {
      print('[PROFILE] Error during logout: $e');
      // Show error message to user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error during logout: $e'),
            backgroundColor: const Color(AppConstants.primaryRed),
          ),
        );
      }
    }
  }

  String _formatLoginTime() {
    try {
      final now = DateTime.now();
      return '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A202C),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF1A202C),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          print(
              '[PROFILE] AuthProvider state - isLoading: ${authProvider.isLoading}, isAuthenticated: ${authProvider.isAuthenticated}, currentUser: ${authProvider.currentUser?.cNamaus ?? 'null'}');

          if (authProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(AppConstants.primaryRed),
              ),
            );
          }

          final currentUser = authProvider.currentUser;
          if (currentUser == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off,
                    size: 64,
                    color: Color(0xFF64748B),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Data pengguna tidak tersedia',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(AppConstants.primaryRed),
                              Color(AppConstants.secondaryRed),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(AppConstants.primaryRed)
                                  .withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),

                // User Information Section
                const Text(
                  'Informasi Pengguna',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A202C),
                  ),
                ),
                const SizedBox(height: 16),

                _buildInfoCard(
                  icon: Icons.person_outline,
                  title: 'Nama Pengguna',
                  value: currentUser.cNamaus.isNotEmpty
                      ? currentUser.cNamaus
                      : 'Tidak tersedia',
                  color: const Color(0xFF4299E1),
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.route_outlined,
                  title: 'Role',
                  value:
                      currentUser.isAdmin == 1 ? 'Administrator' : 'Pengguna',
                  color: const Color.fromARGB(255, 225, 164, 66),
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.badge_outlined,
                  title: 'ID Pengguna',
                  value: currentUser.id > 0
                      ? currentUser.id.toString()
                      : 'Tidak tersedia',
                  color: const Color(0xFFED8936),
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.access_time_outlined,
                  title: 'Waktu Login',
                  value: _formatLoginTime(),
                  color: const Color(0xFF9F7AEA),
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.group_outlined,
                  title: 'Grup',
                  value: currentUser.cGroup.isNotEmpty
                      ? currentUser.cGroup
                      : 'Tidak tersedia',
                  color: const Color(0xFF38B2AC),
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.store_outlined,
                  title: 'Gudang',
                  value: currentUser.cGudang.isNotEmpty
                      ? currentUser.cGudang
                      : 'Tidak tersedia',
                  color: const Color(0xFFF56565),
                ),

                const SizedBox(height: 32),

                // Branch Information Section
                const Text(
                  'Informasi Cabang',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A202C),
                  ),
                ),
                const SizedBox(height: 16),

                Consumer<GlobalBranchProvider>(
                  builder: (context, globalBranchProvider, child) {
                    final branchName = globalBranchProvider.currentBranchName;
                    final branchId = globalBranchProvider.currentBranchId;

                    return Column(
                      children: [
                        if (branchName.isNotEmpty)
                          _buildInfoCard(
                            icon: Icons.location_on_outlined,
                            title: 'Cabang Aktif',
                            value: branchName,
                            color: const Color(AppConstants.primaryRed),
                          ),
                        if (branchName.isNotEmpty && branchId > 0)
                          const SizedBox(height: 12),
                        if (branchId > 0)
                          _buildInfoCard(
                            icon: Icons.store_outlined,
                            title: 'ID Cabang',
                            value: branchId.toString(),
                            color: const Color(0xFF48BB78),
                          ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 32),

                // App Information Section
                const Text(
                  'Informasi Aplikasi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A202C),
                  ),
                ),
                const SizedBox(height: 16),

                _buildInfoCard(
                  icon: Icons.info_outline,
                  title: 'Nama Aplikasi',
                  value: 'EnakEco SO',
                  color: const Color(AppConstants.primaryRed),
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.phone_android_outlined,
                  title: 'Versi',
                  value: AppConstants.appVersion,
                  color: const Color(0xFF48BB78),
                ),

                const SizedBox(height: 32),

                // Logout Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: authProvider.isLoading
                            ? null
                            : () {
                                print('[PROFILE] Logout button pressed');
                                _logout(context);
                              },
                        icon: authProvider.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Icon(Icons.logout, size: 20),
                        label: Text(
                          authProvider.isLoading
                              ? 'Sedang keluar...'
                              : 'Keluar',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(AppConstants.primaryRed),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A202C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
