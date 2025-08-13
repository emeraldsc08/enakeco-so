import 'package:dartz/dartz.dart';

import '../entities/stock_opname_entity.dart';

abstract class StockOpnameRepository {
  Future<Either<String, List<StockOpnameEntity>>> getStockOpnameList();
  Future<Either<String, StockOpnameEntity>> createStockOpname(StockOpnameEntity stockOpname);
  Future<Either<String, StockOpnameEntity>> getStockOpnameById(String id);
  Future<Either<String, StockOpnameEntity>> updateStockOpname(StockOpnameEntity stockOpname);
}