import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/cart_payment.dart';
import 'package:selleri/data/models/payment_method.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/utils/formater.dart';

class PaymentMethods extends ConsumerWidget {
  const PaymentMethods({
    super.key,
    this.onSelectMethod,
    required this.paymentMethods,
    required this.cartPayments,
    this.isPrevious,
  });

  final bool? isPrevious;
  final List<CartPayment> cartPayments;
  final List<PaymentMethod> paymentMethods;
  final Function(PaymentMethod)? onSelectMethod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, idx) {
        PaymentMethod method = paymentMethods[idx];
        CartPayment? cartPayment = cartPayments.firstWhereOrNull(
          (payment) =>
              (isPrevious == true
                  ? payment.createdAt != null
                  : payment.createdAt == null) &&
              payment.paymentMethodId == method.id &&
              payment.paymentValue > 0,
        );
        bool inUse = cartPayment != null;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Material(
            color: isPrevious == true ? Colors.grey.shade50 : Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: inUse && isPrevious != true
                    ? Colors.teal
                    : Colors.grey.shade200,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(7.5),
              ),
            ),
            child: InkWell(
              splashColor: Colors.grey.shade50,
              highlightColor: Colors.grey.shade100,
              borderRadius: const BorderRadius.all(
                Radius.circular(7.5),
              ),
              onTap:
                  onSelectMethod == null ? null : () => onSelectMethod!(method),
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
                        inUse
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
                    inUse
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
      itemCount: paymentMethods.length,
    );
  }
}
