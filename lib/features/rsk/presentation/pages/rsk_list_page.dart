import 'package:dio/dio.dart';
import 'package:enakeco_so/core/di/injector.dart';
import 'package:enakeco_so/core/helpers/navigation_helper.dart';
import 'package:enakeco_so/core/models/branch_model.dart';
import 'package:enakeco_so/core/providers/global_branch_provider.dart';
import 'package:enakeco_so/core/widgets/branch_selector.dart';
import 'package:enakeco_so/features/rtl/data/datasources/product_remote_datasource.dart';
import 'package:enakeco_so/features/rtl/data/repositories/product_repository.dart';
import 'package:enakeco_so/features/rtl/presentation/pages/product_detail_page.dart';
import 'package:enakeco_so/features/shared/models/product_model.dart';
import 'package:enakeco_so/features/shared/providers/product_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main_menu/presentation/pages/home_page.dart';
import '../../../rtl/presentation/pages/qr_scanner_page.dart';

class RSKListPage extends StatelessWidget {
  const RSKListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalBranchProvider>(
      builder: (context, globalBranchProvider, child) {
        return ChangeNotifierProvider(
          create: (_) => ProductListProvider(
            repository: ProductRepository(
              remoteDataSource: ProductRemoteDataSource(
                client: locator<Dio>(),
              ),
            ),
          )
            ..setCGudang('RSK')
            ..setBranchId(globalBranchProvider.currentBranchId) // Use global branch ID
            ..fetchProducts(), // Auto search on page load
          child: const _RSKListView(),
        );
      },
    );
  }
}

class _RSKListView extends StatefulWidget {
  const _RSKListView();
  @override
  State<_RSKListView> createState() => _RSKListViewState();
}

class _RSKListViewState extends State<_RSKListView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isChangingBranch = false;

  void _doSearch() {
    final provider = Provider.of<ProductListProvider>(context, listen: false);
    provider.searchProducts(_searchController.text.trim());
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _resetSearch() {
    _searchController.clear();
    final provider = Provider.of<ProductListProvider>(context, listen: false);
    provider.searchProducts('');
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final globalBranchProvider = Provider.of<GlobalBranchProvider>(context, listen: false);
      final productProvider = Provider.of<ProductListProvider>(context, listen: false);
      productProvider.setBranchId(globalBranchProvider.currentBranchId);
      productProvider.fetchProducts(reset: true);
    });
  }

  void _onBranchSelected(BranchModel branch) async {
    setState(() {
      _isChangingBranch = true;
    });
    final productProvider = Provider.of<ProductListProvider>(context, listen: false);
    productProvider.setBranchId(branch.branchId);
    await productProvider.fetchProducts(reset: true);
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
    setState(() {
      _isChangingBranch = false;
    });
  }

  void _onScroll() {
    final provider = Provider.of<ProductListProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        provider.hasMore &&
        !provider.isLoading &&
        (provider.search == null || provider.search!.isEmpty)) {
      provider.fetchProducts();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductListProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk RSK'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
                      onPressed: () => toDetailandPushReplacement(
              context,
              page: const HomePage(),
            ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari nama barang atau kode',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: _resetSearch,
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                        ),
                        onSubmitted: (_) => _doSearch(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _doSearch,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: const Icon(Icons.search, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Branch Selector
                BranchSelector(
                  onBranchSelected: _onBranchSelected,
                  title: 'Pilih Cabang',
                  hintText: 'Cabang',
                ),
                const SizedBox(height: 24),
                if (provider.isLoading && provider.products.isEmpty)
                  const Expanded(child: Center(child: CircularProgressIndicator())),
                if (provider.error != null)
                  Expanded(
                    child: Center(
                      child: Text('Error: ${provider.error}',
                          style: const TextStyle(color: Colors.red)),
                    ),
                  ),
                if (!provider.isLoading &&
                    provider.products.isEmpty &&
                    provider.error == null)
                  const Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('Belum ada produk',
                              style: TextStyle(fontSize: 16, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                if (provider.products.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          provider.products.length + (provider.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == provider.products.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final product = provider.products[index];
                        return _ProductTile(product: product);
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        toDetail(
              context,
              page: const QRScannerPage(cGudang: 'RSK'),
            );
                      },
                      icon: const Icon(Icons.qr_code_scanner_outlined),
                      label: const Text('Scan Barcode'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Loading overlay when changing branch
          if (_isChangingBranch)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Card(
                  elevation: 8,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Mengubah cabang...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final ProductModel product;
  const _ProductTile({required this.product});

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  IconData _getGudangIcon(String cGudang) {
    switch (cGudang.toUpperCase()) {
      case 'GRS':
        return Icons.inbox_outlined;
      case 'RTL':
        return Icons.store_outlined;
      case 'RSK':
        return Icons.assignment_return_outlined;
      default:
        return Icons.warehouse_outlined;
    }
  }

  Color _getGudangColor(String cGudang) {
    return const Color(0xFF64748B); // Neutral gray for all gudang types
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalBranchProvider>(
      builder: (context, globalBranchProvider, child) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailPage(
                    cKode: product.cKode, // Kode produk dari list
                    // cKodebar tidak disediakan karena ini dari klik list, bukan scan
                    branchId: globalBranchProvider.currentBranchId,
                    cGudang: 'RSK',
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image (perkecil)
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: product.image != null
                          ? Image.network(
                              product.image!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported, size: 25, color: Colors.grey),
                            )
                          : const Icon(Icons.image_not_supported, size: 25, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Gudang info and product details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gudang info (atas)
                        Row(
                          children: [
                            Icon(
                              _getGudangIcon(product.cGudang),
                              size: 14,
                              color: _getGudangColor(product.cGudang),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              product.cGudang,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _getGudangColor(product.cGudang),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Nama Barang (tengah)
                        Text(
                          product.cNama,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A202C),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        // Kode (bawah)
                        Text(
                          product.cKode,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Date (kanan atas)
                  Text(
                    _formatDate(product.dTglBeli),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
