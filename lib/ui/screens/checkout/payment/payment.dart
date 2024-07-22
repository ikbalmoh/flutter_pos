import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/cart_payment.dart';
import 'package:selleri/data/models/payment_method.dart';
import 'package:selleri/data/models/payment_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/ui/screens/checkout/payment/payment_form.dart';
import 'payment_methods.dart';

class PaymentDetails extends ConsumerStatefulWidget {
  const PaymentDetails({super.key});

  @override
  ConsumerState<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends ConsumerState<PaymentDetails> {
  List<PaymentType> paymentTypes = [
    PaymentType(
      id: 1,
      icon: Icon(
        Icons.wallet,
        color: Colors.green.shade700,
      ),
      name: 'cash'.tr(),
      isExpanded: true,
    ),
    PaymentType(
      id: 4,
      icon: Icon(
        Icons.qr_code,
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

  @override
  Widget build(BuildContext context) {
    void onSelectMethod(PaymentMethod method) {
      CartPayment? cartPayment = ref
          .read(cartNotiferProvider)
          .payments
          .firstWhereOrNull((payment) => payment.paymentMethodId == method.id);
      showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return PaymentForm(
            method: method,
            cartPayment: cartPayment,
          );
        },
      );
    }

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
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: ExpansionPanelList(
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
              children: paymentTypes.map<ExpansionPanel>((PaymentType type) {
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
                    type: type.id,
                  ),
                  isExpanded: type.isExpanded!,
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
