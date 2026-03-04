import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide AppBar;
import 'package:selleri/app/widget/app_bar.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/features/cart/model/cart.dart' as model;
import 'package:selleri/features/outlet/model/outlet_config.dart';
import 'package:selleri/features/cart/provider/cart_provider.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/holded/widget/components/hold_button.dart';
import 'package:selleri/features/pos/widget/checkout/add_rounding.dart';
import 'package:selleri/features/pos/widget/checkout/confirm_store_transaction.dart';
import 'package:selleri/features/pos/widget/checkout/discount_promotion/discount_promotion.dart';
import 'package:selleri/features/cart/widget/components/order_summary/order_summary.dart';
import 'package:selleri/features/pos/widget/checkout/payment/payment.dart';
import 'package:selleri/shared/utils/formater.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({required this.isPartialPayment, super.key});

  final bool isPartialPayment;

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  final GlobalKey _paymentDetailsKey = GlobalKey();
  bool _isActionsVisible = false;
  late final AnimationController _actionsAnimController;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _actionsAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _actionsAnimController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final keyContext = _paymentDetailsKey.currentContext;
    if (keyContext == null) return;
    final box = keyContext.findRenderObject() as RenderBox;
    final widgetBottom = box.localToGlobal(Offset.zero).dy + box.size.height;
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final visible = widgetBottom <= screenHeight - bottomPadding - 120;
    if (visible != _isActionsVisible) {
      setState(() => _isActionsVisible = visible);
      if (visible) {
        _actionsAnimController.forward();
      } else {
        _actionsAnimController.reverse();
      }
    }
  }

  void onChangeRoundingValue() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.white,
        useSafeArea: true,
        builder: (context) {
          return AddRounding();
        });
  }

  void onConfirmStoreTransaction() async {
    showModalBottomSheet(
      isDismissible: true,
      enableDrag: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useSafeArea: true,
      builder: (context) => ConfirmStoreTransaction(
        isPartialPayment: widget.isPartialPayment,
      ),
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
      onPressed: (isPartialEnabled ||
              cart.totalPayment >= cart.grandTotal ||
              cart.grandTotal == 0)
          ? onConfirmStoreTransaction
          : null,
      child: Text(
          '${'pay'.tr().toUpperCase()} ${CurrencyFormat.currency(cart.totalCurrentPayment())}'),
    );

    Widget actions = Container(
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(5, -10),
          ),
        ],
      ),
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
                    cart: ref.watch(cartProvider),
                    radius: const Radius.circular(10),
                    mainAxisSize:
                        isKeyboardVisible ? MainAxisSize.min : MainAxisSize.max,
                    outletState:
                        ref.watch(outletProvider).value as OutletSelected,
                    onChangeRoundingValue: widget.isPartialPayment == true
                        ? null
                        : onChangeRoundingValue,
                  ),
                )
              : OrderSummary(
                  taxable: config?.taxable ?? false,
                  cart: ref.watch(cartProvider),
                  radius: const Radius.circular(10),
                  mainAxisSize: MainAxisSize.min,
                  outletState:
                      ref.watch(outletProvider).value as OutletSelected,
                  onChangeRoundingValue: widget.isPartialPayment == true
                      ? null
                      : onChangeRoundingValue,
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
                  'payment_x'.tr(args: [''])
                ])
              : 'payment_x'.tr(args: [''])),
          elevation: 1,
        ),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (isTablet)
                Container(
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
                  width:
                      ResponsiveBreakpoints.of(context).largerOrEqualTo(DESKTOP)
                          ? 400
                          : MediaQuery.of(context).size.width * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: cartPreview,
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: isTablet
                          ? SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                        horizontal: 7.5, vertical: 7.5)
                                    .copyWith(bottom: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const DiscountPromotion(),
                                    paymentDetails,
                                  ],
                                ),
                              ),
                            )
                          : Stack(
                              children: [
                                Positioned.fill(
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                              horizontal: 7.5, vertical: 7.5)
                                          .copyWith(bottom: 140),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: cartPreview,
                                          ),
                                          const DiscountPromotion(),
                                          KeyedSubtree(
                                            key: _paymentDetailsKey,
                                            child: paymentDetails,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 2),
                                      end: Offset.zero,
                                    ).animate(CurvedAnimation(
                                      parent: _actionsAnimController,
                                      curve: Curves.easeOutCubic,
                                    )),
                                    child: actions,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    if (isTablet) actions,
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
