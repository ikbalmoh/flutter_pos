import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/data/models/cart.dart' as model;
import 'package:selleri/data/models/outlet_config.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/ui/components/hold/hold_button.dart';
import 'package:selleri/ui/screens/checkout/confirm_store_transaction.dart';
import 'package:selleri/ui/screens/checkout/discount_promotion/discount_promotion.dart';
import 'package:selleri/ui/components/cart/order_summary/order_summary.dart';
import 'package:selleri/ui/screens/checkout/payment/payment.dart';
import 'package:selleri/utils/formater.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({this.isPartialPayment, super.key});

  final bool? isPartialPayment;

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

  void onConfirmStoreTransaction() async {
    showModalBottomSheet(
      isDismissible: true,
      enableDrag: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useSafeArea: true,
      builder: (context) => const ConfirmStoreTransaction(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model.Cart cart = ref.watch(cartProvider);

    OutletState? outletState = ref.watch(outletProvider).value;
    OutletConfig? config =
        outletState is OutletSelected ? outletState.config : null;

    bool isPartialEnabled = config?.partialPayment ?? false;

    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    var buttonPay = ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        backgroundColor:
            cart.totalPayment >= cart.grandTotal ? Colors.teal : Colors.red,
      ),
      onPressed: ((isPartialEnabled && cart.payments.isNotEmpty) ||
              cart.totalPayment >= cart.grandTotal ||
              cart.grandTotal == 0)
          ? onConfirmStoreTransaction
          : null,
      child: Text(
          '${'pay'.tr().toUpperCase()} ${CurrencyFormat.currency(cart.totalCurrentPayment())}'),
    );

    Widget actions = Card(
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 0),
      color: Colors.white,
      elevation: 5,
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
              widget.isPartialPayment == true
                  ? buttonPay
                  : Row(
                      children: [
                        const HoldButton(),
                        const SizedBox(width: 15),
                        Expanded(
                          flex: 2,
                          child: buttonPay,
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
          isTablet
              ? Expanded(
                  child: OrderSummary(
                    taxable: config?.taxable ?? false,
                    cart: cart,
                    radius: const Radius.circular(10),
                    mainAxisSize:
                        isKeyboardVisible ? MainAxisSize.min : MainAxisSize.max,
                    outletState:
                        ref.watch(outletProvider).value as OutletSelected,
                  ),
                )
              : OrderSummary(
                  taxable: config?.taxable ?? false,
                  cart: cart,
                  radius: const Radius.circular(10),
                  mainAxisSize: MainAxisSize.min,
                  outletState:
                      ref.watch(outletProvider).value as OutletSelected,
                ),
        ],
      ),
    );

    Widget paymentDetails = PaymentDetails(
      cart: cart,
      onAddPayment: (payment) =>
          ref.read(cartProvider.notifier).addPayment(payment),
      onRemovePayment: (String paymentMethodId) =>
          ref.read(cartProvider.notifier).removePayment(paymentMethodId),
      paymentMethods: (ref.read(outletProvider).value as OutletSelected)
              .config
              .paymentMethods ??
          [],
    );

    var buttonPay = ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        backgroundColor:
            cart.totalPayment >= cart.grandTotal ? Colors.teal : Colors.red,
      ),
      onPressed: ((isPartialEnabled && cart.totalPayment > 0) ||
              cart.totalPayment >= cart.grandTotal ||
              cart.grandTotal == 0)
          ? onConfirmStoreTransaction
          : null,
      child: Text(
          '${'pay'.tr().toUpperCase()} ${CurrencyFormat.currency(cart.totalCurrentPayment())}'),
    );

    Widget actions = Card(
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 0),
      color: Colors.white,
      elevation: 5,
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
              widget.isPartialPayment == true
                  ? buttonPay
                  : Row(
                      children: [
                        const HoldButton(),
                        const SizedBox(width: 15),
                        Expanded(
                          flex: 2,
                          child: buttonPay,
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
          isTablet
              ? Expanded(
                  child: OrderSummary(
                    cart: cart,
                    radius: const Radius.circular(10),
                    mainAxisSize:
                        isKeyboardVisible ? MainAxisSize.min : MainAxisSize.max,
                    outletState:
                        ref.watch(outletProvider).value as OutletSelected,
                  ),
                )
              : OrderSummary(
                  cart: cart,
                  radius: const Radius.circular(10),
                  mainAxisSize: MainAxisSize.min,
                  outletState:
                      ref.watch(outletProvider).value as OutletSelected,
                ),
        ],
      ),
    );

    Widget paymentDetails = PaymentDetails(
      cart: cart,
      onAddPayment: (payment) =>
          ref.read(cartProvider.notifier).addPayment(payment),
      onRemovePayment: (String paymentMethodId) =>
          ref.read(cartProvider.notifier).removePayment(paymentMethodId),
      paymentMethods: (ref.read(outletProvider).value as OutletSelected)
              .config
              .paymentMethods ??
          [],
    );

    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text(widget.isPartialPayment == true
              ? 'finish_x'.tr(args: [
                  'payment'.tr(args: [''])
                ])
              : 'payment'.tr(args: [''])),
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
                    width: ResponsiveBreakpoints.of(context)
                            .largerOrEqualTo(DESKTOP)
                        ? 400
                        : MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: cartPreview,
                    ),
                  )
                : Container(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                                horizontal: 7.5, vertical: 7.5)
                            .copyWith(bottom: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isTablet
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: cartPreview,
                                  ),
                            const DiscountPromotion(),
                            paymentDetails
                          ],
                        ),
                      ),
                    ),
                  ),
                  cart.payments.isNotEmpty ? actions : Container()
                ],
              ),
            ),
          ],
        ));
  }
}
