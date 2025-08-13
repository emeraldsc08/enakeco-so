import 'package:equatable/equatable.dart';

class DashboardStatsEntity extends Equatable {
  final int totalItems;
  final int pendingSO;
  final int completedSO;
  final int todayTasks;
  final int totalStores;
  final int activeUsers;
  final int monthlyTransactions;
  final double yearlyGrowth;

  const DashboardStatsEntity({
    required this.totalItems,
    required this.pendingSO,
    required this.completedSO,
    required this.todayTasks,
    required this.totalStores,
    required this.activeUsers,
    required this.monthlyTransactions,
    required this.yearlyGrowth,
  });

  @override
  List<Object?> get props => [
        totalItems,
        pendingSO,
        completedSO,
        todayTasks,
        totalStores,
        activeUsers,
        monthlyTransactions,
        yearlyGrowth,
      ];
}