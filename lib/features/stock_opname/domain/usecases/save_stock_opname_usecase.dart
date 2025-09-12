import 'package:dartz/dartz.dart';

import '../../data/models/stock_opname_request_model.dart';
import '../../data/models/stock_opname_response_model.dart';
import '../repositories/stock_opname_repository.dart';

class SaveStockOpnameUseCase {
  final StockOpnameRepository repository;

  SaveStockOpnameUseCase(this.repository);

  Future<Either<String, StockOpnameResponseModel>> call(StockOpnameRequestModel request) {
    return repository.saveStockOpname(request);
  }
}
