import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/helpers/navigation_helper.dart';
import '../../../../core/models/branch_model.dart';
import '../../../../core/providers/global_branch_provider.dart';
import '../../../../core/widgets/branch_selector.dart';
import '../../../main_menu/presentation/pages/home_page.dart';

class StockOpnameListPage extends StatefulWidget {
  const StockOpnameListPage({super.key});

  @override
  State<StockOpnameListPage> createState() => _StockOpnameListPageState();
}

class _StockOpnameListPageState extends State<StockOpnameListPage> {
  @override
  void initState() {
    super.initState();
    // Auto search for stock opname data based on global branch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final globalBranchProvider = Provider.of<GlobalBranchProvider>(context, listen: false);
      _fetchStockOpnameData(globalBranchProvider.currentBranchId);
    });
  }

  void _fetchStockOpnameData(int branchId) {
    // Here you can implement API call to fetch stock opname data
    // based on branchId
    print('Fetching stock opname data for branch ID: $branchId');
  }

  void _onBranchSelected(BranchModel branch) {
    // Auto search with new branch ID
    _fetchStockOpnameData(branch.branchId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalBranchProvider>(
      builder: (context, globalBranchProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Stock Opname'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => toDetailandPushReplacement(
                context,
                page: const HomePage(),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Branch Selector
                BranchSelector(
                  onBranchSelected: _onBranchSelected,
                  title: 'Pilih Cabang',
                  hintText: 'Cabang',
                ),
                const SizedBox(height: 24),
                // Content placeholder
                Expanded(
                  child: Center(
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
                          'Stock Opname untuk ${globalBranchProvider.currentBranchName}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Belum ada data stock opname',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Branch ID: ${globalBranchProvider.currentBranchId}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Create new stock opname button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to create stock opname page
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Buat Stock Opname Baru'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}