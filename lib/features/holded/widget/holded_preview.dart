import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:screenshot/screenshot.dart';
import 'package:selleri/features/cart/model/cart_holded.dart';
import 'package:selleri/features/outlet/model/outlet_config.dart';
import 'package:selleri/features/cart/provider/cart_provider.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/transaction/provider/transactions_provider.dart';
import 'package:selleri/features/cart/widget/components/order_summary/order_summary.dart';
import 'package:selleri/features/holded/widget/components/hold_form.dart';
import 'package:selleri/shared/utils/app_alert.dart';
import 'package:selleri/shared/utils/share_file.dart';
import 'package:share_plus/share_plus.dart';

class HoldedPreview extends ConsumerStatefulWidget {
  const HoldedPreview(
      {required this.cartHolded,
      this.asWidget,
      required this.onDelete,
      super.key});

  final CartHolded cartHolded;
  final bool? asWidget;
  final void Function() onDelete;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HoldedPreviewState();
}

class _HoldedPreviewState extends ConsumerState<HoldedPreview> {
  bool sharing = false;

  final GlobalKey summaryContainerKey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();

  void onShareReceipt(BuildContext context) async {
    setState(() {
      sharing = true;
    });
    try {
      await ShareFile.shareReceipt(
        context,
        containerKey: summaryContainerKey,
        title: widget.cartHolded.transactionNo,
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

  @override
  Widget build(BuildContext context) {
    OutletState? outletState = ref.watch(outletProvider).value;

    OutletConfig? config =
        outletState is OutletSelected ? outletState.config : null;

    void openHoldedTransaction() {
      ref.read(cartProvider.notifier).openHoldedCart(widget.cartHolded);
      while (context.canPop()) {
        context.pop();
      }
    }

    void onOpenHoldedCart() {
      final currentCart = ref.read(cartProvider);
      if (currentCart.items.isNotEmpty || currentCart.holdAt != null) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          isDismissible: false,
          enableDrag: false,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) {
            return HoldForm(
              onHolded: () => openHoldedTransaction(),
            );
          },
        );
      } else {
        openHoldedTransaction();
      }
    }

    void printReceipt({bool withPrice = true}) async {
      try {
        await ref.read(transactionsProvider.notifier).printReceipt(
              widget.cartHolded.dataHold,
              isHold: true,
              withPrice: withPrice,
            );
      } catch (e) {
        AppAlert.toast(e.toString());
      }
    }

    void onPrintReceipt() async {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 15,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        top: 2, left: 15, right: 10, bottom: 5),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 0.5,
                          color: Colors.blueGrey.shade100,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'print_receipt'.tr(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.close),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(Icons.receipt_long),
                    title: Text('with_price'.tr()),
                    onTap: () => printReceipt(withPrice: true),
                  ),
                  ListTile(
                    leading: const Icon(Icons.receipt),
                    title: Text('without_price'.tr()),
                    onTap: () => printReceipt(withPrice: false),
                  ),
                ],
              ),
            );
          });
    }

    Widget deleteButton = IconButton(
      tooltip: 'delete_x'.tr(args: ['holded_transactions'.tr()]),
      onPressed: widget.onDelete,
      icon: const Icon(
        CupertinoIcons.trash,
        color: Colors.red,
      ),
      constraints: const BoxConstraints(),
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: widget.asWidget != true
          ? AppBar(
              title: Text(widget.cartHolded.transactionNo),
              iconTheme: const IconThemeData(color: Colors.black87),
              titleTextStyle: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              actions: [
                deleteButton,
              ],
              actionsPadding: const EdgeInsets.only(right: 10),
            )
          : null,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Screenshot(
                controller: screenshotController,
                child: OrderSummary(
                  key: summaryContainerKey,
                  withAttribute: true,
                  taxable: config?.taxable ?? false,
                  cart: widget.cartHolded.dataHold,
                  radius: const Radius.circular(5),
                  outletState:
                      ref.watch(outletProvider).value as OutletSelected,
                ),
              ),
            ),
          ),
          Card(
            elevation: 5,
            color: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
            margin: widget.asWidget == true
                ? const EdgeInsets.symmetric(horizontal: 15)
                : const EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              child: Row(
                children: [
                  if (widget.asWidget == false) deleteButton,
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
                  IconButton(
                    tooltip: 'print_receipt'.tr(),
                    onPressed: onPrintReceipt,
                    icon: const Icon(CupertinoIcons.printer),
                    constraints: const BoxConstraints(),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 7.5),
                      child: ElevatedButton(
                        onPressed: onOpenHoldedCart,
                        child: Text('open_transaction'.tr()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
