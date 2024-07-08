import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/ui/screens/checkout/discount_promotion/discount_promotion.dart';
import 'package:selleri/ui/components/cart/order_summary.dart';
import 'package:selleri/ui/screens/checkout/payment/payment.dart';
import 'package:selleri/ui/screens/checkout/store_transaction.dart';
import 'package:selleri/utils/formater.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  void onStoreTransaction() async {
    showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => const PopScope(
        canPop: false,
        child: StoreTransaction(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartNotiferProvider);

    OutletState? outletState = ref.watch(outletNotifierProvider).value;
    bool isPartialEnabled = outletState is OutletSelected
        ? (outletState.config.partialPayment ?? false)
        : false;

    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text('payment'.tr(args: [''])),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 7,
                    ),
                    OrderSummary(cart: ref.watch(cartNotiferProvider)),
                    const SizedBox(
                      height: 7,
                    ),
                    const DiscountPromotion(),
                    const PaymentDetails()
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(0),
              color: Colors.white,
              elevation: 10,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(CurrencyFormat.currency(cart.grandTotal),
                              style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          backgroundColor: cart.totalPayment >= cart.grandTotal
                              ? Colors.teal
                              : Colors.red,
                        ),
                        onPressed: cart.payments.isNotEmpty &&
                                (cart.totalPayment >= cart.grandTotal ||
                                    isPartialEnabled)
                            ? onStoreTransaction
                            : null,
                        child: Text(
                            '${'pay'.tr().toUpperCase()} ${CurrencyFormat.currency(cart.totalPayment)}'),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
