import 'laporan_penjualan_model.dart';

class LaporanPenjualanResponseModel {
  final List<LaporanPenjualanModel> listLaporanPenjualan;

  LaporanPenjualanResponseModel({
    required this.listLaporanPenjualan,
  });

  factory LaporanPenjualanResponseModel.fromJson(Map<String, dynamic> json) {
    return LaporanPenjualanResponseModel(
      listLaporanPenjualan: (json['list_laporan_penjualan'] as List)
          .map((item) => LaporanPenjualanModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'list_laporan_penjualan': listLaporanPenjualan
          .map((laporan) => laporan.toJson())
          .toList(),
    };
  }

  @override
  String toString() {
    return 'LaporanPenjualanResponseModel(listLaporanPenjualan: $listLaporanPenjualan)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LaporanPenjualanResponseModel &&
        other.listLaporanPenjualan == listLaporanPenjualan;
  }

  @override
  int get hashCode {
    return listLaporanPenjualan.hashCode;
  }
}
