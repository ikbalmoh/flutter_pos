import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/features/cart/model/cart.dart';
import 'package:selleri/features/cart/model/cart_payment.dart';
import 'package:selleri/features/pos/model/payment_method.dart';
import 'package:selleri/features/pos/model/payment_type.dart';
import 'package:selleri/features/cart/widget/components/payment_form.dart';
import 'package:selleri/shared/constants/app_config.dart';
import 'package:selleri/shared/utils/authorization_helper.dart';
import 'payment_methods.dart';

class PaymentDetails extends StatefulWidget {
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
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  late PaymentMethod? cashPayment;
  late PaymentMethod? qrisPayment;

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    setState(() {
      cashPayment = widget.paymentMethods.firstWhereOrNull((p) => p.type == 1);
      qrisPayment = widget.paymentMethods
          .firstWhereOrNull((p) => p.type == AppConfig.qrisPaymentTypeId);
    });
  }

  List<PaymentType> paymentTypes = [
    PaymentType(
      id: 6,
      icon: Icon(Icons.qr_code, color: Colors.black),
      name: 'QRIS',
      isExpanded: false,
    ),
    PaymentType(
      id: 4,
      icon: Icon(
        Icons.wallet,
        color: Colors.blue.shade900,
      ),
      name: 'e-wallet',
      isExpanded: false,
    ),
    PaymentType(
      id: 2,
      icon: Icon(
        Icons.credit_card_outlined,
        color: Colors.amber.shade600,
      ),
      name: 'Debit',
      isExpanded: false,
    ),
    PaymentType(
      id: 3,
      icon: Icon(
        Icons.credit_card,
        color: Colors.red.shade700,
      ),
      name: 'Credit',
      isExpanded: false,
    ),
  ];

  void onSelectMethod(PaymentMethod method) async {
    // if payment type is QRIS, show QRIS modal
    if (method.type == AppConfig.qrisPaymentTypeId) {
      // TODO: Implement QRIS modal, use qris riverpos
      return;
    }
    CartPayment? cartPayment = widget.cart.payments.firstWhereOrNull(
        (payment) =>
            payment.paymentMethodId == method.id && payment.createdAt == null);
    CartPayment? payment = await showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return PaymentForm(
          method: method,
          cartPayment: cartPayment,
          insufficient: (widget.cart.grandTotal - widget.cart.totalPayment),
        );
      },
    );
    if (payment == null) {
      return;
    }
    final isAuthorized = await AuthorizationHelper.authorize('make-payment');
    if (!isAuthorized) {
      return;
    }
    widget.onAddPayment(payment);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
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
          Divider(
            height: 1,
            color: Colors.blueGrey.shade50,
          ),
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
                      .where((p) => widget.cart
                          .prevPayments()
                          .map((pc) => pc.paymentMethodId)
                          .contains(p.id))
                      .toList(),
                  cartPayments: widget.cart.payments,
                  isPrevious: true,
                )
              ],
            ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12.5),
              bottomRight: Radius.circular(12.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                if (cashPayment != null)
                  PaymentMethods(
                    onSelectMethod: onSelectMethod,
                    paymentMethods: [
                      PaymentMethod(
                          id: cashPayment!.id, name: 'cash'.tr(), type: 1),
                    ],
                    cartPayments: widget.cart.payments,
                  ),
                ExpansionPanelList(
                  elevation: 0,
                  dividerColor: Colors.grey.shade200,
                  materialGapSize: 0,
                  expandedHeaderPadding: const EdgeInsets.all(0),
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      paymentTypes[index] =
                          paymentTypes[index].copyWith(isExpanded: isExpanded);
                    });
                  },
                  children:
                      paymentTypes.map<ExpansionPanel>((PaymentType type) {
                    final paymentMethods = widget.paymentMethods
                        .where((p) => p.type == type.id)
                        .toList();
                    return ExpansionPanel(
                      backgroundColor: Colors.white,
                      canTapOnHeader: true,
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
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                        );
                      },
                      body: PaymentMethods(
                        onSelectMethod: onSelectMethod,
                        paymentMethods: paymentMethods,
                        cartPayments: widget.cart.payments,
                      ),
                      isExpanded: type.isExpanded!,
                    );
                  }).toList(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
