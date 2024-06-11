import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/cart_payment.dart';
import 'package:selleri/data/models/payment_method.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/utils/formater.dart';

class PaymentForm extends ConsumerStatefulWidget {
  final PaymentMethod method;
  final CartPayment? cartPayment;
  const PaymentForm({super.key, required this.method, this.cartPayment});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaymentFormState();
}

class _PaymentFormState extends ConsumerState<PaymentForm> {
  TextEditingController amountController = TextEditingController(text: '0');
  TextEditingController refController = TextEditingController();

  double amount = 0;

  @override
  void initState() {
    if (widget.cartPayment != null) {
      amountController.text = widget.cartPayment?.paymentValue.toString() ??
          ref.read(cartNotiferProvider).grandTotal.toString();
      refController.text = widget.cartPayment!.reference ?? '';
      setState(() {
        amount = widget.cartPayment!.paymentValue;
      });
    }
    amountController.addListener(() {
      setState(() {
        amount = double.tryParse(amountController.text) ?? 0;
      });
    });
    super.initState();
  }

  void onSubmit() {
    ref.read(cartNotiferProvider.notifier).addPayment(
          CartPayment(
            paymentMethodId: widget.method.id,
            paymentName: widget.method.name,
            paymentValue: amount,
            reference: refController.text,
          ),
        );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? labelStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Colors.blueGrey.shade600);

    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        left: 15,
        right: 15,
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 15),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Colors.blueGrey.shade100,
                ),
              ),
            ),
            child: Text(
              'payment'.tr(args: [widget.method.name]),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          TextFormField(
            controller: amountController,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(left: 0, bottom: 15, right: 0),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              label: Text(
                'payment_amount'.tr(),
                style: labelStyle,
              ),
              prefix: Text(
                'payment_amount'.tr(),
                style: labelStyle,
              ),
              alignLabelWithHint: true,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color: Colors.blueGrey.shade100,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color: Colors.teal,
                ),
              ),
            ),
          ),
          TextFormField(
            controller: refController,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(left: 0, top: 15, right: 0, bottom: 15),
              // floatingLabelBehavior: FloatingLabelBehavior.never,
              label: Text(
                'payment_ref'.tr(),
                style: labelStyle,
              ),
              alignLabelWithHint: true,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color: Colors.blueGrey.shade100,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color: Colors.teal,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              TextButton(
                onPressed: () => context.pop(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey,
                ),
                child: Text('cancel'.tr()),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: amount <= 0 ? null : onSubmit,
                  icon: const Icon(CupertinoIcons.checkmark_alt),
                  label: Text(
                    CurrencyFormat.currency(amount),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
