import 'package:flutter/material.dart';

import '../../rtl/data/repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductListProvider extends ChangeNotifier {
  final ProductRepository repository;
  ProductListProvider({required this.repository});

  List<ProductModel> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  String? _error;
  String? _search;
  int _branchId = 1;
  String _cGudang = 'GRS';

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;
  String? get search => _search;
  int get branchId => _branchId;
  String get cGudang => _cGudang;

  void setBranchId(int id) {
    _branchId = id;
    notifyListeners();
  }

  void setCGudang(String value) {
    _cGudang = value;
    notifyListeners();
  }

  Future<void> searchProducts(String? search) async {
    _search = search;
    _page = 1;
    _hasMore = true;
    _products = [];
    notifyListeners();
    await fetchProducts(reset: true);
  }

  Future<void> fetchProducts({bool reset = false}) async {
    if (_isLoading || (!_hasMore && !reset)) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await repository.fetchProducts(
        search: _search,
        page: _page,
        branchId: _branchId,
        cGudang: _cGudang,
      );
      if (reset) {
        _products = result;
      } else {
        _products.addAll(result);
      }
      if (_search != null && _search!.isNotEmpty) {
        _hasMore = false;
      } else {
        _hasMore = result.isNotEmpty;
        if (_hasMore) _page++;
      }
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  void reset() {
    _products = [];
    _isLoading = false;
    _hasMore = true;
    _page = 1;
    _error = null;
    _search = null;
    notifyListeners();
  }
}