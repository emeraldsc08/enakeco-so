import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/helpers/navigation_helper.dart';
import 'qr_scanner_page.dart';
import 'rtl_page.dart';

class ProductInformationPage extends StatelessWidget {
  final String qrCode;

  const ProductInformationPage({super.key, required this.qrCode});

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
          onPressed: () => toDetailandPushReplacement(
            context,
            page: const RTLPage(),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Basic Information Container
            _buildSectionHeader('Informasi Dasar'),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: const Color(AppConstants.white),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    title: 'Nomor',
                    value: qrCode,
                  ),
                  _buildDivider(),
                  _buildInfoRow(
                    title: 'Tanggal',
                    value: DateTime.now().toString().substring(0, 10),
                  ),
                  _buildDivider(),
                  _buildInfoRow(
                    title: 'Keterangan',
                    value: 'Produk Sample untuk Testing',
                  ),
                  _buildDivider(),
                  _buildInfoRow(
                    title: 'Gudang',
                    value: 'Gudang Utama',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Section 2: Product Details
            _buildSectionHeader('Detail Produk'),
            const SizedBox(height: 16),

            // Product Details with alternating colors
            _buildInfoCard(
              title: 'No',
              value: '001',
              icon: Icons.tag_outlined,
              color: const Color(0xFF9F7AEA),
              isAlternate: false,
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: 'Kode',
              value: 'KOD-${qrCode.substring(0, 4)}',
              icon: Icons.qr_code_2_outlined,
              color: const Color(0xFF4299E1),
              isAlternate: true,
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: 'Barang',
              value: 'Sample Product XYZ',
              icon: Icons.inventory_2_outlined,
              color: const Color(AppConstants.primaryRed),
              isAlternate: false,
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: 'Qty1',
              value: '100',
              icon: Icons.analytics_outlined,
              color: const Color(0xFF48BB78),
              isAlternate: true,
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: 'Sat1',
              value: 'PCS',
              icon: Icons.straighten_outlined,
              color: const Color(0xFFED8936),
              isAlternate: false,
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: 'Isi1',
              value: '1',
              icon: Icons.format_list_numbered_outlined,
              color: const Color(0xFF9F7AEA),
              isAlternate: true,
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: 'Qty2',
              value: '10',
              icon: Icons.analytics_outlined,
              color: const Color(0xFF48BB78),
              isAlternate: false,
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: 'Sat2',
              value: 'BOX',
              icon: Icons.inventory_outlined,
              color: const Color(0xFFED8936),
              isAlternate: true,
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: 'Isi2',
              value: '10',
              icon: Icons.format_list_numbered_outlined,
              color: const Color(0xFF9F7AEA),
              isAlternate: false,
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: 'Qty3',
              value: '5',
              icon: Icons.analytics_outlined,
              color: const Color(0xFF48BB78),
              isAlternate: true,
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: 'Sat3',
              value: 'CARTON',
              icon: Icons.inventory_outlined,
              color: const Color(0xFFED8936),
              isAlternate: false,
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: 'Isi3',
              value: '2',
              icon: Icons.format_list_numbered_outlined,
              color: const Color(0xFF9F7AEA),
              isAlternate: true,
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: 'Rak',
              value: 'A-01-B-03',
              icon: Icons.grid_view_outlined,
              color: const Color(0xFF4299E1),
              isAlternate: false,
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(AppConstants.primaryRed),
                        Color(0xFFDC2626)
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(AppConstants.primaryRed)
                            .withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text('Informasi produk berhasil disimpan'),
                            ],
                          ),
                          backgroundColor: const Color(AppConstants.primaryRed),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save_outlined,
                            size: 18, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Simpan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(AppConstants.white),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          const Color(AppConstants.primaryRed).withOpacity(0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => toDetail(
                      context,
                      page: const QRScannerPage(cGudang: 'RTL'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_scanner_outlined,
                            size: 18, color: Color(AppConstants.primaryRed)),
                        SizedBox(width: 8),
                        Text(
                          'Lanjutkan Scan QR Code',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(AppConstants.primaryRed),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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

  Widget _buildInfoRow({
    required String title,
    required String value,
  }) {
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

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isAlternate,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: isAlternate
            ? const Color(0xFFF8FAFC)
            : const Color(AppConstants.white),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isAlternate ? const Color(0xFFE2E8F0) : const Color(0xFFF1F5F9),
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
}
