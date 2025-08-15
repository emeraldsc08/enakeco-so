import 'package:dio/dio.dart';

import '../services/session_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip adding header for login endpoint
    if (options.path.contains('/api/stock/login')) {
      return handler.next(options);
    }

    // Add Client-Address header with encrypted_id
    final encryptedId = await SessionService.getEncryptedId();
    if (encryptedId != null && encryptedId.isNotEmpty) {
      options.headers['Client-Address'] = encryptedId;
      print('[AUTH INTERCEPTOR] Added Client-Address header: ${encryptedId.substring(0, 20)}...');
    } else {
      print('[AUTH INTERCEPTOR] Warning: No encrypted_id found in session');
      // Don't block the request, but log the warning
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized errors
    if (err.response?.statusCode == 401) {
      print('[AUTH INTERCEPTOR] 401 Unauthorized - Clearing session');
      // Clear session and redirect to login
      SessionService.clearSession();
    }

    return handler.next(err);
  }
}
