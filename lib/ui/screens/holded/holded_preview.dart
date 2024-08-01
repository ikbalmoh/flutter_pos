import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/cart_holded.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
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
      ref.read(cartNotiferProvider.notifier).openHoldedCart(cartHolded);
      while (context.canPop()) {
        context.pop();
      }
    }

    void onOpenHoldedCart() {
      final currentCart = ref.read(cartNotiferProvider);
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

    void onPrintReceipt() async {
      try {
        await ref.read(transactionsNotifierProvider.notifier).printReceipt(
              cartHolded.dataHold,
              isHold: true,
            );
      } catch (e) {
        // ignore: use_build_context_synchronously
        AppAlert.snackbar(context, e.toString());
      }
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
