import 'package:dio/dio.dart';
import 'package:enakeco_so/features/rtl/data/datasources/product_remote_datasource.dart';
import 'package:enakeco_so/features/rtl/data/repositories/product_repository.dart';
import 'package:enakeco_so/features/rtl/presentation/pages/qr_scanner_page.dart';
import 'package:enakeco_so/features/shared/models/product_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/global_branch_provider.dart';

class ProductDetailPage extends StatefulWidget {
  final String cKode;
  final int branchId;
  final String cGudang;
  final bool showSaveButton; // Parameter untuk mengontrol tampilan tombol Simpan

  const ProductDetailPage({
    super.key,
    required this.cKode,
    required this.branchId,
    required this.cGudang,
    this.showSaveButton = false, // Default false, hanya true saat dari scan
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<List<ProductDetailModel>> _futureDetail;
  int _currentIndex = 0;
  List<ProductDetailModel> _details = [];

  @override
  void initState() {
    super.initState();
    final repo = ProductRepository(
      remoteDataSource: ProductRemoteDataSource(
        client: Dio(BaseOptions(baseUrl: 'https://dev.swalayanenakeco.com')),
      ),
    );
    _futureDetail = repo.fetchProductDetail(
      cKode: widget.cKode,
      branchId: widget.branchId,
      cGudang: widget.cGudang,
    );
  }

  void _showSaveFeatureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.orange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Fitur Simpan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fitur simpan data produk belum tersedia saat ini.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4A5568),
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Endpoint API untuk menyimpan data produk masih dalam pengembangan.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF718096),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Fitur ini akan segera hadir dalam update mendatang.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF718096),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Tutup',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A5568),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(AppConstants.white),
        title: const Text(
          'Informasi Produk',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A202C),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<ProductDetailModel>>(
        future: _futureDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}', style: const TextStyle(color: Colors.red)));
          }
          final details = snapshot.data ?? [];
          if (details.isEmpty) {
            return const Center(child: Text('Detail produk tidak ditemukan.'));
          }
          // Simpan ke state agar bisa navigasi antar item
          _details = details;
          final detail = _details[_currentIndex];
          return Stack(
            children: [
              Column(
                children: [
                  if (detail.image != null && detail.image!.isNotEmpty)
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: 220,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                        child: Image.network(
                          detail.image!,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: double.infinity,
                            height: 220,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_details.length > 1)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.chevron_left),
                                  onPressed: _currentIndex > 0
                                      ? () => setState(() => _currentIndex--)
                                      : null,
                                ),
                                Text(
                                  'Detail ${_currentIndex + 1} dari ${_details.length}',
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed: _currentIndex < _details.length - 1
                                      ? () => setState(() => _currentIndex++)
                                      : null,
                                ),
                              ],
                            ),
                          if (_details.length > 1) const SizedBox(height: 12),

                          // Card informasi lokasi (Gudang & Cabang)
                          Consumer<GlobalBranchProvider>(
                            builder: (context, globalBranchProvider, child) {
                              return Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildSectionHeader('Informasi Lokasi'),
                                      const SizedBox(height: 16),
                                      _buildLocationInfo(
                                        icon: Icons.store,
                                        title: 'Cabang',
                                        value: globalBranchProvider.currentBranchName,
                                        color: const Color(AppConstants.primaryRed),
                                      ),
                                      const SizedBox(height: 12),
                                      _buildLocationInfo(
                                        icon: Icons.warehouse,
                                        title: 'Gudang',
                                        value: widget.cGudang,
                                        color: const Color(0xFF48BB78),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          // Card utama info produk
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionHeader('Informasi Produk'),
                                  const SizedBox(height: 16),
                                  _buildInfoRow(title: 'Nama', value: detail.cNama),
                                  _buildDivider(),
                                  _buildInfoRow(title: 'Kode', value: detail.cKode),
                                  _buildDivider(),
                                  _buildInfoRow(title: 'Barcode', value: detail.cKodebar),
                                  _buildDivider(),
                                  _buildInfoRow(title: 'Gudang', value: detail.cGudang),
                                  _buildDivider(),
                                  _buildInfoRow(title: 'Saldo', value: detail.nSaldo.toString()),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionHeader('Satuan & Kuantitas'),
                                  const SizedBox(height: 16),
                                  _buildInfoCard(title: 'Satuan 1', value: detail.cSat1, isAlternate: false),
                                  const SizedBox(height: 8),
                                  _buildInfoCard(title: 'Qty 1', value: detail.qty1.toString(), isAlternate: true),
                                  const SizedBox(height: 8),
                                  _buildInfoCard(title: 'Isi 1', value: detail.nIsi.toString(), isAlternate: false),
                                  const SizedBox(height: 8),
                                  _buildInfoCard(title: 'Satuan 2', value: detail.cSat2, isAlternate: true),
                                  const SizedBox(height: 8),
                                  _buildInfoCard(title: 'Qty 2', value: detail.qty2.toString(), isAlternate: false),
                                  const SizedBox(height: 8),
                                  _buildInfoCard(title: 'Isi 2', value: detail.nIsi2.toString(), isAlternate: true),
                                  const SizedBox(height: 8),
                                  _buildInfoCard(title: 'Satuan 3', value: detail.cSat3, isAlternate: false),
                                  const SizedBox(height: 8),
                                  _buildInfoCard(title: 'Qty 3', value: detail.qty3.toString(), isAlternate: true),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Floating button
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: widget.showSaveButton
                        ? Row(
                            children: [
                              // Tombol Simpan
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _showSaveFeatureDialog();
                                  },
                                  icon: const Icon(Icons.save_outlined),
                                  label: const Text('Simpan'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 8,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Tombol Lanjutkan Scan Barcode
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final result = await Navigator.push<String?>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => QRScannerPage(cGudang: widget.cGudang),
                                      ),
                                    );
                                    if (result != null && result.isNotEmpty) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ProductDetailPage(
                                            cKode: result,
                                            branchId: widget.branchId,
                                            cGudang: widget.cGudang,
                                            showSaveButton: true, // Set true untuk scan berikutnya
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.qr_code_scanner_outlined),
                                  label: const Text('Scan Lagi'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(AppConstants.primaryRed),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 8,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final result = await Navigator.push<String?>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => QRScannerPage(cGudang: widget.cGudang),
                                  ),
                                );
                                if (result != null && result.isNotEmpty) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailPage(
                                        cKode: result,
                                        branchId: widget.branchId,
                                        cGudang: widget.cGudang,
                                        showSaveButton: true, // Set true untuk scan berikutnya
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.qr_code_scanner_outlined),
                              label: const Text('Scan Barcode'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(AppConstants.primaryRed),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 8,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A202C),
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildInfoRow({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A202C),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: const Color(0xFFF1F5F9),
    );
  }

  Widget _buildInfoCard({required String title, required String value, required bool isAlternate}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: isAlternate ? const Color(0xFFF8FAFC) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAlternate ? const Color(0xFFE2E8F0) : const Color(0xFFF1F5F9),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A202C),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}