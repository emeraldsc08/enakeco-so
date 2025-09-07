import 'barang_model.dart';

class LaporanPenjualanModel {
  final String noJual;
  final List<BarangModel> listBarang;
  final int subTotal;

  LaporanPenjualanModel({
    required this.noJual,
    required this.listBarang,
    required this.subTotal,
  });

  factory LaporanPenjualanModel.fromJson(Map<String, dynamic> json) {
    return LaporanPenjualanModel(
      noJual: json['no_jual'],
      listBarang: (json['list_barang'] as List)
          .map((item) => BarangModel.fromJson(item))
          .toList(),
      subTotal: json['sub_total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no_jual': noJual,
      'list_barang': listBarang.map((barang) => barang.toJson()).toList(),
      'sub_total': subTotal,
    };
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
