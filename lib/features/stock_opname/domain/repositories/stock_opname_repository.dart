import 'package:dartz/dartz.dart';

import '../../data/models/stock_opname_request_model.dart';
import '../../data/models/stock_opname_response_model.dart';
import '../entities/laporan_penjualan_entity.dart';
import '../entities/stock_opname_entity.dart';

abstract class StockOpnameRepository {
  Future<Either<String, List<StockOpnameEntity>>> getStockOpnameList();
  Future<Either<String, StockOpnameEntity>> createStockOpname(StockOpnameEntity stockOpname);
  Future<Either<String, StockOpnameEntity>> getStockOpnameById(String id);
  Future<Either<String, StockOpnameEntity>> updateStockOpname(StockOpnameEntity stockOpname);
  Future<Either<String, List<LaporanPenjualanEntity>>> getListSO(String tanggal);
  Future<Either<String, StockOpnameResponseModel>> saveStockOpname(StockOpnameRequestModel request);
}