import 'package:dartz/dartz.dart';

import '../entities/stock_opname_entity.dart';
import '../repositories/stock_opname_repository.dart';

class GetStockOpnameListUseCase {
  final StockOpnameRepository repository;

  GetStockOpnameListUseCase(this.repository);

  Future<Either<String, List<StockOpnameEntity>>> call() {
    return repository.getStockOpnameList();
  }
}