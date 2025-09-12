import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../shared/models/product_detail_model.dart';
import 'add_product_form_page.dart';

class CreateLaporanSO extends StatefulWidget {
  const CreateLaporanSO({super.key});

  @override
  State<CreateLaporanSO> createState() => _CreateLaporanSOState();
}

class _CreateLaporanSOState extends State<CreateLaporanSO> {
  final _formKey = GlobalKey<FormState>();
  final _keteranganController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _selectedGudang;
  final List<ProductDetailModel> _addedProducts = [];

  final List<String> _gudangOptions = ['GRS', 'RTL', 'RSK'];

  @override
  void dispose() {
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(AppConstants.primaryRed),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _handleTambahProduk() async {
    if (_selectedGudang == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih gudang terlebih dahulu'),
          backgroundColor: Color(AppConstants.primaryRed),
        ),
      );
      return;
    }

    final result = await Navigator.push<ProductDetailModel?>(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductFormPage(
          selectedGudang: _selectedGudang!,
          onProductSaved: (product) {
            if (product != null) {
              setState(() {
                _addedProducts.add(product);
              });
            }
          },
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _addedProducts.add(result);
      });
    }
  }

  void _handleSimpan() {
    if (_formKey.currentState!.validate()) {
      if (_selectedGudang == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih gudang terlebih dahulu'),
            backgroundColor: Color(AppConstants.primaryRed),
          ),
        );
        return;
      }

      // Prepare data for saving
      final laporanData = {
        'nomor': 'SO-${DateFormat('yyyyMMdd').format(DateTime.now())}-001',
        'tanggal': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'keterangan': _keteranganController.text.trim(),
        'gudang': _selectedGudang,
        'produk': _addedProducts
            .map((product) => {
                  'kode': product.cKode,
                  'nama': product.cNama,
                  'barcode': product.cKodebar,
                  'kuantitas': product.qty1,
                  'satuan': product.cSat1,
                  'gudang': product.cGudang,
                })
            .toList(),
      };

      print('Laporan SO Data: $laporanData');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Data berhasil disimpan dengan ${_addedProducts.length} produk'),
          backgroundColor: const Color(0xFF48BB78),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppConstants.lightGray),
      appBar: AppBar(
        title: const Text('Buat Laporan SO'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Form Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nomor Field (Read-only)
                    _buildFormField(
                      label: 'Nomor',
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingMedium,
                          vertical: AppConstants.paddingMedium,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(AppConstants.lightGray),
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusMedium),
                          border: Border.all(
                            color: const Color(AppConstants.gray),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.tag_outlined,
                              color: Color(AppConstants.darkGray),
                              size: 20,
                            ),
                            const SizedBox(width: AppConstants.paddingSmall),
                            Text(
                              'SO-${DateFormat('yyyyMMdd').format(DateTime.now())}-001',
                              style: const TextStyle(
                                fontSize: AppConstants.fontSizeMedium,
                                color: Color(AppConstants.darkGray),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppConstants.paddingLarge),

                    // Tanggal Field
                    _buildFormField(
                      label: 'Tanggal',
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingMedium,
                            vertical: AppConstants.paddingMedium,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(AppConstants.gray),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusMedium),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: Color(AppConstants.darkGray),
                                size: 20,
                              ),
                              const SizedBox(width: AppConstants.paddingSmall),
                              Text(
                                DateFormat('dd/MM/yyyy').format(_selectedDate),
                                style: const TextStyle(
                                  fontSize: AppConstants.fontSizeMedium,
                                  color: Color(AppConstants.darkGray),
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: Color(AppConstants.darkGray),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppConstants.paddingLarge),

                    // Keterangan Field
                    _buildFormField(
                      label: 'Keterangan',
                      child: TextFormField(
                        controller: _keteranganController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Masukkan keterangan laporan...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusMedium),
                            borderSide: const BorderSide(
                                color: Color(AppConstants.gray)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusMedium),
                            borderSide: const BorderSide(
                                color: Color(AppConstants.gray)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusMedium),
                            borderSide: const BorderSide(
                                color: Color(AppConstants.primaryRed)),
                          ),
                          contentPadding:
                              const EdgeInsets.all(AppConstants.paddingMedium),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Keterangan tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: AppConstants.paddingLarge),

                    // Gudang Field
                    _buildFormField(
                      label: 'Gudang',
                      child: DropdownButtonFormField<String>(
                        value: _selectedGudang,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusMedium),
                            borderSide: const BorderSide(
                                color: Color(AppConstants.gray)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusMedium),
                            borderSide: const BorderSide(
                                color: Color(AppConstants.gray)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusMedium),
                            borderSide: const BorderSide(
                                color: Color(AppConstants.primaryRed)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingMedium,
                            vertical: AppConstants.paddingMedium,
                          ),
                        ),
                        hint: const Text(
                          'Pilih gudang',
                          style: TextStyle(
                            color: Color(AppConstants.darkGray),
                            fontSize: AppConstants.fontSizeMedium,
                          ),
                        ),
                        items: _gudangOptions.map((String gudang) {
                          return DropdownMenuItem<String>(
                            value: gudang,
                            child: Text(
                              gudang,
                              style: const TextStyle(
                                fontSize: AppConstants.fontSizeMedium,
                                color: Color(AppConstants.darkGray),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGudang = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pilih gudang terlebih dahulu';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Added Products Section
              if (_addedProducts.isNotEmpty) ...[
                const SizedBox(height: AppConstants.paddingLarge),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusLarge),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Produk Ditambahkan',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeLarge,
                              fontWeight: FontWeight.w600,
                              color: Color(AppConstants.darkGray),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.paddingSmall,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(AppConstants.primaryRed),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_addedProducts.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: AppConstants.fontSizeSmall,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      ...(_addedProducts.asMap().entries.map((entry) {
                        final index = entry.key;
                        final product = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(
                              bottom: AppConstants.paddingMedium),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusLarge),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: Border.all(
                              color: const Color(AppConstants.primaryRed)
                                  .withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header with product number, name and delete button
                              Container(
                                padding: const EdgeInsets.all(
                                    AppConstants.paddingMedium),
                                decoration: BoxDecoration(
                                  color: const Color(AppConstants.primaryRed)
                                      .withOpacity(0.05),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(
                                        AppConstants.radiusLarge),
                                    topRight: Radius.circular(
                                        AppConstants.radiusLarge),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Product number badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppConstants.paddingSmall,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                            AppConstants.primaryRed),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: AppConstants.fontSizeSmall,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                        width: AppConstants.paddingSmall),

                                    // Product name
                                    Expanded(
                                      child: Text(
                                        product.cNama,
                                        style: const TextStyle(
                                          fontSize: AppConstants.fontSizeLarge,
                                          fontWeight: FontWeight.w600,
                                          color: Color(AppConstants.darkGray),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    // Delete button
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _addedProducts.remove(product);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Color(AppConstants.primaryRed),
                                          size: 20,
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 40,
                                          minHeight: 40,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Product details - balanced layout
                              Padding(
                                padding: const EdgeInsets.all(
                                    AppConstants.paddingMedium),
                                child: Column(
                                  children: [
                                    // Section 1: Kode
                                    _buildBalancedSection(
                                      title: 'Kode',
                                      icon: Icons.qr_code,
                                      color: const Color(0xFF4299E1),
                                      children: [
                                        _buildInfoRow(Icons.qr_code,
                                            'Kode Produk', product.cKode),
                                        _buildInfoRow(Icons.barcode_reader,
                                            'Barcode', product.cKodebar),
                                      ],
                                    ),

                                    const SizedBox(
                                        height: AppConstants.paddingSmall),

                                    // Section 2: Barang
                                    _buildBalancedSection(
                                      title: 'Barang',
                                      icon: Icons.inventory_2,
                                      color: const Color(0xFF9F7AEA),
                                      children: [
                                        _buildInfoRow(Icons.warehouse, 'Saldo',
                                            '${product.nSaldo}'),
                                        _buildInfoRow(Icons.store, 'Gudang',
                                            product.cGudang),
                                      ],
                                    ),

                                    const SizedBox(
                                        height: AppConstants.paddingSmall),

                                    // Section 3: Jumlah Input
                                    _buildBalancedSection(
                                      title: 'Jumlah Input',
                                      icon: Icons.calculate,
                                      color: const Color(0xFFED8936),
                                      children: [
                                        _buildInfoRow(Icons.inventory_2,
                                            'Qty 1', '${product.qty1}'),
                                        const SizedBox(
                                            height: AppConstants.paddingSmall),
                                        _buildInfoRow(Icons.straighten, 'Sat 1',
                                            product.cSat1),
                                        const SizedBox(
                                            height: AppConstants.paddingSmall),
                                        _buildInfoRow(Icons.transform, 'Isi 1',
                                            '${product.nIsi}'),
                                        const SizedBox(
                                            height: AppConstants.paddingSmall),
                                        _buildInfoRow(Icons.inventory_2,
                                            'Qty 2', '${product.qty2}'),
                                        const SizedBox(
                                            height: AppConstants.paddingSmall),
                                        _buildInfoRow(Icons.straighten, 'Sat 2',
                                            product.cSat2),
                                        const SizedBox(
                                            height: AppConstants.paddingSmall),
                                        _buildInfoRow(Icons.transform, 'Isi 2',
                                            '${product.nIsi2}'),
                                        const SizedBox(
                                            height: AppConstants.paddingSmall),
                                        _buildInfoRow(Icons.inventory_2,
                                            'Qty 3', '${product.qty3}'),
                                        const SizedBox(
                                            height: AppConstants.paddingSmall),
                                        _buildInfoRow(Icons.straighten, 'Sat 3',
                                            product.cSat3),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList()),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: AppConstants.paddingXLarge),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _handleTambahProduk,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Tambah Produk',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppConstants.fontSizeMedium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4299E1),
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

                  const SizedBox(width: AppConstants.paddingMedium),

                  // Simpan Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _handleSimpan,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'Simpan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppConstants.fontSizeMedium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(AppConstants.primaryRed),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeMedium,
            fontWeight: FontWeight.w600,
            color: Color(AppConstants.darkGray),
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        child,
      ],
    );
  }

  Widget _buildBalancedSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header with icon
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingSmall,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.radiusMedium),
                topRight: Radius.circular(AppConstants.radiusMedium),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),

          // Section content
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingSmall,
        vertical: AppConstants.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: const Color(AppConstants.lightGray).withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
        border: Border.all(
          color: const Color(AppConstants.gray).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: const Color(AppConstants.darkGray),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: Color(AppConstants.darkGray),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: Color(AppConstants.primaryRed),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
