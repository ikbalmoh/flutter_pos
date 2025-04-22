import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/ui/screens/checkout/discount_promotion/add_voucher.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/formater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/ui/components/promotions/applied_voucher.dart';

class VoucherItem extends ConsumerWidget {
  const VoucherItem({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = Theme.of(context).textTheme;

    void showVoucherDialog() {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          backgroundColor: Colors.white,
          builder: (context) {
            return AddVoucher(ref.read(cartProvider).subtotal);
          });
    }

    void onRemoveVoucher() {
      AppAlert.confirm(
        context,
        title: 'delete_x'.tr(args: ['voucher'.tr()]),
        subtitle: 'are_you_sure'.tr(),
        onConfirm: () {
          ref.read(cartProvider.notifier).removeVoucher();
        },
        danger: true,
      );
    }

    return ref.watch(cartProvider).vouchers.isNotEmpty
        ? Material(
            color: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: InkWell(
              onTap: null,
              splashColor: Colors.blueGrey.shade50,
              highlightColor: Colors.blueGrey.shade50,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.ticket,
                              size: 14,
                              color: Colors.orange.shade700,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'voucher'.tr(),
                              style: textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey.shade800),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: onRemoveVoucher,
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...ref
                        .watch(cartProvider)
                        .vouchers
                        .map((voucher) => Padding(
                              padding:
                                  const EdgeInsets.only(left: 24, bottom: 4),
                              child: AppliedVoucher(voucher: voucher),
                            )),
                  ],
                ),
              ),
            ),
          )
        : Material(
            color: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: InkWell(
              onTap: showVoucherDialog,
              splashColor: Colors.blueGrey.shade50,
              highlightColor: Colors.blueGrey.shade50,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      CupertinoIcons.ticket,
                      size: 14,
                      color: Colors.orange.shade700,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'voucher'.tr(),
                      style: textTheme.bodyMedium
                          ?.copyWith(color: Colors.grey.shade800),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        CurrencyFormat.currency(
                          ref.watch(cartProvider).discOverallTotal,
                          minus: true,
                        ),
                        textAlign: TextAlign.right,
                        style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade600),
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
