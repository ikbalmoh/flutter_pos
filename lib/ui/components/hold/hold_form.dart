import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/formater.dart';

class HoldForm extends ConsumerStatefulWidget {
  final Function()? onHolded;
  const HoldForm({this.onHolded, super.key});

  @override
  ConsumerState<HoldForm> createState() => _HoldFormState();
}

class _HoldFormState extends ConsumerState<HoldForm> {
  final GlobalKey<_HoldFormState> holdWidgetKey = GlobalKey();

  String description = '';

  bool holding = false;

  @override
  void initState() {
    setState(() {
      description = ref.read(cartNotiferProvider).description ?? '';
    });
    super.initState();
  }

  void onHold(bool createNew) async {
    final context = holdWidgetKey.currentContext;

    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      holding = true;
    });

    try {
      await ref
          .read(cartNotiferProvider.notifier)
          .holdCart(note: description, createNew: createNew);

      AppAlert.toast('transaction_holded'.tr());

      if (widget.onHolded != null) {
        widget.onHolded!();
      } else if (context != null && context.mounted) {
        while (context.canPop()) {
          context.pop();
        }
      }
    } on Exception catch (e) {
      log('HOLD ERROR: ${e.toString()}');
      AppAlert.toast(e.toString());
    } finally {
      setState(() {
        holding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return PopScope(
      key: holdWidgetKey,
      canPop: !holding,
      child: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ref.read(cartNotiferProvider).holdAt == null
                      ? '${'hold_current_transaction'.tr()}?'
                      : '${'update_current_transaction'.tr()}?',
                  style: textTheme.headlineSmall,
                ),
                IconButton(
                    onPressed: holding ? null : () => context.pop(),
                    icon: Icon(
                      Icons.close,
                      color:
                          holding ? Colors.grey.shade400 : Colors.grey.shade700,
                    ))
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'total_transaction'.tr(args: [
                CurrencyFormat.currency(
                    ref.read(cartNotiferProvider).grandTotal)
              ]),
              style: textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: ref.read(cartNotiferProvider).description,
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    left: 0, top: 15, right: 0, bottom: 15),
                label: Text(
                  'note'.tr(),
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
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: holding
                  ? [
                      TextButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                        ),
                        onPressed: null,
                        icon: const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.grey,
                          ),
                        ),
                        label: Text('holding_transaction'.tr()),
                      )
                    ]
                  : [
                      widget.onHolded != null
                          ? Flexible(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                ),
                                onPressed: widget.onHolded,
                                child: Text(
                                  'no'.tr(),
                                ),
                              ),
                            )
                          : Flexible(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                ),
                                onPressed: description.length >= 3
                                    ? () => onHold(true)
                                    : null,
                                child: Text(
                                  ref.read(cartNotiferProvider).holdAt == null
                                      ? 'hold_new'.tr()
                                      : 'update_new'.tr(),
                                ),
                              ),
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                          ),
                          onPressed: description.length >= 3 && !holding
                              ? () => onHold(false)
                              : null,
                          child: Text(
                              ref.read(cartNotiferProvider).holdAt == null
                                  ? 'hold'.tr()
                                  : 'update'.tr()),
                        ),
                      ),
                    ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
