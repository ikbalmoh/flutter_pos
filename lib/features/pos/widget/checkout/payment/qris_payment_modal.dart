import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/transaction/provider/qris_provider.dart';
import 'package:selleri/shared/utils/formater.dart';

class QrisPaymentModal extends ConsumerWidget {
  const QrisPaymentModal({
    super.key,
    required this.transactionNo,
    required this.amount,
  });

  final String transactionNo;
  final double amount;

  static Future<bool?> show(
    BuildContext context, {
    required String transactionNo,
    required double amount,
  }) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        barrierDismissible: false,
        builder: (_) =>
            QrisPaymentModal(transactionNo: transactionNo, amount: amount),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    final qrisAsync = ref.watch(qrisProvider(transactionNo, amount));

    ref.listen(qrisProvider(transactionNo, amount), (_, next) {
      if (next.valueOrNull?.isPaid == true) {
        Navigator.of(context).pop(true);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('payment_x'.tr(args: ['QRIS'])),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 150,
                left: 0,
                child: CustomPaint(
                  size: const Size(150, 150),
                  painter: _TrianglePainter(
                    color: Colors.red.shade600,
                    flip: false,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CustomPaint(
                  size: const Size(150, 150),
                  painter: _TrianglePainter(
                    color: Colors.red.shade600,
                    flip: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15).copyWith(bottom: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/qris.svg',
                          semanticsLabel: 'QRIS',
                          height: 25,
                        ),
                        SvgPicture.asset(
                          'assets/images/gpn.svg',
                          semanticsLabel: 'GPN',
                          height: 35,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: isTablet ? 20 : 120,
                    ),
                    Text(
                      'NMID: ${(ref.read(outletProvider).value as OutletSelected).config.merchantId}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    qrisAsync.when(
                      loading: () => Container(
                        width: isTablet ? 350 : 250,
                        height: isTablet ? 350 : 250,
                        color: Colors.white,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (e, _) => _ErrorBody(
                        error: e.toString(),
                        onRetry: () =>
                            ref.invalidate(qrisProvider(transactionNo, amount)),
                      ),
                      data: (qris) => qris.isPaid
                          ? _PaidBody()
                          : _QrBody(qrContent: qris.qrContent, amount: amount),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QrBody extends StatelessWidget {
  const _QrBody({required this.qrContent, required this.amount});

  final String qrContent;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(5),
          child: QrImageView(
            data: qrContent,
            size: 250,
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          CurrencyFormat.currency(amount),
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 10),
            Text(
              'waiting_payment'.tr(),
              style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

class _PaidBody extends StatelessWidget {
  const _PaidBody();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_rounded, color: Colors.green, size: 80),
          const SizedBox(height: 16),
          Text(
            'payment_success'.tr(),
            style: textTheme.titleLarge?.copyWith(color: Colors.green),
          ),
        ],
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.error, required this.onRetry});

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Container(
        width: 250,
        decoration: BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  const Icon(Icons.error_outline, color: Colors.red, size: 56),
                  const SizedBox(height: 16),
                  Text(
                    error,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(color: Colors.red),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            )),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text('retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  const _TrianglePainter({required this.color, this.flip = false});

  final Color color;

  /// [flip] = false → top-left corner triangle (right-angle at top-left)
  /// [flip] = true  → bottom-right corner triangle (right-angle at bottom-right)
  final bool flip;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    if (!flip) {
      path.moveTo(0, 0);
      path.lineTo(size.width * 0.8, size.height / 2);
      path.lineTo(0, size.height);
    } else {
      path.moveTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.lineTo(size.width, 0);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrianglePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.flip != flip;
}
