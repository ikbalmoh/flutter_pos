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
  TextEditingController refController = TextEditingController();

  final _formatter = CurrencyFormat.currencyInput();

  double amount = 0;

  @override
  void initState() {
    if (widget.cartPayment != null) {
      refController.text = widget.cartPayment!.reference ?? '';
    }
    double inititalValue = widget.cartPayment?.paymentValue ??
        ref.read(cartNotiferProvider).grandTotal -
            ref.read(cartNotiferProvider).totalPayment;
    setState(() {
      amount = inititalValue < 0 ? 0 : inititalValue;
    });
    super.initState();
  }

  void onDelete() {
    final payment = CartPayment(
      paymentMethodId: widget.method.id,
      paymentName: widget.method.name,
      paymentValue: 0,
    );
    context.pop(payment);
  }

  void onSubmit() {
    final payment = CartPayment(
      paymentMethodId: widget.method.id,
      paymentName: widget.method.name,
      paymentValue: amount,
      reference: refController.text,
    );
    context.pop(payment);
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
            padding: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Colors.blueGrey.shade100,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'payment'.tr(args: [widget.method.name]),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(CupertinoIcons.xmark),
                )
              ],
            ),
          ),
          TextFormField(
            inputFormatters: [_formatter],
            initialValue: _formatter.formatDouble(amount),
            onChanged: (_) => setState(() {
              amount = _formatter.getUnformattedValue().toDouble();
            }),
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
            ),
          ),
          TextFormField(
            controller: refController,
            decoration: InputDecoration(
              label: Text(
                'payment_ref'.tr(),
                style: labelStyle,
              ),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              widget.cartPayment != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: IconButton(
                        onPressed: onDelete,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                        ),
                        icon: const Icon(
                          CupertinoIcons.trash,
                          color: Colors.red,
                        ),
                      ),
                    )
                  : Container(),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: amount < 0 ? null : onSubmit,
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
