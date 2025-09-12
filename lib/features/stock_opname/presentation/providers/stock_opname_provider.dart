import 'package:flutter/material.dart';

import '../../data/models/stock_opname_request_model.dart';
import '../../domain/entities/laporan_penjualan_entity.dart';
import '../../domain/entities/stock_opname_entity.dart';
import '../../domain/usecases/create_stock_opname_usecase.dart';
import '../../domain/usecases/generate_aj_usecase.dart';
import '../../domain/usecases/get_list_so_usecase.dart';
import '../../domain/usecases/get_stock_opname_list_usecase.dart';
import '../../domain/usecases/save_stock_opname_usecase.dart';

class StockOpnameProvider extends ChangeNotifier {
  final GetStockOpnameListUseCase getStockOpnameListUseCase;
  final CreateStockOpnameUseCase createStockOpnameUseCase;
  final GetListSOUseCase getListSOUseCase;
  final SaveStockOpnameUseCase saveStockOpnameUseCase;
  final GenerateAjUseCase generateAjUseCase;

  StockOpnameProvider(
      this.getStockOpnameListUseCase,
      this.createStockOpnameUseCase,
      this.getListSOUseCase,
      this.saveStockOpnameUseCase,
      this.generateAjUseCase);

  bool _isLoading = false;
  List<StockOpnameEntity> _stockOpnameList = [];
  List<LaporanPenjualanEntity> _laporanPenjualanList = [];
  String? _error;
  String? _generatedAj;

  bool get isLoading => _isLoading;
  List<StockOpnameEntity> get stockOpnameList => _stockOpnameList;
  List<LaporanPenjualanEntity> get laporanPenjualanList =>
      _laporanPenjualanList;
  String? get error => _error;
  String? get generatedAj => _generatedAj;

  Future<bool> getStockOpnameList() async {
    _setLoading(true);
    _clearError();

    final result = await getStockOpnameListUseCase();

    return result.fold(
      (error) {
        _setError(error);
        _setLoading(false);
        return false;
      },
      (stockOpnames) {
        _setStockOpnameList(stockOpnames);
        _setLoading(false);
        return true;
      },
    );
  }

  Future<bool> createStockOpname(StockOpnameEntity stockOpname) async {
    _setLoading(true);
    _clearError();

    final result = await createStockOpnameUseCase(stockOpname);

    return result.fold(
      (error) {
        _setError(error);
        _setLoading(false);
        return false;
      },
      (newStockOpname) {
        _addStockOpname(newStockOpname);
        _setLoading(false);
        return true;
      },
    );
  }

  Future<bool> getListSO(String tanggal) async {
    _setLoading(true);
    _clearError();

    final result = await getListSOUseCase(tanggal);

    return result.fold(
      (error) {
        _setError(error);
        _setLoading(false);
        return false;
      },
      (laporanList) {
        _setLaporanPenjualanList(laporanList);
        _setLoading(false);
        return true;
      },
    );
  }

  Future<bool> saveStockOpname(StockOpnameRequestModel request) async {
    _setLoading(true);
    _clearError();

    print('=== PROVIDER SAVE REQUEST ===');
    print('Request: ${request.toJson()}');
    print('=============================');

    final result = await saveStockOpnameUseCase(request);

    return result.fold(
      (error) {
        print('=== PROVIDER SAVE ERROR ===');
        print('Error: $error');
        print('===========================');
        _setError(error);
        _setLoading(false);
        return false;
      },
      (response) {
        print('=== PROVIDER SAVE SUCCESS ===');
        print('Response: ${response.message}');
        print('=============================');
        _setLoading(false);
        return true;
      },
    );
  }

  Future<bool> generateAj() async {
    _setLoading(true);
    _clearError();

    print('=== PROVIDER GENERATE AJ REQUEST ===');
    print('Generating AJ...');
    print('===================================');

    final result = await generateAjUseCase();

    return result.fold(
      (error) {
        print('=== PROVIDER GENERATE AJ ERROR ===');
        print('Error: $error');
        print('=================================');
        _setError(error);
        _setLoading(false);
        return false;
      },
      (response) {
        print('=== PROVIDER GENERATE AJ SUCCESS ===');
        print('Generated AJ: ${response.data}');
        print('===================================');
        _generatedAj = response.data;
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setStockOpnameList(List<StockOpnameEntity> stockOpnames) {
    _stockOpnameList = stockOpnames;
    notifyListeners();
  }

  void _setLaporanPenjualanList(List<LaporanPenjualanEntity> laporanList) {
    _laporanPenjualanList = laporanList;
    notifyListeners();
  }

  void _addStockOpname(StockOpnameEntity stockOpname) {
    _stockOpnameList.insert(0, stockOpname);
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
