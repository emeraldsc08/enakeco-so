import 'package:dartz/dartz.dart';

import '../entities/stock_opname_entity.dart';
import '../repositories/stock_opname_repository.dart';

class CreateStockOpnameUseCase {
  final StockOpnameRepository repository;

  CreateStockOpnameUseCase(this.repository);

  Future<Either<String, StockOpnameEntity>> call(StockOpnameEntity stockOpname) {
    return repository.createStockOpname(stockOpname);
  }
}