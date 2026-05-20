import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/features/cart/model/cart_payment.dart';
import 'package:selleri/features/pos/model/payment_method.dart';
import 'package:selleri/shared/utils/formater.dart';

class PaymentForm extends StatefulWidget {
  final PaymentMethod method;
  final CartPayment? cartPayment;
  final double? insufficient;
  final bool isCash;
  const PaymentForm({
    super.key,
    required this.method,
    this.cartPayment,
    this.insufficient,
    this.isCash = false,
  });

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  TextEditingController refController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  final _formatter = CurrencyFormat.currencyInput();

  double amount = 0;

  @override
  void initState() {
    if (widget.cartPayment != null) {
      refController.text = widget.cartPayment!.reference ?? '';
    }
    double inititalValue =
        widget.cartPayment?.paymentValue ?? widget.insufficient ?? 0;
    setState(() {
      amount = inititalValue < 0 ? 0 : inititalValue;
    });

    final amountText = _formatter.formatDouble(amount);
    amountController.text = amountText;
    amountController.selection =
        TextSelection(baseOffset: 0, extentOffset: amountText.length);
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
                  'payment_x'.tr(args: [widget.method.name]),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(CupertinoIcons.xmark),
                )
              ],
            ),
          ),
          if (widget.isCash) ...[
            SizedBox(
              height: 10,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [10000, 20000, 50000, 100000]
                  .map(
                    (v) => TextButton(
                      onPressed: () {
                        amountController.text =
                            CurrencyFormat.currency(v, symbol: false);
                        setState(() {
                          amount = v.toDouble();
                        });
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: Colors.grey.shade50,
                      ),
                      child: Text(CurrencyFormat.currency(v)),
                    ),
                  )
                  .toList(),
            ),
          ],
          TextFormField(
            inputFormatters: [_formatter],
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
            controller: amountController,
            onTap: () => amountController.selection = TextSelection(
              baseOffset: 0,
              extentOffset: amountController.value.text.length,
            ),
          ),
          if (!widget.isCash)
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
              if (widget.cartPayment != null)
                Padding(
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
