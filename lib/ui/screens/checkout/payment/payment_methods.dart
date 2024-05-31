import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/cart_payment.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/data/models/payment_method.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/utils/formater.dart';

class PaymentMethods extends ConsumerWidget {
  const PaymentMethods({
    super.key,
    required this.onSelectMethod,
    required this.type,
  });

  final Function(PaymentMethod) onSelectMethod;
  final int type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = Theme.of(context).textTheme;

    final List<PaymentMethod> payments =
        (ref.read(outletNotifierProvider).value as OutletSelected)
            .config
            .paymentMethods
            .where((p) => p.type == type)
            .toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, idx) {
        PaymentMethod method = payments[idx];
        CartPayment? cartPayment =
            ref.watch(cartNotiferProvider).payments.firstWhereOrNull(
                  (payment) => payment.paymentMethodId == method.id,
                );
        bool inuse = cartPayment != null;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Material(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: inuse ? Colors.teal : Colors.grey.shade200,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(7.5),
              ),
            ),
            child: InkWell(
              splashColor: Colors.blueGrey.shade50,
              highlightColor: Colors.blueGrey.shade100,
              borderRadius: const BorderRadius.all(
                Radius.circular(7.5),
              ),
              onTap: () => onSelectMethod(method),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          method.name,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        inuse
                            ? Text(
                                CurrencyFormat.currency(
                                  cartPayment.paymentValue,
                                ),
                                style: textTheme.bodySmall?.copyWith(
                                  color: Colors.teal,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    inuse
                        ? const Icon(
                            Icons.check_circle,
                            size: 17,
                            color: Colors.teal,
                          )
                        : const Icon(
                            Icons.circle_outlined,
                            size: 17,
                            color: Colors.grey,
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      itemCount: payments.length,
    );
  }
}
