import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:screenshot/screenshot.dart';
import 'package:selleri/data/models/cart.dart' as model;
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/providers/transaction/transactions_provider.dart';
import 'package:selleri/ui/components/cart/order_summary/order_summary.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/file_download.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';

class TransactionReceipt extends ConsumerStatefulWidget {
  const TransactionReceipt({required this.cart, super.key});

  final model.Cart cart;

  @override
  ConsumerState<TransactionReceipt> createState() => _TransactionReceiptState();
}

class _TransactionReceiptState extends ConsumerState<TransactionReceipt> {
  final GlobalKey summaryContainerKey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();

  bool sharing = false;

  void onShareReceipt(BuildContext context) async {
    setState(() {
      sharing = true;
    });
    final shareButtonBox = context.findRenderObject() as RenderBox?;
    final summaryContainerBox =
        summaryContainerKey.currentContext!.findRenderObject() as RenderBox?;

    final Size contentSize = summaryContainerBox!.size;

    final String title = 'Receipt ${widget.cart.transactionNo}';
    final path = await FileDownload().localPath;
    screenshotController.capture().then((imageBytes) async {
      pw.Document pdf = pw.Document(title: title);
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat(contentSize.width, contentSize.height),
          build: (context) {
            return pw.Center(child: pw.Image(pw.MemoryImage(imageBytes!)));
          },
        ),
      );
      final fileName = 'receipt-${widget.cart.transactionNo}.pdf';
      final filePath = '$path/$fileName';
      await File(filePath).writeAsBytes(await pdf.save());
      final xFile = XFile(filePath);
      setState(() {
        sharing = false;
      });
      final shareResult = await Share.shareXFiles([xFile],
          subject: title,
          sharePositionOrigin:
              shareButtonBox!.localToGlobal(Offset.zero) & shareButtonBox.size);
      if (shareResult.status == ShareResultStatus.success) {
        AppAlert.toast('receipt_shared'.tr());
      }
    });
  }

  void onPrintReceipt(BuildContext context) async {
    try {
      await ref.read(transactionsProvider.notifier).printReceipt(
            widget.cart,
          );
    } catch (e) {
      // ignore: use_build_context_synchronously
      AppAlert.snackbar(context, e.toString());
    }
  }

  void resetCart() {
    // Reset Navigation
    while (context.canPop() == true) {
      context.pop();
    }
    ref.read(cartProvider.notifier).initCart();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      appBar: AppBar(
        title: Text('transaction_receipt'.tr()),
        elevation: 3,
        foregroundColor: Colors.black87,
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        actions: [
          TextButton(
            onPressed: resetCart,
            style: TextButton.styleFrom(
              foregroundColor: Colors.teal,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
            ),
            child: Text(
              'new_transaction'.tr(),
            ),
          )
        ],
      ),
      backgroundColor: Colors.blueGrey.shade50,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: SizedBox(
                  width: isTablet ? 400 : double.infinity,
                  child: Screenshot(
                    controller: screenshotController,
                    child: OrderSummary(
                      key: summaryContainerKey,
                      radius: const Radius.circular(5),
                      cart: widget.cart,
                      withAttribute: true,
                      outletState:
                          ref.watch(outletProvider).value as OutletSelected,
                    ),
                  ),
                ),
              ),
            ),
            widget.cart.deletedAt == null
                ? SizedBox(
                    width: isTablet ? 430 : double.infinity,
                    child: Card(
                      margin: const EdgeInsets.all(0),
                      elevation: 6,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Row(
                          children: [
                            Builder(builder: (context) {
                              return IconButton(
                                onPressed: () => onShareReceipt(context),
                                icon: sharing
                                    ? const SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.black54,
                                        ),
                                      )
                                    : const Icon(Icons.share),
                              );
                            }),
                            isTablet ? const SizedBox(width: 15) : Container(),
                            !isTablet &&
                                    widget.cart.totalPayment <
                                        widget.cart.grandTotal
                                ? IconButton(
                                    onPressed: () => onPrintReceipt(context),
                                    icon: const Icon(CupertinoIcons.printer),
                                    tooltip: 'print'.tr(),
                                  )
                                : Expanded(
                                    flex: 1,
                                    child: ElevatedButton.icon(
                                      onPressed: () => onPrintReceipt(context),
                                      icon: const Icon(CupertinoIcons.printer),
                                      label: Text('print'.tr()),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
