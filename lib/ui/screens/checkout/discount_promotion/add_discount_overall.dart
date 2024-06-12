import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/ui/components/discount_type_toggle.dart';
import 'package:selleri/utils/formater.dart';

class AddDiscountOverall extends ConsumerStatefulWidget {
  final double subtotal;

  const AddDiscountOverall(this.subtotal, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddDiscountOverallState();
}

class _AddDiscountOverallState extends ConsumerState<AddDiscountOverall> {
  late double discount;
  late bool discountIsPercent;

  final _discountFormatter = CurrencyFormat.currencyInput();

  @override
  void initState() {
    final cart = ref.read(cartNotiferProvider);
    setState(() {
      discount = cart.discOverall;
      discountIsPercent = cart.discIsPercent;
    });
    super.initState();
  }

  void onChangeDiscountValue(String _) {
    final cart = ref.read(cartNotiferProvider);

    double disc = _discountFormatter.getUnformattedValue().toDouble();
    if (discountIsPercent && disc > 100) {
      disc = 100;
    } else if (!discountIsPercent && disc > cart.subtotal) {
      disc = cart.subtotal;
    }
    setState(() {
      discount = disc;
    });
  }

  void onChangeDiscountType() {
    bool isPercent = !discountIsPercent;
    double disc = isPercent && discount > 100 ? 100 : discount;
    setState(() {
      discountIsPercent = isPercent;
      discount = disc;
    });
  }

  double discountTotal() {
    if (discount > 0) {
      return discountIsPercent
          ? (widget.subtotal * (discount / 100))
          : discount;
    }
    return 0;
  }

  void onSubmit() {
    context.pop();
    ref.read(cartNotiferProvider.notifier).setDiscountTransaction(
          discount: discount,
          discIsPercent: discountIsPercent,
        );
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
              'discount_transaction'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          TextFormField(
            inputFormatters: [_discountFormatter],
            initialValue: _discountFormatter
                .formatDouble(ref.read(cartNotiferProvider).discOverall),
            onChanged: onChangeDiscountValue,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(left: 0, bottom: 15, right: 0),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              label: Text(
                'discount'.tr(),
                style: labelStyle,
              ),
              prefix: Text(
                'discount'.tr(),
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
              suffix: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: DiscountTypeToggle(
                  isPercent: discountIsPercent,
                  onChange: onChangeDiscountType,
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
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: onSubmit,
                  icon: const Icon(
                    CupertinoIcons.tag,
                    size: 16,
                  ),
                  label: Text(
                    '${'discount'.tr()} ${CurrencyFormat.currency(discountTotal())}',
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
    );
  }
}
