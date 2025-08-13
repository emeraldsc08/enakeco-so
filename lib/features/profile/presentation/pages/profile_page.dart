import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/global_branch_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(AppConstants.primaryRed),
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      // Clear user session using auth provider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();

      // Navigate to login
      if (context.mounted) {
        context.go('/login');
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
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
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
              child: Text('No user data available'),
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
                              color: const Color(AppConstants.primaryRed).withOpacity(0.3),
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
                      Text(
                        currentUser.cNamaus,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A202C),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentUser.isAdmin == 1 ? 'Administrator' : 'User',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // User Information Section
                const Text(
                  'User Information',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A202C),
                  ),
                ),
                const SizedBox(height: 16),

                _buildInfoCard(
                  icon: Icons.person_outline,
                  title: 'Username',
                  value: currentUser.cNamaus,
                  color: const Color(0xFF4299E1),
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  value: '${currentUser.cNamaus}@enakeco.com',
                  color: const Color(0xFF48BB78),
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.badge_outlined,
                  title: 'User ID',
                  value: currentUser.id.toString(),
                  color: const Color(0xFFED8936),
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.access_time_outlined,
                  title: 'Login Time',
                  value: _formatLoginTime(),
                  color: const Color(0xFF9F7AEA),
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.group_outlined,
                  title: 'Group',
                  value: currentUser.cGroup,
                  color: const Color(0xFF38B2AC),
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.store_outlined,
                  title: 'Warehouse',
                  value: currentUser.cGudang,
                  color: const Color(0xFFF56565),
                ),

                const SizedBox(height: 32),

                // Branch Information Section
                const Text(
                  'Branch Information',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A202C),
                  ),
                ),
                const SizedBox(height: 16),

                Consumer<GlobalBranchProvider>(
                  builder: (context, globalBranchProvider, child) {
                    return Column(
                      children: [
                        _buildInfoCard(
                          icon: Icons.location_on_outlined,
                          title: 'Active Branch',
                          value: globalBranchProvider.currentBranchName,
                          color: const Color(AppConstants.primaryRed),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoCard(
                          icon: Icons.store_outlined,
                          title: 'Branch ID',
                          value: 'ID: ${globalBranchProvider.currentBranchId}',
                          color: const Color(0xFF48BB78),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 32),

                // App Information Section
                const Text(
                  'App Information',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A202C),
                  ),
                ),
                const SizedBox(height: 16),

                _buildInfoCard(
                  icon: Icons.info_outline,
                  title: 'App Name',
                  value: 'EnakEco SO',
                  color: const Color(AppConstants.primaryRed),
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.phone_android_outlined,
                  title: 'Version',
                  value: AppConstants.appVersion,
                  color: const Color(0xFF48BB78),
                ),

                const SizedBox(height: 40),

                // Logout Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: authProvider.isLoading ? null : () => _logout(context),
                        icon: authProvider.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.logout, size: 20),
                        label: Text(
                          authProvider.isLoading ? 'Logging out...' : 'Logout',
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