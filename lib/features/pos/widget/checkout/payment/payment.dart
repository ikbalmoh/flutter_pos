import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/features/cart/model/cart.dart';
import 'package:selleri/features/cart/model/cart_payment.dart';
import 'package:selleri/features/cart/widget/components/cash_payment_shortcut.dart';
import 'package:selleri/features/pos/model/payment_method.dart';
import 'package:selleri/features/pos/model/payment_type.dart';
import 'package:selleri/features/cart/widget/components/payment_form.dart';
import 'package:selleri/shared/provider/app_config_provider.dart';
import 'package:selleri/shared/utils/authorization_helper.dart';
import 'package:selleri/shared/utils/formater.dart';
import 'payment_methods.dart';

class PaymentDetails extends ConsumerStatefulWidget {
  const PaymentDetails({
    required this.cart,
    required this.onAddPayment,
    required this.onRemovePayment,
    required this.paymentMethods,
    super.key,
  });

  final Cart cart;
  final List<PaymentMethod> paymentMethods;
  final Function(CartPayment payment) onAddPayment;
  final Function(String paymentMethodId) onRemovePayment;

  @override
  ConsumerState<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends ConsumerState<PaymentDetails> {
  PaymentMethod? cashPayment;
  PaymentMethod? qrisPayment;

  List<PaymentType> paymentTypes = [];

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();

    initPaymentTypes();
  }

  void initPaymentTypes() async {
    final availablePaymentTypes = widget.paymentMethods
        .map((p) => p.type)
        .toSet();

    final filteredPaymentTypes = [
      PaymentType(
        id: 6,
        icon: Icon(Icons.qr_code, color: Colors.black),
        name: 'QRIS',
        isExpanded: false,
      ),
      PaymentType(
        id: 2,
        icon: Icon(Icons.credit_card_outlined, color: Colors.amber.shade600),
        name: 'Debit',
        isExpanded: false,
      ),
      PaymentType(
        id: 3,
        icon: Icon(Icons.credit_card, color: Colors.red.shade700),
        name: 'Credit',
        isExpanded: false,
      ),
      PaymentType(
        id: 4,
        icon: Icon(Icons.wallet, color: Colors.blue.shade900),
        name: 'payment_x'.tr(args: ['other'.tr()]),
        isExpanded: false,
      ),
    ].where((p) => availablePaymentTypes.contains(p.id)).toList();

    final appConfig = ref.read(appConfigProvider).requireValue;

    setState(() {
      cashPayment = widget.paymentMethods.firstWhereOrNull((p) => p.type == 1);
      final qrisPaymentTypeId = appConfig.qrisPaymentType ?? 6;

      qrisPayment = widget.paymentMethods.firstWhereOrNull(
        (p) => p.type == qrisPaymentTypeId,
      );
      paymentTypes = filteredPaymentTypes;
    });
  }

