import 'package:flutter/material.dart';

import '../../../../core/services/session_service.dart';
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
    _error = null;
    notifyListeners();
    await fetchProducts(reset: true);
  }

  Future<void> fetchProducts({bool reset = false}) async {
    if (_isLoading || (!_hasMore && !reset)) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Validate session before making API call
      final isLoggedIn = await SessionService.isLoggedIn();
      final encryptedId = await SessionService.getEncryptedId();

      if (!isLoggedIn || encryptedId == null || encryptedId.isEmpty) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      }

      print('[PRODUCT PROVIDER] Fetching products with params:');
      print('[PRODUCT PROVIDER] - search: $_search');
      print('[PRODUCT PROVIDER] - page: $_page');
      print('[PRODUCT PROVIDER] - branchId: $_branchId');
      print('[PRODUCT PROVIDER] - cGudang: $_cGudang');
      print('[PRODUCT PROVIDER] - encryptedId available: ${encryptedId.isNotEmpty}');

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

      print('[PRODUCT PROVIDER] Successfully fetched ${result.length} products');
      print('[PRODUCT PROVIDER] Total products: ${_products.length}');
      print('[PRODUCT PROVIDER] Has more: $_hasMore');

    } catch (e) {
      _error = e.toString();
      print('[PRODUCT PROVIDER] Error fetching products: $_error');

      // Check if it's a session error
      if (_error!.contains('Sesi telah berakhir') || _error!.contains('401')) {
        // This will be handled by the UI to redirect to login
        print('[PRODUCT PROVIDER] Session expired, should redirect to login');
      }
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

  void clearError() {
    _error = null;
    notifyListeners();
  }
}