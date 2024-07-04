import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/shift_cashflow.dart';
import 'package:selleri/ui/components/generic/item_list_skeleton.dart';
import 'package:selleri/ui/components/shift/cashflow_item.dart';

class ShiftCashflows extends ConsumerWidget {
  const ShiftCashflows(
      {required this.cashflows, this.onEdit, this.withoutLabel, super.key});

  final List<ShiftCashflow> cashflows;
  final Function(ShiftCashflow)? onEdit;
  final bool? withoutLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        withoutLabel == true
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
                child: Text(
                  'cashflow'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.grey.shade600),
                ),
              ),
        cashflows.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, idx) {
                  ShiftCashflow cashflow = cashflows[idx];
                  final editable = onEdit != null && cashflow.approval == 'new';

                  return CashflowItem(
                    cashflow: cashflow,
                    onTap: !editable ? null : () => onEdit!(cashflow),
                    editable: editable,
                  );
                },
                itemCount: cashflows.length,
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.doc,
                      size: 60,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'no_data'.tr(args: ['cashflow'.tr()]),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Colors.grey.shade400),
                    )
                  ],
                ),
              ),
      ],
    );
  }
}
