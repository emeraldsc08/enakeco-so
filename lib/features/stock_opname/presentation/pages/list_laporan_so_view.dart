import 'package:enakeco_so/features/stock_opname/data/models/laporan_penjualan_model.dart';
import 'package:flutter/material.dart';

class ListLaporanSOView extends StatelessWidget {
  final LaporanPenjualanModel laporanPenjualan;
  const ListLaporanSOView({super.key, required this.laporanPenjualan});

  @override
  Widget build(BuildContext context) {
    String formatCurrency(int amount) {
      return amount.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with transaction number
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              laporanPenjualan.noJual,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A202C),
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Expandable items list
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              childrenPadding: EdgeInsets.zero,
              title: Text(
                '${laporanPenjualan.listBarang.length} item',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4A5568),
                ),
              ),
              children: [
                // Items list
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: laporanPenjualan.listBarang.map((barang) {
                      final itemTotal = barang.qty * barang.price;
                      final isNegative = barang.qty < 0;

                      return Column(
                        children: [
                          // Item details
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  barang.barangId,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF4A5568),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  '${barang.namaBarang} ${barang.jumlahBarang}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF4A5568),
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          // Quantity, price, and total
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${barang.qty} x ${formatCurrency(barang.price)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isNegative
                                        ? Colors.red
                                        : const Color(0xFF4A5568),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(
                                '${isNegative ? '- ' : ''}${formatCurrency(itemTotal.abs())}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isNegative
                                      ? Colors.red
                                      : const Color(0xFF4A5568),
                                ),
                              ),
                            ],
                          ),

                          // Divider (except for last item)
                          if (barang != laporanPenjualan.listBarang.last)
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              height: 1,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFFD1D5DB),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Sub total section (always visible)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'Sub Total',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A202C),
                  ),
                ),
                const Spacer(),
                Text(
                  formatCurrency(laporanPenjualan.subTotal),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A202C),
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
