import 'package:dartz/dartz.dart';

import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<String, UserEntity>> login(String username, String password);
  Future<Either<String, void>> logout();
  Future<Either<String, UserEntity>> getCurrentUser();
  Future<Either<String, bool>> isLoggedIn();
}