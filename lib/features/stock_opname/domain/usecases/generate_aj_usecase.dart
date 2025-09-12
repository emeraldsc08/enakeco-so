import 'package:dartz/dartz.dart';

import '../../data/models/aj_generation_response_model.dart';
import '../repositories/stock_opname_repository.dart';

class GenerateAjUseCase {
  final StockOpnameRepository repository;

  GenerateAjUseCase(this.repository);

  Future<Either<String, AjGenerationResponseModel>> call() {
    return repository.generateAj();
  }
}
