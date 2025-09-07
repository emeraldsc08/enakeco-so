class BarangModel {
  final String barangId;
  final String namaBarang;
  final String jumlahBarang;
  final int price;
  final int qty;

  BarangModel({
    required this.barangId,
    required this.namaBarang,
    required this.jumlahBarang,
    required this.price,
    required this.qty,
  });

  factory BarangModel.fromJson(Map<String, dynamic> json) {
    return BarangModel(
      barangId: json['barang_id'],
      namaBarang: json['nama_barang'],
      jumlahBarang: json['jumlah_barang'],
      price: json['price'],
      qty: json['qty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barang_id': barangId,
      'nama_barang': namaBarang,
      'jumlah_barang': jumlahBarang,
      'price': price,
      'qty': qty,
    };
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
