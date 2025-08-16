import 'package:dio/dio.dart';

import '../models/add_user_model.dart';
import '../models/master_user_model.dart';
import '../models/update_user_model.dart';
import '../models/user_settings_model.dart';

class UserSettingsRemoteDataSource {
  final Dio client;

  UserSettingsRemoteDataSource({required this.client});

  Future<UserSettingsResponse> fetchUsers() async {
    try {
      final response = await client.get('/api/stock/users');

      if (response.statusCode == 200) {
        return UserSettingsResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  Future<MasterUserResponse> fetchMasterUsers({String? search}) async {
    try {
      final queryParameters = search != null ? {'search': search} : null;
      final response = await client.get(
        '/api/stock/users/can-add',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return MasterUserResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load master users');
      }
    } catch (e) {
      throw Exception('Failed to load master users: $e');
    }
  }

  Future<AddUserResponse> addUser({
    required int id,
    required String password,
    required int isAdmin,
  }) async {
    try {
      final data = {
        'id': id,
        'password': password,
        'isAdmin': isAdmin,
      };

      final response = await client.post(
        '/api/stock/add-user',
        data: data,
      );

      if (response.statusCode == 200) {
        return AddUserResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to add user');
      }
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }

  Future<UpdateUserResponse> updateUser({
    required String id,
    required String password,
    required int isAdmin,
  }) async {
    try {
      final data = {
        'id': id,
        'password': password,
        'isAdmin': isAdmin,
      };

      final response = await client.post(
        '/api/stock/update-user',
        data: data,
      );

      if (response.statusCode == 200) {
        return UpdateUserResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to update user');
      }
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }
}
