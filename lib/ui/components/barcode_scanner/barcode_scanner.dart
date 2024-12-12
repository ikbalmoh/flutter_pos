import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'scanner_button_widgets.dart';
import 'scanner_error_widget.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({super.key, required this.onCaptured});

  final Function(String, Function) onCaptured;

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner>
    with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController(
      formats: const [BarcodeFormat.all],
      autoStart: false,
      useNewCameraSelector: true);
  StreamSubscription<Object?>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscription = controller.barcodes.listen(onDetect);
    unawaited(controller.start());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(onDetect);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
    super.didChangeAppLifecycleState(state);
  }

  void onDetect(BarcodeCapture capture) async {
    controller.stop();
    String? barcode = capture.barcodes.first.rawValue;
    log('Barocde Scaned: $barcode');
    if (barcode == null) {
      controller.start();
      return;
    }
    widget.onCaptured(barcode, () => controller.start());
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(const Offset(0, -50)),
      width: isTablet ? 300 : 220,
      height: isTablet ? 150 : 110,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('scan_item_barcode'.tr()),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: OrientationBuilder(
              builder: (context, orientation) => RotatedBox(
                quarterTurns: orientation == Orientation.portrait ? 4 : 3,
                child: MobileScanner(
                  fit: BoxFit.contain,
                  controller: controller,
                  scanWindow: isTablet ? null : scanWindow,
                  errorBuilder: (context, error, child) {
                    return ScannerErrorWidget(error: error);
                  },
                ),
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              if (!value.isInitialized ||
                  !value.isRunning ||
                  value.error != null) {
                return const SizedBox();
              }

              return CustomPaint(
                painter: ScannerOverlay(scanWindow: scanWindow),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ToggleFlashlightButton(controller: controller),
                  SwitchCameraButton(controller: controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    unawaited(_subscription?.cancel());
    _subscription = null;
    await controller.dispose();
  }
}

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 12.0,
  });

  final Rect scanWindow;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // First, draw the background,
    // with a cutout area that is a bit larger than the scan window.
    // Finally, draw the scan window itself.
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}
