import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/data/models/cart.dart' as model;
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/providers/transaction/transactions_provider.dart';
import 'package:selleri/ui/components/cart/cancel_transaction_form.dart';
import 'package:selleri/ui/components/cart/order_summary/order_summary.dart';
import 'package:selleri/ui/screens/checkout/checkout_screen.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/file_download.dart';
import 'package:selleri/utils/formater.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;

class TransactionDetailScreen extends ConsumerStatefulWidget {
  final model.Cart cart;
  final bool? asWidget;

  const TransactionDetailScreen({required this.cart, this.asWidget, super.key});

  @override
  ConsumerState<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState
    extends ConsumerState<TransactionDetailScreen> {
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
      log('PRINT FAILED: $e');
      // ignore: use_build_context_synchronously
      AppAlert.snackbar(context, e.toString());
    }
  }

  void onCancelTransaction(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        builder: (context) {
          return CancelTransactionForm(
            cart: widget.cart,
          );
        });
  }

  void onContinuePayment(BuildContext context) async {
    log('Continue Payment: ${widget.cart}');
    model.Cart prevCart = ref.read(cartProvider);
    ref.read(cartProvider.notifier).reopen(widget.cart);
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const CheckoutScreen(
          isPartialPayment: true,
        ),
      ),
    );
    Future.delayed(const Duration(microseconds: 200), () {
      ref.read(cartProvider.notifier).reopen(prevCart);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentShift = ref.read(shiftProvider).value;
    final transaction = ref
        .watch(transactionsProvider)
        .value
        ?.data!
        .firstWhere((cart) => cart.transactionNo == widget.cart.transactionNo);

    final isTablet = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        automaticallyImplyLeading: widget.asWidget != true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('transaction_detail'.tr()),
            Text(
              widget.cart.transactionNo,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.black54),
            ),
          ],
        ),
        actions: [
          transaction?.deletedAt == null &&
                  transaction?.shiftId == currentShift?.id
              ? MenuAnchor(
                  style: MenuStyle(backgroundColor:
                      WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                    return Colors.white;
                  })),
                  menuChildren: [
                    MenuItemButton(
                      onPressed: () => onCancelTransaction(context),
                      leadingIcon: const Icon(
                        CupertinoIcons.xmark_circle_fill,
                        color: Colors.red,
                      ),
                      child: Text('cancel_transaction'.tr()),
                    ),
                  ],
                  builder: (BuildContext context, MenuController controller,
                      Widget? child) {
                    return IconButton(
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      icon: const Icon(Icons.more_vert),
                      tooltip: 'show_menu'.tr(),
                    );
                  },
                )
              : Container()
        ],
      ),
      body: transaction == null
          ? Container()
          : Column(
              children: [
                transaction.deletedAt != null
                    ? Container(
                        color: Colors.red.shade500,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Text(
                          '${'canceled'.tr()} ${DateTimeFormater.dateToString(transaction.deletedAt!, format: 'dd MMM y HH:mm')}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white),
                        ),
                      )
                    : Container(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: SizedBox(
                      width: isTablet ? 400 : double.infinity,
                      child: Screenshot(
                        controller: screenshotController,
                        child: OrderSummary(
                          key: summaryContainerKey,
                          radius: const Radius.circular(5),
                          cart: transaction,
                          withAttribute: true,
                        ),
                      ),
                    ),
                  ),
                ),
                widget.cart.deletedAt == null
                    ? Container(
                        color: Colors.white,
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
                            widget.cart.totalPayment < widget.cart.grandTotal
                                ? Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                        ),
                                        onPressed: () =>
                                            onContinuePayment(context),
                                        icon: const Icon(
                                            CupertinoIcons.creditcard_fill),
                                        label: Text('pay'.tr()),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
    );
  }
}
