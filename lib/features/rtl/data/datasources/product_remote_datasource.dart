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
      print('[DIO REQUEST] /api/stock/list');
      print('[DIO REQUEST] Headers: ${client.options.headers}');
      print('[DIO REQUEST] Body: $data');

      final response = await client.post('/api/stock/list', data: data);

      print('[DIO RESPONSE] /api/stock/list');
      print('[DIO RESPONSE] Status: ${response.statusCode}');
      print('[DIO RESPONSE] Data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data['data'] ?? [];
        final products = list.map((e) => ProductModel.fromJson(e)).toList();
        print('[DIO RESPONSE] Parsed ${products.length} products');
        return products;
      } else {
        final errorMessage = response.data['message'] ?? 'Gagal mengambil data';
        print('[DIO ERROR] API Error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e, s) {
      print('[DIO ERROR] /api/stock/list');
      print('[DIO ERROR] Error: ${e.toString()}');
      print('[DIO ERROR] Stack: ${s.toString()}');

      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          throw Exception('Sesi telah berakhir. Silakan login kembali.');
        } else if (e.type == DioExceptionType.connectionTimeout) {
          throw Exception('Koneksi timeout. Periksa koneksi internet Anda.');
        } else if (e.type == DioExceptionType.receiveTimeout) {
          throw Exception('Request timeout. Silakan coba lagi.');
        } else if (e.type == DioExceptionType.connectionError) {
          throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
        }
      }

      rethrow;
    }
  }

  Future<List<ProductDetailModel>> fetchProductDetail({
    String? cKode,
    required int branchId,
    required String cGudang,
    String? cKodebar,
  }) async {
    final data = {
      'cKode': cKode ?? '', // Empty string if null
      'cKodebar': cKodebar ?? cKode ?? '', // Use cKodebar first, then cKode as fallback
      'branch_id': branchId,
      'cGudang': cGudang,
    };

    // Catatan penggunaan parameter:
    // - cKode: Digunakan ketika user mengklik produk dari list (menggunakan kode produk), null jika dari scan
    // - cKodebar: Digunakan ketika user scan barcode (menggunakan value dari hasil scan)
    // Prioritas: cKodebar > cKode > empty string
    try {
      print('[DIO REQUEST] /api/stock/detail');
      print('[DIO REQUEST] Headers: ${client.options.headers}');
      print('[DIO REQUEST] Body: $data');

      final response = await client.post('/api/stock/detail', data: data);

      print('[DIO RESPONSE] /api/stock/detail');
      print('[DIO RESPONSE] Status: ${response.statusCode}');
      print('[DIO RESPONSE] Data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data['data'] ?? [];
        final details = list.map((e) => ProductDetailModel.fromJson(e)).toList();
        print('[DIO RESPONSE] Parsed ${details.length} product details');
        return details;
      } else {
        final errorMessage = response.data['message'] ?? 'Gagal mengambil detail produk';
        print('[DIO ERROR] API Error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e, s) {
      print('[DIO ERROR] /api/stock/detail');
      print('[DIO ERROR] Error: ${e.toString()}');
      print('[DIO ERROR] Stack: ${s.toString()}');

      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          throw Exception('Sesi telah berakhir. Silakan login kembali.');
        } else if (e.type == DioExceptionType.connectionTimeout) {
          throw Exception('Koneksi timeout. Periksa koneksi internet Anda.');
        } else if (e.type == DioExceptionType.receiveTimeout) {
          throw Exception('Request timeout. Silakan coba lagi.');
        } else if (e.type == DioExceptionType.connectionError) {
          throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
        }
      }

      rethrow;
    }
  }
}
