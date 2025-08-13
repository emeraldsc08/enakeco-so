import 'package:dio/dio.dart';

import '../../../../core/network/base_response.dart';
import '../models/dashboard_stats_model.dart';

abstract class MainMenuRemoteDataSource {
  Future<BaseResponse<DashboardStatsModel>> getDashboardStats();
}

class MainMenuRemoteDataSourceImpl implements MainMenuRemoteDataSource {
  final Dio client;

  MainMenuRemoteDataSourceImpl({required this.client});

  @override
  Future<BaseResponse<DashboardStatsModel>> getDashboardStats() async {
    try {
      // Dummy data
      await Future.delayed(const Duration(seconds: 1));

      const stats = DashboardStatsModel(
        totalItems: 1234,
        pendingSO: 12,
        completedSO: 89,
        todayTasks: 5,
        totalStores: 8,
        activeUsers: 15,
        monthlyTransactions: 456,
        yearlyGrowth: 23.5,
      );

      return BaseResponse.success(data: stats);
    } catch (e) {
      return BaseResponse.error(message: e.toString());
    }
  }
}