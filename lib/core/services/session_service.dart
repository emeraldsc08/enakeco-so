import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _encryptedIdKey = 'encrypted_id';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _isLoggedInKey = 'is_logged_in';

  static Future<void> saveSession({
    required String encryptedId,
    required int userId,
    required String username,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_encryptedIdKey, encryptedId);
    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_usernameKey, username);
    await prefs.setBool(_isLoggedInKey, true);
  }

  static Future<String?> getEncryptedId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_encryptedIdKey);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> clearSession() async {
    print('[SESSION SERVICE] Starting session clear...');
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove(_encryptedIdKey);
      print('[SESSION SERVICE] Removed encrypted_id');

      await prefs.remove(_userIdKey);
      print('[SESSION SERVICE] Removed user_id');

      await prefs.remove(_usernameKey);
      print('[SESSION SERVICE] Removed username');

      await prefs.setBool(_isLoggedInKey, false);
      print('[SESSION SERVICE] Set is_logged_in to false');

      print('[SESSION SERVICE] Session clear completed successfully');
    } catch (e) {
      print('[SESSION SERVICE] Error clearing session: $e');
      rethrow;
    }
  }
}
