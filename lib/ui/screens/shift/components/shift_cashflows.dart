import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/shift_cashflow.dart';
import 'package:selleri/ui/components/shift/cashflow_item.dart';

class ShiftCashflows extends ConsumerWidget {
  const ShiftCashflows({required this.cashflows, this.onEdit, super.key});

  final List<ShiftCashflow> cashflows;
  final Function(ShiftCashflow)? onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'cashflow'.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 5),
        cashflows.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, idx) {
                  ShiftCashflow cashflow = cashflows[idx];
                  return CashflowItem(
                    cashflow: cashflow,
                    onTap: onEdit == null ? null : () => onEdit!(cashflow),
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

class ShiftCashflowsSkeleton extends ConsumerWidget {
  const ShiftCashflowsSkeleton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'cashflow'.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 5),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            CashflowItemSkeleton(),
            CashflowItemSkeleton(),
            CashflowItemSkeleton(),
            CashflowItemSkeleton(),
          ],
        ),
      ],
    );
  }
}
