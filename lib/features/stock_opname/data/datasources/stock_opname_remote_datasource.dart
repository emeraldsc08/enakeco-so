import 'package:dio/dio.dart';

import '../../../../core/network/base_response.dart';
import '../../domain/entities/stock_opname_entity.dart';
import '../models/aj_generation_response_model.dart';
import '../models/laporan_penjualan_model.dart';
import '../models/stock_opname_model.dart';
import '../models/stock_opname_request_model.dart';
import '../models/stock_opname_response_model.dart';

abstract class StockOpnameRemoteDataSource {
  Future<BaseResponse<List<StockOpnameModel>>> getStockOpnameList();
  Future<BaseResponse<StockOpnameModel>> createStockOpname(
      StockOpnameModel stockOpname);
  Future<BaseResponse<List<LaporanPenjualanModel>>> getListSO(String tanggal);
  Future<BaseResponse<StockOpnameResponseModel>> saveStockOpname(
      StockOpnameRequestModel request);
  Future<BaseResponse<AjGenerationResponseModel>> generateAj();
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
  Future<BaseResponse<StockOpnameModel>> createStockOpname(
      StockOpnameModel stockOpname) async {
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

  @override
  Future<BaseResponse<List<LaporanPenjualanModel>>> getListSO(
      String tanggal) async {
    try {
      final response = await client.get(
        '/api/stock/list-so',
        queryParameters: {
          'tanggal': tanggal,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['message'] == 'Success' &&
            responseData['data'] != null) {
          final List<dynamic> dataList = responseData['data'];
          final List<LaporanPenjualanModel> laporanList = dataList
              .map((item) => LaporanPenjualanModel.fromJson(item))
              .toList();

          return BaseResponse.success(data: laporanList);
        } else {
          return BaseResponse.error(
              message: responseData['message'] ?? 'Failed to fetch data');
        }
      } else {
        return BaseResponse.error(
          message: 'Failed to fetch data',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return BaseResponse.error(message: e.toString());
    }
  }

  @override
  Future<BaseResponse<StockOpnameResponseModel>> saveStockOpname(
      StockOpnameRequestModel request) async {
    try {
      print('=== API REQUEST ===');
      print('URL: /api/stock/opname');
      print('Method: POST');
      print('Request Body: ${request.toJson()}');
      print('==================');

      final response = await client.post(
        '/api/stock/opname',
        data: request.toJson(),
      );

      print('=== API RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      print('===================');

      if (response.statusCode == 200) {
        final responseData = response.data;

        // Check if the message indicates success (contains "berhasil" or "success")
        final message = responseData['message']?.toString().toLowerCase() ?? '';
        if (message.contains('berhasil') || message.contains('success')) {
          final StockOpnameResponseModel responseModel =
              StockOpnameResponseModel.fromJson(responseData);
          return BaseResponse.success(data: responseModel);
        } else {
          print('=== API ERROR (Success=false) ===');
          print('Message: ${responseData['message']}');
          print('=================================');
          return BaseResponse.error(
              message: responseData['message'] ?? 'Failed to save data');
        }
      } else {
        print('=== API ERROR (Status != 200) ===');
        print('Status Code: ${response.statusCode}');
        print('Response: ${response.data}');
        print('=================================');
        return BaseResponse.error(
          message: 'Failed to save data',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('=== API EXCEPTION ===');
      print('Exception: $e');
      print('Exception Type: ${e.runtimeType}');
      print('====================');
      return BaseResponse.error(message: e.toString());
    }
  }

  @override
  Future<BaseResponse<AjGenerationResponseModel>> generateAj() async {
    try {
      print('=== AJ GENERATION REQUEST ===');
      print('URL: /api/stock/generate-aj');
      print('Method: GET');
      print('=============================');

      final response = await client.get('/api/stock/generate-aj');

      print('=== AJ GENERATION RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      print('==============================');

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['message'] != null && responseData['data'] != null) {
          final AjGenerationResponseModel responseModel = AjGenerationResponseModel.fromJson(responseData);
          return BaseResponse.success(data: responseModel);
        } else {
          print('=== AJ GENERATION ERROR (Missing data) ===');
          print('Response: $responseData');
          print('=========================================');
          return BaseResponse.error(message: 'Invalid response format');
        }
      } else {
        print('=== AJ GENERATION ERROR (Status != 200) ===');
        print('Status Code: ${response.statusCode}');
        print('Response: ${response.data}');
        print('==========================================');
        return BaseResponse.error(
          message: 'Failed to generate AJ',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('=== AJ GENERATION EXCEPTION ===');
      print('Exception: $e');
      print('Exception Type: ${e.runtimeType}');
      print('==============================');
      return BaseResponse.error(message: e.toString());
    }
  }
}
