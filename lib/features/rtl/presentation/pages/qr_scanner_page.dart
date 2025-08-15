import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/global_branch_provider.dart';
import '../../../../core/styles/app_styles.dart';
import 'product_detail_page.dart';

class QRScannerPage extends StatefulWidget {
  final String cGudang; // Parameter untuk menentukan dari menu mana (RTL, GRS, RSK)

  const QRScannerPage({
    super.key,
    required this.cGudang,
  });

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  MobileScannerController? controller;
  bool _isCameraPermissionGranted = false;
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _isCameraPermissionGranted = status.isGranted;
    });
  }

  void _handleDummyScan() {
    // Dummy QR code for emulator testing
    const dummyQRCode = 'ENAKECO-ITM-2024-001';
    _handleQRResult(dummyQRCode);
  }

  void _handleQRResult(String qrCode) {
    // Get current branch ID from GlobalBranchProvider
    final globalBranchProvider = Provider.of<GlobalBranchProvider>(context, listen: false);
    final branchId = globalBranchProvider.currentBranchId;

    // Navigate directly to ProductDetailPage and replace the scanner page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          cKode: null, // Null karena dari scan barcode
          cKodebar: qrCode, // Value dari hasil scan barcode
          branchId: branchId,
          cGudang: widget.cGudang,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraPermissionGranted) {
      return Scaffold(
        backgroundColor: const Color(AppConstants.lightGray),
        appBar: AppBar(
          title: const Text('QR Scanner'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.camera_alt_outlined,
                size: 80,
                color: Color(AppConstants.primaryRed),
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              Text(
                'Camera Permission Required',
                style: AppStyles.headingStyle.copyWith(
                  fontSize: AppConstants.fontSizeLarge,
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Text(
                'Please grant camera permission to scan QR codes',
                style: AppStyles.bodyStyle.copyWith(
                  color: const Color(AppConstants.darkGray),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              ElevatedButton(
                onPressed: _requestCameraPermission,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(AppConstants.primaryRed),
                  foregroundColor: const Color(AppConstants.white),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingLarge,
                    vertical: AppConstants.paddingMedium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                ),
                child: const Text('Grant Permission'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Scan QR Code - ${widget.cGudang}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () async {
              await controller?.toggleTorch();
            },
          ),
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: _handleDummyScan,
            tooltip: 'Dummy Scan (for emulator)',
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller ??= MobileScannerController(),
            onDetect: (capture) {
              if (_isScanning) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    _isScanning = false;
                    _handleQRResult(barcode.rawValue!);
                    break;
                  }
                }
              }
            },
          ),
          // Custom overlay
          CustomPaint(
            painter: ScannerOverlay(),
            child: const SizedBox.expand(),
          ),
          Positioned(
            bottom: AppConstants.paddingLarge,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingLarge,
                    vertical: AppConstants.paddingMedium,
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingLarge,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Position QR code within the frame',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppConstants.fontSizeMedium,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Scanning for: ${widget.cGudang}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: AppConstants.fontSizeSmall,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Or tap QR button for dummy scan (emulator)',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: AppConstants.fontSizeSmall,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await controller?.switchCamera();
                      },
                      icon: const Icon(
                        Icons.flip_camera_ios,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    GestureDetector(
                      onTap: _handleDummyScan,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(AppConstants.primaryRed),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isScanning = true;
                        });
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final scanArea = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 250,
      height: 250,
    );

    // Draw background overlay
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(RRect.fromRectAndRadius(scanArea, const Radius.circular(10))),
      ),
      paint,
    );

    // Draw corner borders
    final borderPaint = Paint()
      ..color = const Color(AppConstants.primaryRed)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    const cornerLength = 30.0;
    const cornerRadius = 10.0;

    // Top left corner
    canvas.drawPath(
      Path()
        ..moveTo(scanArea.left, scanArea.top + cornerLength)
        ..lineTo(scanArea.left, scanArea.top)
        ..lineTo(scanArea.left + cornerLength, scanArea.top),
      borderPaint,
    );

    // Top right corner
    canvas.drawPath(
      Path()
        ..moveTo(scanArea.right - cornerLength, scanArea.top)
        ..lineTo(scanArea.right, scanArea.top)
        ..lineTo(scanArea.right, scanArea.top + cornerLength),
      borderPaint,
    );

    // Bottom left corner
    canvas.drawPath(
      Path()
        ..moveTo(scanArea.left, scanArea.bottom - cornerLength)
        ..lineTo(scanArea.left, scanArea.bottom)
        ..lineTo(scanArea.left + cornerLength, scanArea.bottom),
      borderPaint,
    );

    // Bottom right corner
    canvas.drawPath(
      Path()
        ..moveTo(scanArea.right - cornerLength, scanArea.bottom)
        ..lineTo(scanArea.right, scanArea.bottom)
        ..lineTo(scanArea.right, scanArea.bottom - cornerLength),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}