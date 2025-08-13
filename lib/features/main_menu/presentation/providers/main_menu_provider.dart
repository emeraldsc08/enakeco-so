import 'package:flutter/material.dart';

import '../../domain/entities/dashboard_stats_entity.dart';
import '../../domain/usecases/get_dashboard_stats_usecase.dart';

class MainMenuProvider extends ChangeNotifier {
  final GetDashboardStatsUseCase getDashboardStatsUseCase;

  MainMenuProvider(this.getDashboardStatsUseCase);

  bool _isLoading = false;
  DashboardStatsEntity? _dashboardStats;
  String? _error;

  bool get isLoading => _isLoading;
  DashboardStatsEntity? get dashboardStats => _dashboardStats;
  String? get error => _error;

  Future<bool> getDashboardStats() async {
    _setLoading(true);
    _clearError();

    final result = await getDashboardStatsUseCase();

    return result.fold(
      (error) {
        _setError(error);
        _setLoading(false);
        return false;
      },
      (stats) {
        _setDashboardStats(stats);
        _setLoading(false);
        return true;
      },
    );
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setDashboardStats(DashboardStatsEntity stats) {
    _dashboardStats = stats;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}