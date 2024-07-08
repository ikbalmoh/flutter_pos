import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/utils/formater.dart';

class OpenShift extends ConsumerStatefulWidget {
  const OpenShift({super.key});

  @override
  ConsumerState<OpenShift> createState() => _OpenShiftState();
}

class _OpenShiftState extends ConsumerState<OpenShift> {
  final _amountFormater = CurrencyFormat.currencyInput();

  double amount = 0;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    OutletState? outletState = ref.read(outletNotifierProvider).value;
    num defaultAmount = outletState is OutletSelected
        ? (outletState.config.defaultOpenAmount ?? 0)
        : 0;
    setState(() {
      amount = defaultAmount.toDouble();
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
      title: Text('open_shift'.tr()),
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
              ref.read(shiftNotifierProvider.notifier).openShift(
                    amount,
                  );
              context.pop();
            },
            child: Text('start_shift'.tr())),
      ],
    );
  }
}
