import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide AppBar;
import 'package:selleri/app/widget/app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/features/cart/model/cart.dart' as model;
import 'package:selleri/features/outlet/model/outlet_config.dart';
import 'package:selleri/features/cart/provider/cart_provider.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/shift/provider/shift_provider.dart';
import 'package:selleri/features/transaction/provider/transactions_provider.dart';
import 'package:selleri/features/cart/widget/components/cancel_transaction_form.dart';
import 'package:selleri/features/cart/widget/components/order_summary/order_summary.dart';
import 'package:selleri/features/pos/widget/checkout/checkout_screen.dart';
import 'package:selleri/shared/utils/app_alert.dart';
import 'package:selleri/shared/utils/formater.dart';
import 'package:selleri/shared/utils/share_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';

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
    try {
      await ShareFile.shareReceipt(
        context,
        containerKey: summaryContainerKey,
        title: widget.cart.transactionNo,
        screenshotController: screenshotController,
        onReadyToShare: () {
          setState(() {
            sharing = false;
          });
        },
        onShared: (status) {
          if (status == ShareResultStatus.success) {
            AppAlert.toast('receipt_shared'.tr());
          }
        },
      );
      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;
      setState(() {
        sharing = false;
      });
      AppAlert.toast(e.toString());
    }
  }

  void onPrintReceipt(BuildContext context) async {
    try {
      await ref.read(transactionsProvider.notifier).printReceipt(
            widget.cart,
          );
    } catch (e) {
      log('PRINT FAILED: $e');
      // ignore: use_build_context_synchronously
      AppAlert.snackbar(e.toString());
    }
  }

  void onPrintKitchen(BuildContext context) async {
    try {
      await ref.read(transactionsProvider.notifier).printKitchen(
            widget.cart,
          );
    } catch (e) {
      log('PRINT FAILED: $e');
      // ignore: use_build_context_synchronously
      AppAlert.snackbar(e.toString());
    }
  }

  void onCancelTransaction(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        useSafeArea: true,
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
    if (!mounted) return;
    Future.delayed(const Duration(microseconds: 200), () {
      if (!mounted) return;
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
        .where((cart) => cart.transactionNo == widget.cart.transactionNo)
        .firstOrNull;

    final isTablet = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    final OutletSelected outletState =
        ref.watch(outletProvider).value as OutletSelected;
    OutletConfig? config = outletState.config;

    bool? hasTableAddon = (ref.watch(outletProvider).value as OutletSelected)
        .config
        .addOns
        ?.contains('table');

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
          : SafeArea(
              child: Column(
                children: [
                  transaction.deletedAt != null
                      ? Container(
                          color: Colors.red.shade500,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'canceled'.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.white),
                              ),
                              Text(
                                DateTimeFormater.dateToString(
                                    transaction.deletedAt!,
                                    format: 'dd MMM y HH:mm'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        )
                      : transaction.totalPayment < transaction.grandTotal
                          ? Container(
                              color: Colors.amber.shade600,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'insufficient_payment'.tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                  Text(
                                    CurrencyFormat.currency(
                                        transaction.grandTotal -
                                            transaction.totalPayment),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ],
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
                            taxable: config.taxable ?? false,
                            key: summaryContainerKey,
                            radius: const Radius.circular(5),
                            cart: transaction,
                            withAttribute: true,
                            outletState: outletState,
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
                              hasTableAddon == true
                                  ? IconButton(
                                      tooltip: 'print_kitchen'.tr(),
                                      onPressed: () => onPrintKitchen(context),
                                      icon: Icon(Icons.restaurant_outlined))
                                  : Container(),
                              const SizedBox(width: 10),
                              !isTablet &&
                                      currentShift != null &&
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
                                        onPressed: () =>
                                            onPrintReceipt(context),
                                        icon:
                                            const Icon(CupertinoIcons.printer),
                                        label: Text('print'.tr()),
                                      ),
                                    ),
                              currentShift != null &&
                                      widget.cart.totalPayment <
                                          widget.cart.grandTotal
                                  ? Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
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
            ),
    );
  }
}
