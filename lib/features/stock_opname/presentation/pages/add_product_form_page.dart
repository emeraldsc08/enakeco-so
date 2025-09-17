import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/providers/global_branch_provider.dart';
import '../../../rtl/data/datasources/product_remote_datasource.dart';
import '../../../rtl/data/repositories/product_repository.dart';
import '../../../rtl/presentation/pages/qr_scanner_page.dart';
import '../../../shared/models/product_detail_model.dart';

class AddProductFormPage extends StatefulWidget {
  final String selectedGudang;
  final Function(ProductDetailModel?) onProductSaved;

  const AddProductFormPage({
    super.key,
    required this.selectedGudang,
    required this.onProductSaved,
  });

  @override
  State<AddProductFormPage> createState() => _AddProductFormPageState();
}

class _AddProductFormPageState extends State<AddProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _qty1Controller = TextEditingController();
  final _qty2Controller = TextEditingController();
  final _qty3Controller = TextEditingController();

  ProductDetailModel? _scannedProduct;
  bool _isLoading = false;
  bool _isScanning = false;
  final _manualBarcodeController = TextEditingController();

  @override
  void dispose() {
    _qty1Controller.dispose();
    _qty2Controller.dispose();
    _qty3Controller.dispose();
    _manualBarcodeController.dispose();
    super.dispose();
  }

  Future<void> _scanProduct() async {
    setState(() {
      _isScanning = true;
    });

    final result = await Navigator.push<String?>(
      context,
      MaterialPageRoute(
        builder: (context) => QRScannerPage(
          cGudang: widget.selectedGudang,
          returnToCaller: true, // Set to true to return to this page
        ),
      ),
    );

    if (result != null && result.isNotEmpty) {
      await _fetchProductDetails(result);
    }

    setState(() {
      _isScanning = false;
    });
  }

  Future<void> _searchProductManually() async {
    final barcode = _manualBarcodeController.text.trim();
    if (barcode.isEmpty) {
      _showErrorSnackBar('Masukkan kode terlebih dahulu');
      return;
    }

    await _fetchProductDetails(barcode);
  }

  Future<void> _fetchProductDetails(String barcode) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final globalBranchProvider =
          Provider.of<GlobalBranchProvider>(context, listen: false);
      final branchId = globalBranchProvider.currentBranchId;

      final repo = ProductRepository(
        remoteDataSource: ProductRemoteDataSource(
          client: locator<Dio>(),
        ),
      );

      // Use the scanned barcode instead of hardcoded value
      print('[PRODUCT SCAN] Using scanned barcode: $barcode');
      print(
          '[PRODUCT SCAN] Branch ID: $branchId, Gudang: ${widget.selectedGudang}');

      final details = await repo.fetchProductDetail(
        cKode: null,
        branchId: branchId,
        cGudang: widget.selectedGudang,
        cKodebar: barcode, // Use the actual scanned barcode
      );

      if (details.isNotEmpty) {
        setState(() {
          _scannedProduct = details.first;
          _qty1Controller.text = details.first.qty1.toString();
          _qty2Controller.text = details.first.qty2.toString();
          _qty3Controller.text = details.first.qty3.toString();
        });
      } else {
        _showErrorSnackBar('Produk tidak ditemukan');
      }
    } catch (e) {
      _showErrorSnackBar('Gagal mengambil detail produk: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      if (_scannedProduct == null) {
        _showErrorSnackBar('Silakan pilih produk terlebih dahulu');
        return;
      }

      final qty1 = int.tryParse(_qty1Controller.text) ?? 0;
      final qty2 = int.tryParse(_qty2Controller.text) ?? 0;
      final qty3 = int.tryParse(_qty3Controller.text) ?? 0;

      // Create product with updated quantities
      final savedProduct = ProductDetailModel(
        cNama: _scannedProduct!.cNama,
        cKode: _scannedProduct!.cKode,
        cKodebar: _scannedProduct!.cKodebar,
        cSat1: _scannedProduct!.cSat1,
        cSat2: _scannedProduct!.cSat2,
        cSat3: _scannedProduct!.cSat3,
        nIsi: _scannedProduct!.nIsi,
        nIsi2: _scannedProduct!.nIsi2,
        qty1: qty1,
        qty2: qty2,
        qty3: qty3,
        cGudang: _scannedProduct!.cGudang,
        nSaldo: _scannedProduct!.nSaldo,
        image: _scannedProduct!.image,
      );

      // Return the saved product to the calling page
      widget.onProductSaved(savedProduct);
      Navigator.pop(context);
    }
  }

  void _resetForm() {
    setState(() {
      _scannedProduct = null;
      _qty1Controller.clear();
      _qty2Controller.clear();
      _qty3Controller.clear();
      _manualBarcodeController.clear();
    });
    _showSuccessSnackBar('Form berhasil direset');
  }

  void _clearForm() {
    setState(() {
      _scannedProduct = null;
      _qty1Controller.clear();
      _qty2Controller.clear();
      _qty3Controller.clear();
      _manualBarcodeController.clear();
    });
  }

  void _cancelAndReturn() {
    widget.onProductSaved(null);
    Navigator.pop(context);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(AppConstants.primaryRed),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF48BB78),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppConstants.lightGray),
      appBar: AppBar(
        title: const Text(
          'Tambah Produk',
          style: TextStyle(
            color: Color(AppConstants.darkGray),
            fontSize: AppConstants.fontSizeLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(AppConstants.darkGray),
        elevation: 0,
      ),
      body: _scannedProduct == null
          ? // Show product selection options when no product
          Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                children: [
                  // Simple Header

                  Text(
                    'Pilih cara untuk mencari produk',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      color:
                          const Color(AppConstants.darkGray).withOpacity(0.7),
                    ),
                  ),

                  // Scan Option
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(AppConstants.primaryRed),
                        child: _isScanning
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Icon(
                                Icons.qr_code_scanner,
                                color: Colors.white,
                                size: 24,
                              ),
                      ),
                      title: Text(
                        _isScanning ? 'Memindai...' : 'Scan Barcode',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text('Arahkan kamera ke barcode produk'),
                      trailing: _isScanning
                          ? null
                          : const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Color(AppConstants.darkGray),
                            ),
                      onTap: _isScanning ? null : _scanProduct,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),

                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
                        child: Text(
                          'ATAU',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeSmall,
                            fontWeight: FontWeight.w600,
                            color: const Color(AppConstants.darkGray).withOpacity(0.5),
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),

                  // Manual Input Option
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(AppConstants.primaryRed),
                                radius: 16,
                                child: Icon(
                                  Icons.keyboard_outlined,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              SizedBox(width: AppConstants.paddingSmall),
                              Text(
                                'Input Manual',
                                style: TextStyle(
                                  fontSize: AppConstants.fontSizeMedium,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppConstants.paddingMedium),
                          TextFormField(
                            controller: _manualBarcodeController,
                            decoration: const InputDecoration(
                              labelText: 'Masukkan Kode',
                              hintText: 'Contoh: 1234567890123',
                              prefixIcon: Icon(Icons.barcode_reader),
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingMedium),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed:
                                  _isLoading ? null : _searchProductManually,
                              icon: _isLoading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Icon(Icons.search, size: 18),
                              label: Text(
                                  _isLoading ? 'Mencari...' : 'Cari Produk'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : // Show product form when product is scanned
          Column(
              children: [
                // Form Section
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Product Form Section
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                  AppConstants.radiusLarge),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding:
                                const EdgeInsets.all(AppConstants.paddingLarge),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Reset Button (top right)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Detail Produk',
                                      style: TextStyle(
                                        fontSize: AppConstants.fontSizeLarge,
                                        fontWeight: FontWeight.w600,
                                        color: Color(AppConstants.darkGray),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: _resetForm,
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.white, size: 16),
                                      label: const Text(
                                        'Hapus',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: AppConstants.fontSizeSmall,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 219, 11, 11),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              AppConstants.paddingMedium,
                                          vertical: AppConstants.paddingSmall,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppConstants.radiusMedium),
                                        ),
                                        elevation: 2,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    height: AppConstants.paddingLarge),

                                // Product Identification Section
                                _buildProductInfoCard(),
                                const SizedBox(
                                    height: AppConstants.paddingLarge),

                                // Stock Program and Input Section
                                _buildStockAndInputSection(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Save Button
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top:
                          BorderSide(color: Color(AppConstants.gray), width: 1),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _saveProduct,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.save, color: Colors.white),
                      label: Text(
                        _isLoading ? 'Menyimpan...' : 'Simpan Produk',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppConstants.fontSizeMedium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF48BB78),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.paddingMedium,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusMedium),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildProductInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: const Color(AppConstants.lightGray),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: const Color(AppConstants.gray)),
      ),
      child: Column(
        children: [
          // Kode Field
          Row(
            children: [
              const Icon(
                Icons.qr_code_2_outlined,
                color: Color(AppConstants.darkGray),
                size: 20,
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kode',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: Color(AppConstants.darkGray),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _scannedProduct!.cKode,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        color: Color(AppConstants.darkGray),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          // Barang Field
          Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                color: Color(AppConstants.darkGray),
                size: 20,
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Barang',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: Color(AppConstants.darkGray),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _scannedProduct!.cNama,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        color: Color(AppConstants.darkGray),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStockAndInputSection() {
    return Column(
      children: [
        // Stock Program Overview Card
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFF8FAFC),
                Color(0xFFF1F5F9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            border: Border.all(color: const Color(AppConstants.gray)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  const Text(
                    'Stock Program (Existing)',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.darkGray),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildCompactStockOverview(),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.paddingLarge),

        // Input Section with Comparison
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            border: Border.all(color: const Color(AppConstants.gray)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  const Text(
                    'Input Stock Baru',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.darkGray),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildComparisonInputRows(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactStockOverview() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
        border: Border.all(color: const Color(AppConstants.gray)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Qty1
          Expanded(
            child: _buildStockItem(
              'Qty 1',
              _scannedProduct!.qty1.toString(),
              _scannedProduct!.cSat1,
              _scannedProduct!.nIsi,
              1,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: const Color(AppConstants.gray),
            margin: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingSmall),
          ),
          // Qty2
          Expanded(
            child: _buildStockItem(
              'Qty 2',
              _scannedProduct!.qty2.toString(),
              _scannedProduct!.cSat2,
              _scannedProduct!.nIsi2,
              2,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: const Color(AppConstants.gray),
            margin: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingSmall),
          ),
          // Qty3
          Expanded(
            child: _buildStockItem(
              'Qty 3',
              _scannedProduct!.qty3.toString(),
              _scannedProduct!.cSat3,
              null,
              3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockItem(
      String label, String value, String satuan, int? isi, int index) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(AppConstants.darkGray),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 10,
            color: Color(AppConstants.darkGray),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        const Divider(
          color: Color(AppConstants.gray),
          height: 1,
        ),
        const SizedBox(height: 4),
        Text(
          'Satuan $index: $satuan',
          style: TextStyle(
            fontSize: 8,
            color: const Color(AppConstants.darkGray).withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        if (isi != null) ...[
          const SizedBox(height: 2),
          Text(
            'Isi $index: $isi',
            style: TextStyle(
              fontSize: 8,
              color: const Color(AppConstants.darkGray).withOpacity(0.6),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildComparisonInputRows() {
    return Column(
      children: [
        // Input rows
        _buildModernInputRow(1, _qty1Controller, _scannedProduct!.cSat1,
            _scannedProduct!.nIsi, _scannedProduct!.qty1),
        const SizedBox(height: AppConstants.paddingSmall),
        _buildModernInputRow(2, _qty2Controller, _scannedProduct!.cSat2,
            _scannedProduct!.nIsi2, _scannedProduct!.qty2),
        const SizedBox(height: AppConstants.paddingSmall),
        _buildModernInputRow(3, _qty3Controller, _scannedProduct!.cSat3, null,
            _scannedProduct!.qty3),
      ],
    );
  }

  Widget _buildModernInputRow(int index, TextEditingController controller,
      String sat, int? isi, int currentValue) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: const Color(AppConstants.gray)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row dengan current value dan satuan info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  Text(
                    'Qty $index',
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.darkGray),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),

          // Input field dengan quick actions
          Row(
            children: [
              // Input field
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Masukkan qty baru',
                    prefixIcon: const Icon(
                      Icons.edit_outlined,
                      color: Color(0xFF10B981),
                      size: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMedium),
                      borderSide:
                          const BorderSide(color: Color(AppConstants.gray)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMedium),
                      borderSide:
                          const BorderSide(color: Color(AppConstants.gray)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMedium),
                      borderSide:
                          const BorderSide(color: Color(0xFF10B981), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingMedium,
                      vertical: AppConstants.paddingMedium,
                    ),
                    hintStyle: const TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      color: Color(AppConstants.gray),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFFAFAFA),
                  ),
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    color: Color(AppConstants.darkGray),
                    fontWeight: FontWeight.w600,
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final qty = int.tryParse(value);
                      if (qty == null || qty < 0) {
                        return 'Harus berupa angka positif';
                      }
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: AppConstants.paddingSmall),

              IconButton(
                onPressed: () => _copyCurrentValue(index, currentValue),
                icon: const Icon(Icons.reset_tv_outlined),
              ),
            ],
          ),

          // Info section (Qty, Sat, Isi)
          const SizedBox(height: AppConstants.paddingSmall),
          const Divider(
            color: Color(AppConstants.gray),
            height: 1,
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Qty info
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Ext Qty$index: ',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF9CA3AF),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: '$currentValue',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF1F2937),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Container(
                width: 3,
                height: 3,
                decoration: const BoxDecoration(
                  color: Color(0xFFD1D5DB),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              // Satuan info
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Sat$index: ',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF9CA3AF),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: sat,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF1F2937),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              if (isi != null) const SizedBox(width: AppConstants.paddingSmall),
              if (isi != null)
                Container(
                  width: 3,
                  height: 3,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD1D5DB),
                    shape: BoxShape.circle,
                  ),
                ),
              if (isi != null) const SizedBox(width: AppConstants.paddingSmall),
              // Isi info (if available)
              if (isi != null)
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Isi$index: ',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF9CA3AF),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: '$isi',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF1F2937),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: const Color(0xFF3B82F6).withOpacity(0.3),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingSmall,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        minimumSize: const Size(0, 40),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: AppConstants.fontSizeSmall,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _copyCurrentValues() {
    setState(() {
      _qty1Controller.text = _scannedProduct!.qty1.toString();
      _qty2Controller.text = _scannedProduct!.qty2.toString();
      _qty3Controller.text = _scannedProduct!.qty3.toString();
    });
    _showSuccessSnackBar('Current values copied to all fields');
  }

  void _clearAllInputs() {
    setState(() {
      _qty1Controller.clear();
      _qty2Controller.clear();
      _qty3Controller.clear();
    });
    _showSuccessSnackBar('All inputs cleared');
  }

  void _copyCurrentValue(int index, int currentValue) {
    setState(() {
      switch (index) {
        case 1:
          _qty1Controller.text = currentValue.toString();
          break;
        case 2:
          _qty2Controller.text = currentValue.toString();
          break;
        case 3:
          _qty3Controller.text = currentValue.toString();
          break;
      }
    });
    _showSuccessSnackBar('Current value copied to Qty $index');
  }

  void _clearInput(int index) {
    setState(() {
      switch (index) {
        case 1:
          _qty1Controller.clear();
          break;
        case 2:
          _qty2Controller.clear();
          break;
        case 3:
          _qty3Controller.clear();
          break;
      }
    });
    _showSuccessSnackBar('Qty $index cleared');
  }
}
