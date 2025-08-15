import 'package:enakeco_so/features/shared/models/product_detail_model.dart';
import 'package:enakeco_so/features/shared/models/product_model.dart';

import '../datasources/product_remote_datasource.dart';

class ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  ProductRepository({required this.remoteDataSource});

  Future<List<ProductModel>> fetchProducts({
    String? search,
    required int page,
    required int branchId,
    required String cGudang,
  }) {
    return remoteDataSource.fetchProducts(
      search: search,
      page: page,
      branchId: branchId,
      cGudang: cGudang,
    );
  }

  Future<List<ProductDetailModel>> fetchProductDetail({
    String? cKode,
    required int branchId,
    required String cGudang,
    String? cKodebar,
  }) {
    // Catatan penggunaan parameter:
    // - cKode: Digunakan ketika user mengklik produk dari list (menggunakan kode produk), null jika dari scan
    // - cKodebar: Digunakan ketika user scan barcode (menggunakan value dari hasil scan)
    // Prioritas: cKodebar > cKode > empty string
    return remoteDataSource.fetchProductDetail(
      cKode: cKode,
      branchId: branchId,
      cGudang: cGudang,
      cKodebar: cKodebar,
    );
  }
}
