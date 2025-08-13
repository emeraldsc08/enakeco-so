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
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized errors
    if (err.response?.statusCode == 401) {
      // Clear session and redirect to login
      SessionService.clearSession();
    }

    return handler.next(err);
  }
}
