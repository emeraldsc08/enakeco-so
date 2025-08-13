class ProductModel {
  final String cNama;
  final String cKode;
  final String cGudang;
  final DateTime dTglBeli;
  final String? image;

  ProductModel({
    required this.cNama,
    required this.cKode,
    required this.cGudang,
    required this.dTglBeli,
    this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      cNama: json['cNama'] ?? '',
      cKode: json['cKode'] ?? '',
      cGudang: json['cGudang'] ?? '',
      dTglBeli: DateTime.tryParse(json['dTglBeli'] ?? '') ?? DateTime.now(),
      image: json['image'],
    );
  }
}