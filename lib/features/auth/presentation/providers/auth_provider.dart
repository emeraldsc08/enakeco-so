import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/network/base_response.dart';
import '../../../../core/services/session_service.dart';
import '../../data/models/user_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  AuthProvider(this.loginUseCase);

  bool _isLoading = false;
  bool _isAuthenticated = false;
  UserEntity? _currentUser;
  String? _error;
  Timer? _sessionTimer;
  static const Duration _sessionTimeout = Duration(hours: 8); // 8 jam timeout

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  UserEntity? get currentUser => _currentUser;
  String? get error => _error;

  /// Initialize auth state from session
  Future<void> initializeAuth() async {
    // Prevent multiple initializations
    if (_isLoading) {
      print('[AUTH PROVIDER] Already initializing, skipping...');
      return;
    }

    print('[AUTH PROVIDER] Starting initialization...');
    _setLoading(true);

    try {
      final isLoggedIn = await SessionService.isLoggedIn();
      if (isLoggedIn) {
        // Validate that encrypted_id exists
        final encryptedId = await SessionService.getEncryptedId();
        if (encryptedId != null && encryptedId.isNotEmpty) {
          _setAuthenticated(true);
          // Load current user data
          await _loadCurrentUser();
          // Start session timeout timer
          _startSessionTimer();
          print('[AUTH PROVIDER] Initialization successful - user authenticated');
        } else {
          // Session exists but no encrypted_id, clear session
          print('[AUTH PROVIDER] Session exists but no encrypted_id found, clearing session');
          await SessionService.clearSession();
          _setAuthenticated(false);
        }
      } else {
        print('[AUTH PROVIDER] No session found');
      }
    } catch (e) {
      print('[AUTH PROVIDER] Initialization error: $e');
      _setAuthenticated(false);
    } finally {
      _setLoading(false);
      print('[AUTH PROVIDER] Initialization completed');
    }
  }

  /// Login with username and password
  Future<BaseResponse<UserModel>> login(String username, String password) async {
    _setLoading(true);
    _clearError();

    final result = await loginUseCase(username, password);

    return result.fold(
      (error) {
        _setError(error);
        _setLoading(false);
        return BaseResponse.error(message: error);
      },
      (user) async {
        // Debug: Print user data before saving
        print('[AUTH PROVIDER] User data from login - isAdmin: ${user.isAdmin}, username: ${user.cNamaus}');

        _setCurrentUser(user);
        _setAuthenticated(true);

        // Save session data
        await SessionService.saveSession(
          encryptedId: user.encryptedId,
          userId: user.id,
          username: user.cNamaus,
        );

        // Start session timeout timer
        _startSessionTimer();

        _setLoading(false);
        return BaseResponse.success(
          data: UserModel.fromEntity(user),
          message: 'Login successful',
        );
      },
    );
  }

  /// Load current user data
  Future<void> _loadCurrentUser() async {
    try {
      // This would typically call a getCurrentUser use case
      // For now, we'll get basic info from session
      final userId = await SessionService.getUserId();
      final username = await SessionService.getUsername();

      if (userId != null && username != null) {
        // Create a basic user entity from session data
        // In a real app, you'd fetch complete user data from API
        final user = UserEntity(
          id: userId,
          cNamaus: username,
          cGroup: 'ADMGD',
          nLevel: 0,
          cNoUser: '9',
          cGudang: 'RTL',
          lStockMin: '0',
          lReorder: '0',
          lPR: '0',
          lPO: '0',
          lHutJtTempo: '0',
          canLogin: 1,
          isAdmin: 1,
          deletedAt: null,
          encryptedId: await SessionService.getEncryptedId() ?? '',
        );

        // Debug: Print user data from session
        print('[AUTH PROVIDER] User data from session - isAdmin: ${user.isAdmin}, username: ${user.cNamaus}');
        _setCurrentUser(user);
      }
    } catch (e) {
      _setError('Failed to load user data: ${e.toString()}');
    }
  }

  /// Logout user
  Future<void> logout() async {
    print('[AUTH PROVIDER] Starting logout process...');
    _setLoading(true);

    try {
      // Stop session timer
      _stopSessionTimer();
      print('[AUTH PROVIDER] Session timer stopped');

      // Clear session data
      await SessionService.clearSession();
      print('[AUTH PROVIDER] Session data cleared');

      // Reset auth state
      _setCurrentUser(null);
      _setAuthenticated(false);
      _clearError();
      print('[AUTH PROVIDER] Auth state reset completed');

      print('[AUTH PROVIDER] Logout process completed successfully');
    } catch (e) {
      print('[AUTH PROVIDER] Error during logout: $e');
      // Even if there's an error, we should still reset the state
      _setCurrentUser(null);
      _setAuthenticated(false);
      _clearError();
    } finally {
      _setLoading(false);
      print('[AUTH PROVIDER] Logout loading state set to false');
    }
  }

  /// Start session timeout timer
  void _startSessionTimer() {
    _stopSessionTimer(); // Stop existing timer if any
    _sessionTimer = Timer(_sessionTimeout, () {
      print('[AUTH PROVIDER] Session timeout - auto logout');
      logout();
    });
  }

  /// Stop session timeout timer
  void _stopSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
  }

  /// Clear error state
  void clearError() {
    _clearError();
  }

  /// Validate current session
  Future<bool> validateSession() async {
    final isLoggedIn = await SessionService.isLoggedIn();
    if (!isLoggedIn) return false;

    final encryptedId = await SessionService.getEncryptedId();
    if (encryptedId == null || encryptedId.isEmpty) {
      print('[AUTH PROVIDER] Session validation failed: no encrypted_id');
      await logout();
      return false;
    }

    print('[AUTH PROVIDER] Session validation successful');
    return true;
  }

  void _setLoading(bool loading) {
    // Prevent unnecessary state changes
    if (_isLoading == loading) {
      return;
    }
    _isLoading = loading;
    notifyListeners();
  }

  void _setAuthenticated(bool authenticated) {
    _isAuthenticated = authenticated;
    notifyListeners();
  }

  void _setCurrentUser(UserEntity? user) {
    _currentUser = user;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _stopSessionTimer();
    super.dispose();
  }
}