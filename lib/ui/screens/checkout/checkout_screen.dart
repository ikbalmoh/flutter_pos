import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selleri/modules/cart/cart.dart';
import 'package:selleri/ui/screens/checkout/discount_promotion.dart';
import 'package:selleri/ui/screens/checkout/order_summary.dart';
import 'package:selleri/ui/screens/checkout/payment.dart';
import 'package:selleri/utils/formater.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  CartController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey.shade50,
        appBar: AppBar(
          title: Text('checkout'.capitalizeFirst!),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.more_vert_rounded))
          ],
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
                    OrderSummary(
                      items: controller.cart!.items,
                      subtotal: controller.cart!.subtotal!,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    const DiscountPromotion(),
                    PaymentDetails(grandTotal: controller.cart!.grandTotal ?? 0,)
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(0),
              color: Colors.white,
              elevation: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 15, bottom: 5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'total'.capitalize!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                              CurrencyFormat.currency(
                                  controller.cart!.subtotal),
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
                        ),
                        onPressed: () {},
                        child: Text('pay_finish'.toUpperCase()),
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
