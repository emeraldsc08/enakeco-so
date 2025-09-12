import 'package:dartz/dartz.dart';

import '../entities/laporan_penjualan_entity.dart';
import '../repositories/stock_opname_repository.dart';

class GetListSOUseCase {
  final StockOpnameRepository repository;

  GetListSOUseCase(this.repository);

  Future<Either<String, List<LaporanPenjualanEntity>>> call(String tanggal) {
    return repository.getListSO(tanggal);
  }
}
