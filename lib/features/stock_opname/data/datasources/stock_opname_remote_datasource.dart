import 'package:dio/dio.dart';

import '../../../../core/network/base_response.dart';
import '../../domain/entities/stock_opname_entity.dart';
import '../models/stock_opname_model.dart';

abstract class StockOpnameRemoteDataSource {
  Future<BaseResponse<List<StockOpnameModel>>> getStockOpnameList();
  Future<BaseResponse<StockOpnameModel>> createStockOpname(StockOpnameModel stockOpname);
}

class StockOpnameRemoteDataSourceImpl implements StockOpnameRemoteDataSource {
  final Dio client;

  StockOpnameRemoteDataSourceImpl({required this.client});

  @override
  Future<BaseResponse<List<StockOpnameModel>>> getStockOpnameList() async {
    try {
      // Dummy data
      await Future.delayed(const Duration(seconds: 1));

      final stockOpnames = [
        StockOpnameModel(
          id: 'SO001',
          storeName: 'Toko Central',
          storeId: 'ST001',
          date: DateTime.now().subtract(const Duration(days: 1)),
          status: StockOpnameStatus.completed,
          totalItems: 150,
          verifiedItems: 150,
          discrepancies: 3,
          operator: 'John Doe',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          completedAt: DateTime.now().subtract(const Duration(hours: 12)),
        ),
        StockOpnameModel(
          id: 'SO002',
          storeName: 'Toko Mall',
          storeId: 'ST002',
          date: DateTime.now(),
          status: StockOpnameStatus.inProgress,
          totalItems: 200,
          verifiedItems: 120,
          discrepancies: 0,
          operator: 'Jane Smith',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];

      return BaseResponse.success(data: stockOpnames);
    } catch (e) {
      return BaseResponse.error(message: e.toString());
    }
  }

  @override
  Future<BaseResponse<StockOpnameModel>> createStockOpname(StockOpnameModel stockOpname) async {
    try {
      // Dummy implementation
      await Future.delayed(const Duration(seconds: 1));

      final newStockOpname = StockOpnameModel(
        id: 'SO${DateTime.now().millisecondsSinceEpoch}',
        storeName: stockOpname.storeName,
        storeId: stockOpname.storeId,
        date: stockOpname.date,
        status: StockOpnameStatus.pending,
        totalItems: stockOpname.totalItems,
        verifiedItems: 0,
        discrepancies: 0,
        operator: stockOpname.operator,
        notes: stockOpname.notes,
        createdAt: DateTime.now(),
      );

      return BaseResponse.success(data: newStockOpname);
    } catch (e) {
      return BaseResponse.error(message: e.toString());
    }
  }
}