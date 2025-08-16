import 'package:dio/dio.dart';

import '../../../../core/constants/env.dart';
import '../../../../core/network/base_response.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<BaseResponse<UserModel>> login(String username, String password);
  Future<BaseResponse<UserModel>> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<BaseResponse<UserModel>> login(String username, String password) async {
    try {
      final response = await client.post(
        '${Env.stockListBaseUrl}/api/stock/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['message'] == 'User berhasil login' && responseData['data'] != null) {
          final userData = responseData['data'];
          
          // Debug: Print user data from API
          print('[AUTH API] User data from API: $userData');
          print('[AUTH API] isAdmin value: ${userData['isAdmin']}');

          try {
            final user = UserModel.fromJson(userData);
            
            // Debug: Print parsed user data
            print('[AUTH API] Parsed user - isAdmin: ${user.isAdmin}, username: ${user.cNamaus}');

            return BaseResponse.success(
              data: user,
              message: responseData['message'] ?? 'Login successful',
            );
          } catch (e) {
            return BaseResponse.error(
              message: 'Failed to parse user data: ${e.toString()}',
            );
          }
        } else {
          return BaseResponse.error(
            message: responseData['message'] ?? 'Login failed',
          );  
        }
      } else {
        return BaseResponse.error(
          message: 'Login failed with status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';

      if (e.response != null) {
        final responseData = e.response?.data;
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? 'Login failed';
        } else {
          errorMessage = 'Login failed with status code: ${e.response?.statusCode}';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Request timeout. Please try again.';
      }

      return BaseResponse.error(
        message: errorMessage,
        error: e.toString(),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return BaseResponse.error(
        message: 'An unexpected error occurred: ${e.toString()}',
        error: e.toString(),
      );
    }
  }

  @override
  Future<BaseResponse<UserModel>> getCurrentUser() async {
    try {
      // Get current user from session
      final response = await client.get(
        '${Env.stockListBaseUrl}/api/stock/user/profile',
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['data'] != null) {
          final userData = responseData['data'];
          final user = UserModel.fromJson(userData);

          return BaseResponse.success(
            data: user,
            message: responseData['message'] ?? 'User data retrieved successfully',
          );
        } else {
          return BaseResponse.error(
            message: responseData['message'] ?? 'Failed to get user data',
          );
        }
      } else {
        return BaseResponse.error(
          message: 'Failed to get user data with status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';

      if (e.response != null) {
        final responseData = e.response?.data;
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? 'Failed to get user data';
        } else {
          errorMessage = 'Failed to get user data with status code: ${e.response?.statusCode}';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Request timeout. Please try again.';
      }

      return BaseResponse.error(
        message: errorMessage,
        error: e.toString(),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return BaseResponse.error(
        message: 'An unexpected error occurred: ${e.toString()}',
        error: e.toString(),
      );
    }
  }
}