import 'package:dartz/dartz.dart';

import '../entities/dashboard_stats_entity.dart';
import '../repositories/main_menu_repository.dart';

class GetDashboardStatsUseCase {
  final MainMenuRepository repository;

  GetDashboardStatsUseCase(this.repository);

  Future<Either<String, DashboardStatsEntity>> call() {
    return repository.getDashboardStats();
  }
}