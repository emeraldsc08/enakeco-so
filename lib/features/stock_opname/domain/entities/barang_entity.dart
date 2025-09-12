import 'package:equatable/equatable.dart';

class BarangEntity extends Equatable {
  final String cNoid;
  final String cKodeBrg;
  final String cNama;
  final int nQty;
  final int nhrgJual;
  final int nSTotal;

  const BarangEntity({
    required this.cNoid,
    required this.cKodeBrg,
    required this.cNama,
    required this.nQty,
    required this.nhrgJual,
    required this.nSTotal,
  });

  // Legacy getters for backward compatibility
  String get barangId => cKodeBrg;
  String get namaBarang => cNama;
  String get jumlahBarang => ''; // Not available in API response
  int get price => nhrgJual;
  int get qty => nQty;

  @override
  List<Object?> get props => [
        cNoid,
        cKodeBrg,
        cNama,
        nQty,
        nhrgJual,
        nSTotal,
      ];
}
