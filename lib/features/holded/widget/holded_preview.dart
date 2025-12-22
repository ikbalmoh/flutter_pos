import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/features/cart/model/cart_holded.dart';
import 'package:selleri/features/outlet/model/outlet_config.dart';
import 'package:selleri/features/cart/provider/cart_provider.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/transaction/provider/transactions_provider.dart';
import 'package:selleri/features/cart/widget/components/order_summary/order_summary.dart';
import 'package:selleri/features/holded/widget/components/hold_form.dart';
import 'package:selleri/shared/utils/app_alert.dart';

class HoldedPreview extends ConsumerWidget {
  const HoldedPreview(
      {required this.cartHolded,
      this.asWidget,
      required this.onDelete,
      super.key});

  final CartHolded cartHolded;
  final bool? asWidget;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    OutletState? outletState = ref.watch(outletProvider).value;

    OutletConfig? config =
        outletState is OutletSelected ? outletState.config : null;

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
                taxable: config?.taxable ?? false,
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
                    tooltip: 'delete_x'.tr(args: ['holded_transactions'.tr()]),
                    onPressed: onDelete,
                    icon: const Icon(
                      CupertinoIcons.trash,
                      color: Colors.red,
                    ),
                    constraints: const BoxConstraints(),
                  ),
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
