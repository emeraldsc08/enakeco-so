import 'package:enakeco_so/features/stock_opname/presentation/pages/list_laporan_so_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/global_branch_provider.dart';
import '../../data/models/barang_model.dart';
import '../../data/models/laporan_penjualan_model.dart';

class ListLaporanSOPage extends StatefulWidget {
  const ListLaporanSOPage({super.key});

  @override
  State<ListLaporanSOPage> createState() => _ListLaporanSOPageState();
}

class _ListLaporanSOPageState extends State<ListLaporanSOPage> {
  DateTime _selectedDate = DateTime.now();
  List<LaporanPenjualanModel> _laporanPenjualanList = [];

  @override
  void initState() {
    super.initState();
    _loadLaporanSOData();
  }

  void _loadLaporanSOData() {
    // Mock data - replace with actual API call
    setState(() {
      _laporanPenjualanList = [
        LaporanPenjualanModel(
          noJual: 'JL-250800001',
          listBarang: [
            BarangModel(
              barangId: 'BMGPA1',
              namaBarang: 'Gula Putih \'A',
              jumlahBarang: '1 KG',
              price: 7720,
              qty: -1,
            ),
            BarangModel(
              barangId: 'BMGPA2',
              namaBarang: 'Gula Putih \'A',
              jumlahBarang: '1 KG',
              price: 7720,
              qty: 2,
            ),
          ],
          subTotal: 7720,
        ),
        LaporanPenjualanModel(
          noJual: 'JL-250800002',
          listBarang: [
            BarangModel(
              barangId: 'BMGPA1',
              namaBarang: 'Gula Putih \'A',
              jumlahBarang: '1 KG',
              price: 7720,
              qty: -1,
            ),
          ],
          subTotal: 7720,
        ),
      ];
    });
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
      _loadLaporanSOData();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalBranchProvider>(
      builder: (context, globalBranchProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Laporan Penjualan Per No Jual'),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Color(AppConstants.lightGray),
                ],
              ),
            ),
            child: Column(
              children: [
                // Date Filter Section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color(AppConstants.primaryRed),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Tanggal:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A202C),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(AppConstants.primaryRed)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(AppConstants.primaryRed)
                                  .withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatDate(_selectedDate),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(AppConstants.primaryRed),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.edit_calendar,
                                color: Color(AppConstants.primaryRed),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // List Content
                Expanded(
                  child: _laporanPenjualanList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Tidak ada data laporan penjualan',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'untuk tanggal ${_formatDate(_selectedDate)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _laporanPenjualanList.length,
                          itemBuilder: (context, index) {
                            final item = _laporanPenjualanList[index];
                            return ListLaporanSOView(laporanPenjualan: item);
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Fitur tambah laporan penjualan akan segera tersedia'),
                  backgroundColor: Color(AppConstants.primaryRed),
                ),
              );
            },
            backgroundColor: const Color(AppConstants.primaryRed),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
