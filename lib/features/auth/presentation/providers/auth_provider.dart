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

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  UserEntity? get currentUser => _currentUser;
  String? get error => _error;

  /// Initialize auth state from session
  Future<void> initializeAuth() async {
    _setLoading(true);

    final isLoggedIn = await SessionService.isLoggedIn();
    if (isLoggedIn) {
      // Validate that encrypted_id exists
      final encryptedId = await SessionService.getEncryptedId();
      if (encryptedId != null && encryptedId.isNotEmpty) {
        _setAuthenticated(true);
        // Load current user data
        await _loadCurrentUser();
      } else {
        // Session exists but no encrypted_id, clear session
        print('[AUTH PROVIDER] Session exists but no encrypted_id found, clearing session');
        await SessionService.clearSession();
        _setAuthenticated(false);
      }
    }

    _setLoading(false);
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
        _setCurrentUser(user);
        _setAuthenticated(true);

        // Save session data
        await SessionService.saveSession(
          encryptedId: user.encryptedId,
          userId: user.id,
          username: user.cNamaus,
        );

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

        _setCurrentUser(user);
      }
    } catch (e) {
      _setError('Failed to load user data: ${e.toString()}');
    }
  }

  /// Logout user
  Future<void> logout() async {
    _setLoading(true);

    await SessionService.clearSession();
    _setCurrentUser(null);
    _setAuthenticated(false);
    _clearError();

    _setLoading(false);
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
}