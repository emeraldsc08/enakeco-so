import 'package:equatable/equatable.dart';

enum StockOpnameStatus {
  pending,
  inProgress,
  completed,
  cancelled,
}

class StockOpnameEntity extends Equatable {
  final String id;
  final String storeName;
  final String storeId;
  final DateTime date;
  final StockOpnameStatus status;
  final int totalItems;
  final int verifiedItems;
  final int discrepancies;
  final String operator;
  final String? notes;
  final DateTime createdAt;
  final DateTime? completedAt;

  const StockOpnameEntity({
    required this.id,
    required this.storeName,
    required this.storeId,
    required this.date,
    required this.status,
    required this.totalItems,
    required this.verifiedItems,
    required this.discrepancies,
    required this.operator,
    this.notes,
    required this.createdAt,
    this.completedAt,
  });

  double get progressPercentage {
    if (totalItems == 0) return 0.0;
    return (verifiedItems / totalItems) * 100;
  }

  bool get isCompleted => status == StockOpnameStatus.completed;
  bool get isInProgress => status == StockOpnameStatus.inProgress;
  bool get isPending => status == StockOpnameStatus.pending;

  @override
  List<Object?> get props => [
        id,
        storeName,
        storeId,
        date,
        status,
        totalItems,
        verifiedItems,
        discrepancies,
        operator,
        notes,
        createdAt,
        completedAt,
      ];
}