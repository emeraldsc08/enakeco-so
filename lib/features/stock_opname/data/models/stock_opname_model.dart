import '../../domain/entities/stock_opname_entity.dart';

class StockOpnameModel extends StockOpnameEntity {
  const StockOpnameModel({
    required super.id,
    required super.storeName,
    required super.storeId,
    required super.date,
    required super.status,
    required super.totalItems,
    required super.verifiedItems,
    required super.discrepancies,
    required super.operator,
    super.notes,
    required super.createdAt,
    super.completedAt,
  });

  factory StockOpnameModel.fromJson(Map<String, dynamic> json) {
    return StockOpnameModel(
      id: json['id'] ?? '',
      storeName: json['storeName'] ?? '',
      storeId: json['storeId'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      status: _parseStatus(json['status'] ?? 'pending'),
      totalItems: json['totalItems'] ?? 0,
      verifiedItems: json['verifiedItems'] ?? 0,
      discrepancies: json['discrepancies'] ?? 0,
      operator: json['operator'] ?? '',
      notes: json['notes'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'])
          : null,
    );
  }

  static StockOpnameStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return StockOpnameStatus.pending;
      case 'in_progress':
      case 'inprogress':
        return StockOpnameStatus.inProgress;
      case 'completed':
        return StockOpnameStatus.completed;
      case 'cancelled':
        return StockOpnameStatus.cancelled;
      default:
        return StockOpnameStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeName': storeName,
      'storeId': storeId,
      'date': date.toIso8601String(),
      'status': status.name,
      'totalItems': totalItems,
      'verifiedItems': verifiedItems,
      'discrepancies': discrepancies,
      'operator': operator,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory StockOpnameModel.fromEntity(StockOpnameEntity entity) {
    return StockOpnameModel(
      id: entity.id,
      storeName: entity.storeName,
      storeId: entity.storeId,
      date: entity.date,
      status: entity.status,
      totalItems: entity.totalItems,
      verifiedItems: entity.verifiedItems,
      discrepancies: entity.discrepancies,
      operator: entity.operator,
      notes: entity.notes,
      createdAt: entity.createdAt,
      completedAt: entity.completedAt,
    );
  }

  StockOpnameModel copyWith({
    String? id,
    String? storeName,
    String? storeId,
    DateTime? date,
    StockOpnameStatus? status,
    int? totalItems,
    int? verifiedItems,
    int? discrepancies,
    String? operator,
    String? notes,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return StockOpnameModel(
      id: id ?? this.id,
      storeName: storeName ?? this.storeName,
      storeId: storeId ?? this.storeId,
      date: date ?? this.date,
      status: status ?? this.status,
      totalItems: totalItems ?? this.totalItems,
      verifiedItems: verifiedItems ?? this.verifiedItems,
      discrepancies: discrepancies ?? this.discrepancies,
      operator: operator ?? this.operator,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  String toString() {
    return 'StockOpnameModel(id: $id, storeName: $storeName, status: $status)';
  }
}