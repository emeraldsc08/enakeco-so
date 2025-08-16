import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/helpers/navigation_helper.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../auth/presentation/pages/login_page.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  bool _isLoading = false;
  final Map<Permission, bool> _permissionStatus = {};
  final List<Permission> _requiredPermissions = [
    Permission.camera,
    Permission.location,
  ];

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    setState(() {
      _isLoading = true;
    });

    for (final permission in _requiredPermissions) {
      final status = await permission.status;
      _permissionStatus[permission] = status.isGranted;
    }

    setState(() {
      _isLoading = false;
    });

    // Auto navigate if all permissions are already granted
    if (_allPermissionsGranted) {
      _navigateToLogin();
    }
  }

  Future<void> _requestPermission(Permission permission) async {
    final status = await permission.request();
    setState(() {
      _permissionStatus[permission] = status.isGranted;
    });

    // Check if all permissions are now granted
    if (_allPermissionsGranted) {
      _navigateToLogin();
    }
  }

  Future<void> _requestAllPermissions() async {
    setState(() {
      _isLoading = true;
    });

    for (final permission in _requiredPermissions) {
      final status = await permission.request();
      _permissionStatus[permission] = status.isGranted;
    }

    setState(() {
      _isLoading = false;
    });

    // Auto navigate if all permissions are granted
    if (_allPermissionsGranted) {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    // Add a small delay to show the success state briefly
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        toDetailandPushReplacement(
          context,
          page: const LoginPage(),
        );
      }
    });
  }

  bool get _allPermissionsGranted {
    return _permissionStatus.values.every((granted) => granted);
  }

  String _getPermissionTitle(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return 'Camera';
      case Permission.location:
        return 'Location';
      default:
        return 'Unknown';
    }
  }

  String _getPermissionDescription(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return 'Required to scan QR codes and capture images';
      case Permission.location:
        return 'Required to track store locations';
      default:
        return 'Required for app functionality';
    }
  }

  IconData _getPermissionIcon(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return Icons.camera_alt_outlined;
      case Permission.location:
        return Icons.location_on_outlined;
      default:
        return Icons.security_outlined;
    }
  }

  Color _getPermissionColor(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return const Color(AppConstants.primaryRed);
      case Permission.location:
        return const Color(0xFF48BB78);
      default:
        return const Color(AppConstants.darkGray);
    }
  }

  @override
  Widget build(BuildContext context) {
    // If all permissions are granted, show a brief success screen
    if (_allPermissionsGranted && !_isLoading) {
      return Scaffold(
        backgroundColor: const Color(AppConstants.lightGray),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF48BB78),
                    borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF48BB78).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                Text(
                  'All Permissions Granted!',
                  style: AppStyles.headingStyle.copyWith(
                    fontSize: AppConstants.fontSizeXXLarge,
                    color: const Color(0xFF48BB78),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                Text(
                  'Redirecting to login...',
                  style: AppStyles.bodyStyle.copyWith(
                    color: const Color(AppConstants.darkGray),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                const CircularProgressIndicator(
                  color: Color(0xFF48BB78),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(AppConstants.lightGray),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(AppConstants.primaryRed),
                        borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(AppConstants.primaryRed).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.security_outlined,
                        size: 50,
                        color: Color(AppConstants.white),
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    Text(
                      'Permissions Required',
                      style: AppStyles.headingStyle.copyWith(
                        fontSize: AppConstants.fontSizeXXLarge,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Text(
                      'Please grant the following permissions to use all features of the app',
                      style: AppStyles.bodyStyle.copyWith(
                        color: const Color(AppConstants.darkGray),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Permissions List
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(AppConstants.primaryRed),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _requiredPermissions.length,
                        itemBuilder: (context, index) {
                          final permission = _requiredPermissions[index];
                          final isGranted = _permissionStatus[permission] ?? false;

                          return Container(
                            margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
                            decoration: BoxDecoration(
                              color: const Color(AppConstants.white),
                              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                              border: Border.all(
                                color: isGranted
                                    ? const Color(0xFF48BB78)
                                    : const Color(AppConstants.lightGray),
                                width: isGranted ? 2 : 1,
                              ),
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: _getPermissionColor(permission).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                                ),
                                child: Icon(
                                  _getPermissionIcon(permission),
                                  color: _getPermissionColor(permission),
                                  size: 24,
                                ),
                              ),
                              title: Text(
                                _getPermissionTitle(permission),
                                style: AppStyles.subheadingStyle.copyWith(
                                  fontSize: AppConstants.fontSizeMedium,
                                ),
                              ),
                              subtitle: Text(
                                _getPermissionDescription(permission),
                                style: AppStyles.captionStyle.copyWith(
                                  color: const Color(AppConstants.darkGray),
                                ),
                              ),
                              trailing: isGranted
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppConstants.paddingSmall,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF48BB78),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Granted',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: () => _requestPermission(permission),
                                      child: const Text(
                                        'Grant',
                                        style: TextStyle(
                                          color: Color(AppConstants.primaryRed),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Action Buttons
              if (!_allPermissionsGranted) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _requestAllPermissions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(AppConstants.primaryRed),
                      foregroundColor: const Color(AppConstants.white),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.paddingMedium,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(AppConstants.white),
                              ),
                            ),
                          )
                        : const Text(
                            'Grant All Permissions',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingMedium),
              ],

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _allPermissionsGranted ? _navigateToLogin : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _allPermissionsGranted
                        ? const Color(AppConstants.primaryRed)
                        : const Color(AppConstants.lightGray),
                    foregroundColor: _allPermissionsGranted
                        ? const Color(AppConstants.white)
                        : const Color(AppConstants.darkGray),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.paddingMedium,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                  ),
                  child: Text(
                    _allPermissionsGranted ? 'Continue to App' : 'Grant Permissions First',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _allPermissionsGranted
                          ? const Color(AppConstants.white)
                          : const Color(AppConstants.darkGray),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}