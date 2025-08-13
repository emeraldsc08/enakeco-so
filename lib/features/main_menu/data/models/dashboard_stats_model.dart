import '../../domain/entities/dashboard_stats_entity.dart';

class DashboardStatsModel extends DashboardStatsEntity {
  const DashboardStatsModel({
    required super.totalItems,
    required super.pendingSO,
    required super.completedSO,
    required super.todayTasks,
    required super.totalStores,
    required super.activeUsers,
    required super.monthlyTransactions,
    required super.yearlyGrowth,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalItems: json['totalItems'] ?? 0,
      pendingSO: json['pendingSO'] ?? 0,
      completedSO: json['completedSO'] ?? 0,
      todayTasks: json['todayTasks'] ?? 0,
      totalStores: json['totalStores'] ?? 0,
      activeUsers: json['activeUsers'] ?? 0,
      monthlyTransactions: json['monthlyTransactions'] ?? 0,
      yearlyGrowth: (json['yearlyGrowth'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalItems': totalItems,
      'pendingSO': pendingSO,
      'completedSO': completedSO,
      'todayTasks': todayTasks,
      'totalStores': totalStores,
      'activeUsers': activeUsers,
      'monthlyTransactions': monthlyTransactions,
      'yearlyGrowth': yearlyGrowth,
    };
  }

  factory DashboardStatsModel.fromEntity(DashboardStatsEntity entity) {
    return DashboardStatsModel(
      totalItems: entity.totalItems,
      pendingSO: entity.pendingSO,
      completedSO: entity.completedSO,
      todayTasks: entity.todayTasks,
      totalStores: entity.totalStores,
      activeUsers: entity.activeUsers,
      monthlyTransactions: entity.monthlyTransactions,
      yearlyGrowth: entity.yearlyGrowth,
    );
  }
}