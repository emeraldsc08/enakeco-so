class ProductDetailModel {
  final String cNama;
  final String cKode;
  final String cKodebar;
  final String cSat1;
  final String cSat2;
  final String cSat3;
  final int nIsi;
  final int nIsi2;
  final int qty1;
  final int qty2;
  final int qty3;
  final String cGudang;
  final int nSaldo;
  final String? image;

  ProductDetailModel({
    required this.cNama,
    required this.cKode,
    required this.cKodebar,
    required this.cSat1,
    required this.cSat2,
    required this.cSat3,
    required this.nIsi,
    required this.nIsi2,
    required this.qty1,
    required this.qty2,
    required this.qty3,
    required this.cGudang,
    required this.nSaldo,
    this.image,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      cNama: json['cNama'] ?? '',
      cKode: json['cKode'] ?? '',
      cKodebar: json['cKodebar'] ?? '',
      cSat1: json['cSat1'] ?? '',
      cSat2: json['cSat2'] ?? '',
      cSat3: json['cSat3'] ?? '',
      nIsi: json['nIsi'] ?? 0,
      nIsi2: json['nIsi2'] ?? 0,
      qty1: json['qty1'] ?? 0,
      qty2: json['qty2'] ?? 0,
      qty3: json['qty3'] ?? 0,
      cGudang: json['cGudang'] ?? '',
      nSaldo: json['nSaldo'] ?? 0,
      image: json['image'],
    );
  }
}