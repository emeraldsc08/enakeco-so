import 'package:equatable/equatable.dart';

import 'barang_entity.dart';

class LaporanPenjualanEntity extends Equatable {
  final String cNoJual;
  final DateTime dTanggal;
  final String cKodeCust;
  final int total;
  final String cUserId;
  final DateTime userDate;
  final List<BarangEntity> produk;

  const LaporanPenjualanEntity({
    required this.cNoJual,
    required this.dTanggal,
    required this.cKodeCust,
    required this.total,
    required this.cUserId,
    required this.userDate,
    required this.produk,
  });

  // Legacy getters for backward compatibility
  String get noJual => cNoJual;
  List<BarangEntity> get listBarang => produk;
  int get subTotal => total;

  @override
  List<Object?> get props => [
        cNoJual,
        dTanggal,
        cKodeCust,
        total,
        cUserId,
        userDate,
        produk,
      ];
}
