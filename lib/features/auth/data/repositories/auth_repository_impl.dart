import 'package:dartz/dartz.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, UserEntity>> login(String username, String password) async {
    final response = await remoteDataSource.login(username, password);
    if (response.success && response.data != null) {
      return Right(response.data!);
    } else {
      return Left(response.message);
    }
  }

  @override
  Future<Either<String, void>> logout() async {
    return const Right(null);
  }

  @override
  Future<Either<String, UserEntity>> getCurrentUser() async {
    final response = await remoteDataSource.getCurrentUser();
    if (response.success && response.data != null) {
      return Right(response.data!);
    } else {
      return Left(response.message);
    }
  }

  @override
  Future<Either<String, bool>> isLoggedIn() async {
    return const Right(true);
  }
}
