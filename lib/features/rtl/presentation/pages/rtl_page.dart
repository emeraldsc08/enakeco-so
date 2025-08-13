import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/styles/app_styles.dart';
import 'qr_scanner_page.dart';

class RTLPage extends StatefulWidget {
  const RTLPage({super.key});

  @override
  State<RTLPage> createState() => _RTLPageState();
}

class _RTLPageState extends State<RTLPage> {
  @override
  void initState() {
    super.initState();
    // Show bottom sheet after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showMenuBottomSheet();
    });
  }

  void _showMenuBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const RTLMenuBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppConstants.lightGray),
      appBar: AppBar(
        title: const Text('RTL (Toko)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: _showMenuBottomSheet,
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.store_outlined,
              size: 80,
              color: Color(0xFF4299E1),
            ),
            SizedBox(height: 16),
            Text(
              'RTL (Toko)',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tap menu button to open options',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RTLMenuBottomSheet extends StatelessWidget {
  const RTLMenuBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(AppConstants.white),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConstants.radiusXLarge),
          topRight: Radius.circular(AppConstants.radiusXLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: AppConstants.paddingMedium),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(AppConstants.lightGray),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: AppConstants.paddingLarge),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingLarge,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4299E1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                  child: const Icon(
                    Icons.store_outlined,
                    color: Color(0xFF4299E1),
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RTL (Toko) Menu',
                        style: AppStyles.headingStyle.copyWith(
                          fontSize: AppConstants.fontSizeLarge,
                        ),
                      ),
                      Text(
                        'Choose your operation',
                        style: AppStyles.captionStyle.copyWith(
                          color: const Color(AppConstants.darkGray),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppConstants.paddingLarge),

          // Menu Items
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingLarge,
            ),
            child: Column(
              children: [
                _buildMenuTile(
                  context,
                  icon: Icons.inventory_2_outlined,
                  title: 'Stock Opname',
                  subtitle: 'Manage inventory count',
                  color: const Color(AppConstants.primaryRed),
                  onTap: () {
                    Navigator.pop(context);
                    _showComingSoonSnackBar(context, 'Stock Opname');
                  },
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                _buildMenuTile(
                  context,
                  icon: Icons.analytics_outlined,
                  title: 'Cek Kuantitas Barang',
                  subtitle: 'Check item quantities',
                  color: const Color(0xFF48BB78),
                  onTap: () {
                    Navigator.pop(context);
                    _showComingSoonSnackBar(context, 'Cek Kuantitas Barang');
                  },
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                _buildMenuTile(
                  context,
                  icon: Icons.qr_code_scanner_outlined,
                  title: 'Scan QR',
                  subtitle: 'Scan QR codes for items',
                  color: const Color(0xFFED8936),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QRScannerPage(cGudang: 'RTL'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: AppConstants.paddingLarge),

          // Close button
          Padding(
            padding: const EdgeInsets.only(
              left: AppConstants.paddingLarge,
              right: AppConstants.paddingLarge,
              bottom: AppConstants.paddingLarge,
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(AppConstants.lightGray),
                  foregroundColor: const Color(AppConstants.darkGray),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.paddingMedium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(AppConstants.white),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(
          color: const Color(AppConstants.lightGray),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppStyles.subheadingStyle.copyWith(
                          fontSize: AppConstants.fontSizeMedium,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppStyles.captionStyle.copyWith(
                          color: const Color(AppConstants.darkGray),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(AppConstants.darkGray),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoonSnackBar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon'),
        backgroundColor: const Color(AppConstants.primaryRed),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
      ),
    );
  }
}