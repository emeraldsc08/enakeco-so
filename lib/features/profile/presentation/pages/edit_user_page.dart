import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injector.dart';
import '../../data/datasources/user_settings_remote_datasource.dart';
import '../../data/models/user_settings_model.dart';
import '../../data/repositories/user_settings_repository.dart';
import '../providers/user_settings_provider.dart';

class EditUserPage extends StatefulWidget {
  final UserSettingsModel user;

  const EditUserPage({
    super.key,
    required this.user,
  });

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late UserSettingsProvider _provider;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isAdmin = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _provider = UserSettingsProvider(
      repository: UserSettingsRepository(
        remoteDataSource: UserSettingsRemoteDataSource(
          client: locator<Dio>(),
        ),
      ),
    );

    // Pre-fill data
    _isAdmin = widget.user.isAdmin == 1;
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    setState(() {
      if (_passwordController.text.isNotEmpty && _passwordController.text.length < 6) {
        _passwordError = 'Password minimal 6 karakter';
      } else {
        _passwordError = null;
      }
      _validateConfirmPassword();
    });
  }

  void _validateConfirmPassword() {
    setState(() {
      if (_confirmPasswordController.text.isNotEmpty && _passwordController.text != _confirmPasswordController.text) {
        _confirmPasswordError = 'Password dan konfirmasi password tidak sama';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  bool _validateForm() {
    bool isValid = true;

    // Password is optional for editing, but if provided, validate it
    if (_passwordController.text.isNotEmpty) {
      if (_passwordController.text.length < 6) {
        _passwordError = 'Password minimal 6 karakter';
        isValid = false;
      }

      // If password is provided, confirm password is required
      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = 'Konfirmasi password diperlukan jika password diisi';
        isValid = false;
      } else if (_passwordController.text != _confirmPasswordController.text) {
        _confirmPasswordError = 'Password dan konfirmasi password tidak sama';
        isValid = false;
      }
    }

    // If confirm password is provided but password is empty, show error
    if (_confirmPasswordController.text.isNotEmpty && _passwordController.text.isEmpty) {
      _confirmPasswordError = 'Password harus diisi jika konfirmasi password diisi';
      isValid = false;
    }

    setState(() {});
    return isValid;
  }

  void _submitForm() async {
    if (_validateForm()) {
      try {
        // For editing, if no new password is provided, we'll send empty string
        // The backend should handle this appropriately (keep existing password)
        String passwordToUse = _passwordController.text.isNotEmpty
            ? _passwordController.text
            : '';

        // Call the actual API to update user
        final response = await _provider.updateUser(
          id: widget.user.id.toString(),
          password: passwordToUse,
          isAdmin: _isAdmin ? 1 : 0,
        );

        if (mounted) {
          if (response != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response.message),
                backgroundColor: Colors.green,
              ),
            );

            // Navigate back to settings page and refresh the list
            Navigator.pop(context, true); // Pass true to indicate success
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_provider.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Edit User',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A202C),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A202C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ChangeNotifierProvider.value(
        value: _provider,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Field (Read-only)
              const Text(
                'Nama',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A202C),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextFormField(
                  enabled: false,
                  initialValue: widget.user.username,
                  decoration: InputDecoration(
                    hintText: 'Nama user',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password Field (Optional)
              const Text(
                'Password Baru',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A202C),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '(Kosongkan jika tidak ingin mengubah password)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _passwordError != null ? Colors.red : Colors.grey[300]!,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Masukkan password baru (opsional)',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              if (_passwordError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _passwordError!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Konfirmasi Password Field (Optional)
              const Text(
                'Konfirmasi Password Baru',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A202C),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '(Kosongkan jika tidak ingin mengubah password)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _confirmPasswordError != null ? Colors.red : Colors.grey[300]!,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    hintText: 'Konfirmasi password baru (opsional)',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              if (_confirmPasswordError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _confirmPasswordError!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Admin Switch
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _isAdmin
                          ? const Color(0xFF48BB78).withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _isAdmin ? Icons.admin_panel_settings : Icons.person,
                      color: _isAdmin
                          ? const Color(0xFF48BB78)
                          : Colors.grey[600],
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Admin',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A202C),
                    ),
                  ),
                  subtitle: Text(
                    _isAdmin ? 'User memiliki akses admin' : 'User biasa',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: Switch(
                    value: _isAdmin,
                    onChanged: (value) {
                      setState(() {
                        _isAdmin = value;
                      });
                    },
                    activeColor: const Color(0xFF48BB78),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _provider.isUpdatingUser ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(AppConstants.primaryRed),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _provider.isUpdatingUser
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
