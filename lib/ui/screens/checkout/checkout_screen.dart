import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/ui/components/hold/hold_button.dart';
import 'package:selleri/ui/screens/checkout/confirm_store_transaction.dart';
import 'package:selleri/ui/screens/checkout/discount_promotion/discount_promotion.dart';
import 'package:selleri/ui/components/cart/order_summary.dart';
import 'package:selleri/ui/screens/checkout/payment/payment.dart';
import 'package:selleri/utils/formater.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
  }

  void onConfirmStoreTransaction() async {
    showModalBottomSheet(
      isDismissible: true,
      enableDrag: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => const ConfirmStoreTransaction(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartNotiferProvider);

    OutletState? outletState = ref.watch(outletNotifierProvider).value;
    bool isPartialEnabled = outletState is OutletSelected
        ? (outletState.config.partialPayment ?? false)
        : false;

    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    Widget actions = Card(
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 0),
      color: Colors.white,
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17.5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      CurrencyFormat.currency(cart.grandTotal),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700, color: Colors.teal),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  const HoldButton(),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        backgroundColor: cart.totalPayment >= cart.grandTotal
                            ? Colors.teal
                            : Colors.red,
                      ),
                      onPressed: (cart.totalPayment >= cart.grandTotal ||
                              isPartialEnabled)
                          ? onConfirmStoreTransaction
                          : null,
                      child: Text(
                          '${'pay'.tr().toUpperCase()} ${CurrencyFormat.currency(cart.totalPayment)}'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );

    Widget cartPreview = Card(
      margin: const EdgeInsets.all(10),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.blueGrey.shade100, width: 1),
      ),
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 15),
            child: Text(
              'order_summary'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Divider(
            height: 1,
            color: Colors.blueGrey.shade50,
          ),
          OrderSummary(
            cart: ref.watch(cartNotiferProvider),
            radius: const Radius.circular(10),
          ),
        ],
      ),
    );
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text('payment'.tr(args: [''])),
          elevation: 1,
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            isTablet
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        right: BorderSide(
                          width: 1,
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ),
                    width: 350,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(5),
                      child: cartPreview,
                    ),
                  )
                : Container(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: isTablet
                    ? [
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: DiscountPromotion(),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 10)
                                .copyWith(bottom: 15),
                            child: const PaymentDetails(),
                          ),
                        ),
                        actions
                      ]
                    : [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 7.5)
                                      .copyWith(bottom: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: cartPreview,
                                  ),
                                  const DiscountPromotion(),
                                  const PaymentDetails()
                                ],
                              ),
                            ),
                          ),
                        ),
                        actions
                      ],
              ),
            ),
          ],
        ));
  }
}
