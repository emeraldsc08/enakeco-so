import 'package:dartz/dartz.dart';

import '../entities/dashboard_stats_entity.dart';

abstract class MainMenuRepository {
  Future<Either<String, DashboardStatsEntity>> getDashboardStats();
}