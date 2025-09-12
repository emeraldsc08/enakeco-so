import 'package:equatable/equatable.dart';

class StockOpnameRequestModel extends Equatable {
  final String cGudang;
  final String cKeterangan;
  final List<StockOpnameDetailModel> details;

  const StockOpnameRequestModel({
    required this.cGudang,
    required this.cKeterangan,
    required this.details,
  });

  factory StockOpnameRequestModel.fromJson(Map<String, dynamic> json) {
    return StockOpnameRequestModel(
      cGudang: json['cGudang'] ?? '',
      cKeterangan: json['cKeterangan'] ?? '',
      details: (json['details'] as List?)
          ?.map((item) => StockOpnameDetailModel.fromJson(item))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cGudang': cGudang,
      'cKeterangan': cKeterangan,
      'details': details.map((detail) => detail.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [cGudang, cKeterangan, details];
}

class StockOpnameDetailModel extends Equatable {
  final String cKode;
  final int nQty1;
  final int nQty2;
  final int nQty3;

  const StockOpnameDetailModel({
    required this.cKode,
    required this.nQty1,
    required this.nQty2,
    required this.nQty3,
  });

  factory StockOpnameDetailModel.fromJson(Map<String, dynamic> json) {
    return StockOpnameDetailModel(
      cKode: json['cKode'] ?? '',
      nQty1: json['nQty1'] ?? 0,
      nQty2: json['nQty2'] ?? 0,
      nQty3: json['nQty3'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cKode': cKode,
      'nQty1': nQty1,
      'nQty2': nQty2,
      'nQty3': nQty3,
    };
  }

  @override
  List<Object?> get props => [cKode, nQty1, nQty2, nQty3];
}
