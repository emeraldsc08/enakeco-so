import '../../domain/entities/barang_entity.dart';

class BarangModel {
  final String cNoid;
  final String cKodeBrg;
  final String cNama;
  final int nQty;
  final int nhrgJual;
  final int nSTotal;

  BarangModel({
    required this.cNoid,
    required this.cKodeBrg,
    required this.cNama,
    required this.nQty,
    required this.nhrgJual,
    required this.nSTotal,
  });

  factory BarangModel.fromJson(Map<String, dynamic> json) {
    return BarangModel(
      cNoid: json['cNoid'] ?? '',
      cKodeBrg: json['cKodeBrg'] ?? '',
      cNama: json['cNama'] ?? '',
      nQty: json['nQty'] ?? 0,
      nhrgJual: json['nhrgJual'] ?? 0,
      nSTotal: json['nSTotal'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cNoid': cNoid,
      'cKodeBrg': cKodeBrg,
      'cNama': cNama,
      'nQty': nQty,
      'nhrgJual': nhrgJual,
      'nSTotal': nSTotal,
    };
  }

  // Legacy getters for backward compatibility
  String get barangId => cKodeBrg;
  String get namaBarang => cNama;
  String get jumlahBarang => ''; // Not available in API response
  int get price => nhrgJual;
  int get qty => nQty;

  // Entity conversion methods
  BarangEntity toEntity() {
    return BarangEntity(
      cNoid: cNoid,
      cKodeBrg: cKodeBrg,
      cNama: cNama,
      nQty: nQty,
      nhrgJual: nhrgJual,
      nSTotal: nSTotal,
    );
  }

  factory BarangModel.fromEntity(BarangEntity entity) {
    return BarangModel(
      cNoid: entity.cNoid,
      cKodeBrg: entity.cKodeBrg,
      cNama: entity.cNama,
      nQty: entity.nQty,
      nhrgJual: entity.nhrgJual,
      nSTotal: entity.nSTotal,
    );
  }

  @override
  String toString() {
    return 'BarangModel(barangId: $barangId, namaBarang: $namaBarang, jumlahBarang: $jumlahBarang, price: $price, qty: $qty)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BarangModel &&
        other.barangId == barangId &&
        other.namaBarang == namaBarang &&
        other.jumlahBarang == jumlahBarang &&
        other.price == price &&
        other.qty == qty;
  }

  @override
  int get hashCode {
    return barangId.hashCode ^
        namaBarang.hashCode ^
        jumlahBarang.hashCode ^
        price.hashCode ^
        qty.hashCode;
  }
}
