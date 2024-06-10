import 'package:easy_localization/easy_localization.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/ui/screens/checkout/discount_promotion/add_discount_overall.dart';
import 'package:selleri/utils/formater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscountItem extends ConsumerWidget {
  const DiscountItem({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = Theme.of(context).textTheme;

    void showDiscountOverall() {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return AddDiscountOverall(ref.read(cartNotiferProvider).subtotal);
          });
    }

    return Material(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: InkWell(
        onTap: showDiscountOverall,
        splashColor: Colors.blueGrey.shade50,
        highlightColor: Colors.blueGrey.shade100,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.percent,
                size: 14,
                color: Colors.red.shade700,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'discount_transaction'.tr(),
                style:
                    textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '-${CurrencyFormat.currency(ref.watch(cartNotiferProvider).discOverallTotal)}',
                  textAlign: TextAlign.right,
                  style: textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.blueGrey.shade300,
              )
            ],
          ),
        ),
      ),
    );
  }
}
