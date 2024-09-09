import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/utils/formater.dart';

class EditOpenAmount extends StatefulWidget {
  const EditOpenAmount({required this.openAmount, super.key});

  final double openAmount;

  @override
  State<EditOpenAmount> createState() => _EditOpenAmountState();
}

class _EditOpenAmountState extends State<EditOpenAmount> {
  final _amountFormater = CurrencyFormat.currencyInput();

  double amount = 0;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    setState(() {
      amount = widget.openAmount;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? labelStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Colors.blueGrey.shade600);

    return AlertDialog(
      title: Text('edit_open_amount'.tr()),
      content: TextFormField(
        inputFormatters: [_amountFormater],
        initialValue: _amountFormater.formatDouble(amount),
        onChanged: (value) {
          setState(() {
            amount = _amountFormater.getUnformattedValue().toDouble();
          });
        },
        textAlign: TextAlign.right,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 0, bottom: 15, right: 0),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          label: Text(
            'starting_cash'.tr(),
            style: labelStyle,
          ),
          prefix: Text(
            'starting_cash'.tr(),
            style: labelStyle,
          ),
          alignLabelWithHint: true,
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          style: TextButton.styleFrom(foregroundColor: Colors.grey),
          child: Text('cancel'.tr()),
        ),
        TextButton(
            onPressed: () {
              context.pop(amount);
            },
            child: Text('update'.tr())),
      ],
    );
  }
}
