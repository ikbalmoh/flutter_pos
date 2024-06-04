import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/ui/screens/checkout/discount_promotion/discount_promotion.dart';
import 'package:selleri/ui/screens/checkout/order_summary.dart';
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
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => const StoreTransaction(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartNotiferProvider);
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text('checkout'.tr()),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.more_vert_rounded))
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 7,
                    ),
                    OrderSummary(),
                    SizedBox(
                      height: 7,
                    ),
                    DiscountPromotion(),
                    PaymentDetails()
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
                        onPressed:
                            cart.totalPayment > 0 ? onStoreTransaction : null,
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
