import 'package:dartz/dartz.dart';

import '../../domain/entities/dashboard_stats_entity.dart';
import '../../domain/repositories/main_menu_repository.dart';
import '../datasources/main_menu_remote_datasource.dart';

class MainMenuRepositoryImpl implements MainMenuRepository {
  final MainMenuRemoteDataSource remoteDataSource;

  MainMenuRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, DashboardStatsEntity>> getDashboardStats() async {
    final response = await remoteDataSource.getDashboardStats();
    if (response.success && response.data != null) {
      return Right(response.data!);
    } else {
      return Left(response.message);
    }
  }
}