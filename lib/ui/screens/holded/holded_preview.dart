import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/cart_holded.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/providers/transaction/transactions_provider.dart';
import 'package:selleri/ui/components/cart/order_summary/order_summary.dart';
import 'package:selleri/ui/components/hold/hold_form.dart';
import 'package:selleri/utils/app_alert.dart';

class HoldedPreview extends ConsumerWidget {
  const HoldedPreview({required this.cartHolded, this.asWidget, super.key});

  final CartHolded cartHolded;
  final bool? asWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void openHoldedTransaction() {
      ref.read(cartProvider.notifier).openHoldedCart(cartHolded);
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
              cartHolded.dataHold,
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

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: asWidget != true
          ? AppBar(
              title: Text(cartHolded.transactionNo),
              iconTheme: const IconThemeData(color: Colors.black87),
              titleTextStyle: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            )
          : null,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: OrderSummary(
                cart: cartHolded.dataHold,
                radius: const Radius.circular(5),
                outletState: ref.watch(outletProvider).value as OutletSelected,
              ),
            ),
          ),
          Card(
            elevation: 5,
            color: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
            margin: asWidget == true
                ? const EdgeInsets.symmetric(horizontal: 15)
                : const EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'print_receipt'.tr(),
                    onPressed: onPrintReceipt,
                    icon: const Icon(CupertinoIcons.printer),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onOpenHoldedCart,
                      child: Text('open_transaction'.tr()),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
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
