import '../datasources/user_settings_remote_datasource.dart';
import '../models/add_user_model.dart';
import '../models/master_user_model.dart';
import '../models/update_user_model.dart';
import '../models/user_settings_model.dart';

class UserSettingsRepository {
  final UserSettingsRemoteDataSource remoteDataSource;

  UserSettingsRepository({required this.remoteDataSource});

  Future<UserSettingsResponse> fetchUsers() {
    return remoteDataSource.fetchUsers();
  }

  Future<MasterUserResponse> fetchMasterUsers({String? search}) {
    return remoteDataSource.fetchMasterUsers(search: search);
  }

  Future<AddUserResponse> addUser({
    required int id,
    required String password,
    required int isAdmin,
  }) {
    return remoteDataSource.addUser(
      id: id,
      password: password,
      isAdmin: isAdmin,
    );
  }

  Future<UpdateUserResponse> updateUser({
    required String id,
    required String password,
    required int isAdmin,
  }) {
    return remoteDataSource.updateUser(
      id: id,
      password: password,
      isAdmin: isAdmin,
    );
  }
}