  void onSelectMethod(PaymentMethod method) async {
    CartPayment? cartPayment = widget.cart.payments.firstWhereOrNull(
      (payment) => payment.paymentMethodId == method.id && payment.id == null,
    );

    final bool hasQris =
        widget.cart.payments.firstWhereOrNull(
          (payment) => payment.paymentMethodId == qrisPayment?.id,
        ) !=
        null;

    final bool isCash = method.type == 1;

    final appConfig = ref.read(appConfigProvider).requireValue;
    final qrisPaymentTypeId = appConfig.qrisPaymentType ?? 6;

    if (method.type == qrisPaymentTypeId) {
      if (cartPayment != null) {
        return;
      }

      final isAuthorized = await AuthorizationHelper.authorize('make-payment');
      if (!isAuthorized) return;

      widget.onAddPayment(
        CartPayment(
          paymentMethodId: method.id,
          paymentName: method.name,
          paymentValue: widget.cart.grandTotal,
        ),
      );

      return;
    }

    // Show payment sheet to input payment amount
    CartPayment? payment = await showModalBottomSheet(
      backgroundColor: Colors.white,
      // ignore: use_build_context_synchronously
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return PaymentForm(
          method: method,
          isCash: isCash,
          cartPayment: cartPayment,
          onRemovePayment: widget.onRemovePayment,
          insufficient:
              (widget.cart.grandTotal -
              (hasQris ? 0 : widget.cart.totalPayment)),
        );
      },
    );
    if (payment == null) {
      return;
    }
    final isAuthorized = await AuthorizationHelper.authorize('make-payment');
    if (!isAuthorized) return;
    widget.onAddPayment(payment);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final cashUsed = widget.cart.payments.firstWhereOrNull(
      (payment) => payment.paymentMethodId == cashPayment?.id,
    );
    return Card(
      margin: const EdgeInsets.all(10),
      color: Colors.white,
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text('payments'.tr(), style: textTheme.bodyLarge),
          ),
          Divider(height: 1, color: Colors.blueGrey.shade50),
          if (widget.cart.prevPayments().isNotEmpty)
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(
                    'prev_payments'.tr(),
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade900,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                PaymentMethods(
                  paymentMethods: widget.paymentMethods
                      .where(
                        (p) => widget.cart
                            .prevPayments()
                            .map((pc) => pc.paymentMethodId)
                            .contains(p.id),
                      )
                      .toList(),
                  cartPayments: widget.cart.payments,
                  isPrevious: true,
                ),
              ],
            ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12.5),
              bottomRight: Radius.circular(12.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.money_rounded,
                    color: Colors.green.shade600,
                  ),
                  title: Text(
                    'cash'.tr(),
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  selectedTileColor: Colors.teal.shade50.withValues(alpha: 0.5),
                  subtitle: cashUsed != null
                      ? Text(
                          CurrencyFormat.currency(cashUsed.paymentValue),
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.teal,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : null,
                  trailing: cashUsed != null
                      ? Icon(Icons.check_circle, color: Colors.teal, size: 18)
                      : Icon(
                          Icons.circle_outlined,
                          color: Colors.grey.shade500,
                          size: 18,
                        ),
                  onTap: cashPayment != null
                      ? () => onSelectMethod(cashPayment!)
                      : null,
                  selected: cashUsed != null,
                  dense: true,
                  contentPadding: const EdgeInsets.only(left: 15, right: 25),
                ),
                if (cashUsed == null)
                  CashPaymentShortcut(
                    padding: const EdgeInsets.only(left: 50, right: 10),
                    transactionAmount: widget.cart.grandTotal,
                    onSelected: (value) {
                      value == null
                          ? onSelectMethod(cashPayment!)
                          : widget.onAddPayment(
                              CartPayment(
                                paymentMethodId: cashPayment!.id,
                                paymentName: cashPayment!.name,
                                paymentValue: value,
                              ),
                            );
                    },
                  ),
                ExpansionPanelList(
                  elevation: 0,
                  dividerColor: Colors.grey.shade200,
                  materialGapSize: 0,
                  expandedHeaderPadding: const EdgeInsets.all(0),
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      paymentTypes[index] = paymentTypes[index].copyWith(
                        isExpanded: isExpanded,
                      );
                    });
                  },
                  children: paymentTypes.map<ExpansionPanel>((
                    PaymentType type,
                  ) {
                    final paymentMethods = widget.paymentMethods
                        .where((p) => p.type == type.id)
                        .toList();
                    final bool anyPaymentUsed = widget.cart.payments.any(
                      (p) => paymentMethods
                          .map((p) => p.id)
                          .contains(p.paymentMethodId),
                    );
                    return ExpansionPanel(
                      backgroundColor: Colors.white,
                      canTapOnHeader: !anyPaymentUsed,
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          leading: type.icon,
                          title: Text(
                            type.name,
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade900,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          selected: anyPaymentUsed,
                        );
                      },
                      body: PaymentMethods(
                        onSelectMethod: onSelectMethod,
                        paymentMethods: paymentMethods,
                        cartPayments: widget.cart.payments,
                      ),
                      isExpanded: type.isExpanded == true || anyPaymentUsed,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
