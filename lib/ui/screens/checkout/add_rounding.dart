import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/utils/formater.dart';
import 'package:selleri/utils/helpers.dart';

class AddRounding extends ConsumerStatefulWidget {
  const AddRounding({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddRoundingState();
}

class _AddRoundingState extends ConsumerState<AddRounding> {
  final formKey = GlobalKey<FormState>();

  TextEditingController roundingController = TextEditingController();

  final _totalFormatter = CurrencyFormat.currencyInput(decimalDigit: 2);
  final _roundingFormatter = CurrencyFormat.currencyInput(decimalDigit: 0);

  double roundingValue = 0;
  String? validation;

  @override
  void initState() {
    final cart = ref.read(cartProvider);
    double initialRounding = cart.roundingValue == 0
        ? Helpers().ceilToNearestIDR(cart.total)
        : cart.total + cart.roundingValue;
    final roundingText = _roundingFormatter.formatDouble(initialRounding);
    setState(() {
      roundingValue = initialRounding - cart.total;
    });
    roundingController.text = roundingText;
    roundingController.selection =
        TextSelection(baseOffset: 0, extentOffset: roundingText.length);
    roundingController.addListener(() {
      double roundingTo = _roundingFormatter.getDouble();
      final double roundValue = roundingTo - cart.total;
      setState(() {
        roundingValue = roundValue;
        validation = roundValue >= -1000 && roundValue <= 1000
            ? null
            : 'max_round_message'.tr();
      });
    });
    super.initState();
  }

  void onSubmit() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    ref.read(cartProvider.notifier).setRoundingValue(roundingValue);
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
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding:
                  const EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 15),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 0.5,
                    color: Colors.blueGrey.shade100,
                  ),
                ),
              ),
              child: Text(
                'rounding'.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            TextFormField(
              inputFormatters: [_totalFormatter],
              initialValue:
                  _totalFormatter.formatDouble(ref.read(cartProvider).total),
              textAlign: TextAlign.right,
              keyboardType: TextInputType.number,
              enabled: false,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(left: 0, bottom: 15, right: 0),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                label: Text(
                  'total_transaction'.tr(args: ['']),
                  style: labelStyle,
                ),
                prefix: Text(
                  'total_transaction'.tr(args: ['']),
                  style: labelStyle,
                ),
                alignLabelWithHint: true,
              ),
            ),
            TextFormField(
              inputFormatters: [_roundingFormatter],
              textAlign: TextAlign.right,
              keyboardType: TextInputType.number,
              autofocus: true,
              validator: (value) => validation,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(left: 0, bottom: 15, right: 0),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                label: Text(
                  'round_to'.tr(),
                  style: labelStyle,
                ),
                prefix: Text(
                  'round_to'.tr(),
                  style: labelStyle,
                ),
                alignLabelWithHint: true,
              ),
              controller: roundingController,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
                  child: Text('cancel'.tr()),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                    onPressed: onSubmit,
                    child: Text(
                      "${'rounding'.tr()} ${CurrencyFormat.currency(roundingValue, decimalDigit: 2, minus: true)}",
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
