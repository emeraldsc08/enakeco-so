import '../../domain/entities/laporan_penjualan_entity.dart';
import 'barang_model.dart';

class LaporanPenjualanModel {
  final String cNoJual;
  final DateTime dTanggal;
  final String cKodeCust;
  final int total;
  final String cUserId;
  final DateTime userDate;
  final List<BarangModel> produk;

  LaporanPenjualanModel({
    required this.cNoJual,
    required this.dTanggal,
    required this.cKodeCust,
    required this.total,
    required this.cUserId,
    required this.userDate,
    required this.produk,
  });

  factory LaporanPenjualanModel.fromJson(Map<String, dynamic> json) {
    return LaporanPenjualanModel(
      cNoJual: json['cNoJual'] ?? '',
      dTanggal: DateTime.parse(json['dTanggal'] ?? DateTime.now().toIso8601String()),
      cKodeCust: json['cKodeCust'] ?? '',
      total: json['total'] ?? 0,
      cUserId: json['cUserId'] ?? '',
      userDate: DateTime.parse(json['UserDate'] ?? DateTime.now().toIso8601String()),
      produk: (json['produk'] as List?)
          ?.map((item) => BarangModel.fromJson(item))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cNoJual': cNoJual,
      'dTanggal': dTanggal.toIso8601String(),
      'cKodeCust': cKodeCust,
      'total': total,
      'cUserId': cUserId,
      'UserDate': userDate.toIso8601String(),
      'produk': produk.map((barang) => barang.toJson()).toList(),
    };
  }

  // Legacy getters for backward compatibility
  String get noJual => cNoJual;
  List<BarangModel> get listBarang => produk;
  int get subTotal => total;

  // Entity conversion methods
  LaporanPenjualanEntity toEntity() {
    return LaporanPenjualanEntity(
      cNoJual: cNoJual,
      dTanggal: dTanggal,
      cKodeCust: cKodeCust,
      total: total,
      cUserId: cUserId,
      userDate: userDate,
      produk: produk.map((barang) => barang.toEntity()).toList(),
    );
  }

  factory LaporanPenjualanModel.fromEntity(LaporanPenjualanEntity entity) {
    return LaporanPenjualanModel(
      cNoJual: entity.cNoJual,
      dTanggal: entity.dTanggal,
      cKodeCust: entity.cKodeCust,
      total: entity.total,
      cUserId: entity.cUserId,
      userDate: entity.userDate,
      produk: entity.produk.map((barang) => BarangModel.fromEntity(barang)).toList(),
    );
  }

  @override
  String toString() {
    return 'LaporanPenjualanModel(noJual: $noJual, listBarang: $listBarang, subTotal: $subTotal)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LaporanPenjualanModel &&
        other.noJual == noJual &&
        other.listBarang == listBarang &&
        other.subTotal == subTotal;
  }

  @override
  int get hashCode {
    return noJual.hashCode ^ listBarang.hashCode ^ subTotal.hashCode;
  }
}
