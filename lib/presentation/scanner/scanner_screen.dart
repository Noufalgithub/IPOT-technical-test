import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../core/theme/app_theme.dart';
import '../../router.dart';
import 'package:ipot_technical_test/l10n/app_localizations.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver {
  MobileScannerController? _controller;
  bool _isScanned = false;
  bool _useManualInput = false;
  final _manualController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initScanner();
  }

  void _initScanner() {
    try {
      _controller = MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
        returnImage: false,
      );
    } catch (e) {
      setState(() => _useManualInput = true);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null) return;
    switch (state) {
      case AppLifecycleState.resumed:
        _controller!.start();
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _controller!.stop();
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _manualController.dispose();
    super.dispose();
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    if (_isScanned) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    _processQRValue(barcode!.rawValue!);
  }

  void _processQRValue(String value) {
    if (_isScanned) return;

    String? tableId;

    // Try parsing different QR formats
    // Format 1: ipot://table/T001
    if (value.startsWith('ipot://table/')) {
      tableId = value.split('/').last;
    }
    // Format 2: https://ipot.app/scan?table_id=T001
    else if (value.contains('table_id=')) {
      final uri = Uri.tryParse(value);
      tableId = uri?.queryParameters['table_id'];
    }
    // Format 3: https://ipot.app/table/T001
    else if (value.contains('/table/')) {
      tableId = value.split('/table/').last.split('?').first;
    }
    // Format 4: Direct table ID (e.g., T001 or just a number)
    else if (RegExp(r'^[A-Za-z]?\d+$').hasMatch(value)) {
      tableId = value;
    }

    if (tableId != null && tableId.isNotEmpty) {
      setState(() => _isScanned = true);
      _controller?.stop();
      _navigateToMenu(tableId);
    } else {
      _showErrorSnackbar(AppLocalizations.of(context)!.invalidQrCode);
    }
  }

  void _navigateToMenu(String tableId) {
    context.push('${AppRouter.menu}?tableId=$tableId');
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _isScanned = false);
      _controller?.start();
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceDark,
      body: Stack(
        children: [
          // Camera or Manual Input
          if (_useManualInput || _controller == null)
            _buildManualInput()
          else
            _buildCameraView(),

          // Top Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo area
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.accentColor, Color(0xFFD4870A)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.restaurant_menu,
                            color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'IPOT',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.digitalOrdering,
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 11,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom instruction panel
          if (!_useManualInput && _controller != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildInstructionPanel(),
            ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    return Stack(
      children: [
        MobileScanner(
          controller: _controller!,
          onDetect: _onBarcodeDetected,
        ),
        // Dark overlay with scan frame
        CustomPaint(
          painter: _ScanOverlayPainter(),
          child: Container(),
        ),
      ],
    );
  }

  Widget _buildManualInput() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            // Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.surfaceMedium,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                color: AppTheme.accentColor,
                size: 50,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              AppLocalizations.of(context)!.enterTableId,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.enterTableIdDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _manualController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.exampleTableId,
                prefixIcon: const Icon(Icons.table_restaurant,
                    color: AppTheme.accentColor),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final value = _manualController.text.trim();
                  if (value.isEmpty) {
                    _showErrorSnackbar(AppLocalizations.of(context)!.emptyTableIdError);
                    return;
                  }
                  _processQRValue(value);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(AppLocalizations.of(context)!.seeMenu),
                ),
              ),
            ),
            if (!_useManualInput) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => setState(() => _useManualInput = false),
                child: Text(
                  AppLocalizations.of(context)!.scanQrCode,
                  style: TextStyle(color: AppTheme.accentColor),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionPanel() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceMedium,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.qr_code_2, color: AppTheme.accentColor, size: 32),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.pointCameraToQr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppLocalizations.of(context)!.qrAvailableOnTable,
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => setState(() => _useManualInput = true),
            child: Text(
              AppLocalizations.of(context)!.manualInputTableId,
              style: TextStyle(color: AppTheme.accentColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;

    final cutoutSize = size.width * 0.65;
    final left = (size.width - cutoutSize) / 2;
    final top = (size.height - cutoutSize) / 2 - 50;
    final scanRect = Rect.fromLTWH(left, top, cutoutSize, cutoutSize);
    final roundedRect = RRect.fromRectAndRadius(scanRect, const Radius.circular(20));

    // Darken everything except the scan area
    final fullPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final scanPath = Path()..addRRect(roundedRect);
    final overlayPath = Path.combine(PathOperation.difference, fullPath, scanPath);
    canvas.drawPath(overlayPath, paint);

    // Draw corner indicators
    final cornerPaint = Paint()
      ..color = AppTheme.accentColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const cornerLength = 24.0;

    // Top-left
    canvas.drawLine(Offset(left, top + cornerLength), Offset(left, top), cornerPaint);
    canvas.drawLine(Offset(left, top), Offset(left + cornerLength, top), cornerPaint);
    // Top-right
    canvas.drawLine(Offset(left + cutoutSize - cornerLength, top), Offset(left + cutoutSize, top), cornerPaint);
    canvas.drawLine(Offset(left + cutoutSize, top), Offset(left + cutoutSize, top + cornerLength), cornerPaint);
    // Bottom-left
    canvas.drawLine(Offset(left, top + cutoutSize - cornerLength), Offset(left, top + cutoutSize), cornerPaint);
    canvas.drawLine(Offset(left, top + cutoutSize), Offset(left + cornerLength, top + cutoutSize), cornerPaint);
    // Bottom-right
    canvas.drawLine(Offset(left + cutoutSize - cornerLength, top + cutoutSize), Offset(left + cutoutSize, top + cutoutSize), cornerPaint);
    canvas.drawLine(Offset(left + cutoutSize, top + cutoutSize - cornerLength), Offset(left + cutoutSize, top + cutoutSize), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
