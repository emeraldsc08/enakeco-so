import 'package:dio/dio.dart';
import 'package:enakeco_so/features/shared/models/product_detail_model.dart';
import 'package:enakeco_so/features/shared/models/product_model.dart';

class ProductRemoteDataSource {
  final Dio client;
  ProductRemoteDataSource({required this.client});

  Future<List<ProductModel>> fetchProducts({
    String? search,
    required int page,
    required int branchId,
    required String cGudang,
  }) async {
    final data = {
      'search': search ?? '',
      'page': page,
      'branch_id': branchId,
      'cGudang': cGudang,
    };
    try {
      print('[DIO REQUEST] /api/stock/list\nBody: $data');
      final response = await client.post('/api/stock/list', data: data);
      print('[DIO RESPONSE] /api/stock/list\nStatus: \\${response.statusCode}\nData: \\${response.data}');
      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data['data'] ?? [];
        return list.map((e) => ProductModel.fromJson(e)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Gagal mengambil data');
      }
    } catch (e, s) {
      print('[DIO ERROR] /api/stock/list\nError: \\${e.toString()}\nStack: \\${s.toString()}');
      rethrow;
    }
  }

  Future<List<ProductDetailModel>> fetchProductDetail({
    required String cKode,
    required int branchId,
    required String cGudang,
  }) async {
    final data = {
      'cKode': cKode,
      'branch_id': branchId,
      'cGudang': cGudang,
    };
    try {
      print('[DIO REQUEST] /api/stock/detail\nBody: $data');
      final response = await client.post('/api/stock/detail', data: data);
      print('[DIO RESPONSE] /api/stock/detail\nStatus: \\${response.statusCode}\nData: \\${response.data}');
      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data['data'] ?? [];
        return list.map((e) => ProductDetailModel.fromJson(e)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Gagal mengambil detail produk');
      }
    } catch (e, s) {
      print('[DIO ERROR] /api/stock/detail\nError: \\${e.toString()}\nStack: \\${s.toString()}');
      rethrow;
    }
  }
}
