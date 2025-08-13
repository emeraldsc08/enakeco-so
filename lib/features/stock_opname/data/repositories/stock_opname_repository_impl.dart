import 'package:dartz/dartz.dart';

import '../../domain/entities/stock_opname_entity.dart';
import '../../domain/repositories/stock_opname_repository.dart';
import '../datasources/stock_opname_remote_datasource.dart';
import '../models/stock_opname_model.dart';

class StockOpnameRepositoryImpl implements StockOpnameRepository {
  final StockOpnameRemoteDataSource remoteDataSource;

  StockOpnameRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, List<StockOpnameEntity>>> getStockOpnameList() async {
    final response = await remoteDataSource.getStockOpnameList();
    if (response.success && response.data != null) {
      return Right(response.data!);
    } else {
      return Left(response.message);
    }
  }

  @override
  Future<Either<String, StockOpnameEntity>> createStockOpname(StockOpnameEntity stockOpname) async {
    final response = await remoteDataSource.createStockOpname(
      StockOpnameModel.fromEntity(stockOpname),
    );
    if (response.success && response.data != null) {
      return Right(response.data!);
    } else {
      return Left(response.message);
    }
  }

  @override
  Future<Either<String, StockOpnameEntity>> getStockOpnameById(String id) async {
    // Dummy implementation
    return const Left('Not implemented');
  }

  @override
  Future<Either<String, StockOpnameEntity>> updateStockOpname(StockOpnameEntity stockOpname) async {
    // Dummy implementation
    return const Left('Not implemented');
  }
}