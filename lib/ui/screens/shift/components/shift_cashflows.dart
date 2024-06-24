import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/shift_cashflow.dart';
import 'package:selleri/ui/components/shift/cashflow_item.dart';

class ShiftCashflows extends ConsumerWidget {
  const ShiftCashflows({required this.cashflows, super.key});

  final List<ShiftCashflow> cashflows;

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
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, idx) {
            ShiftCashflow cashflow = cashflows[idx];
            return CashflowItem(
              label: cashflow.codeCf,
              value: cashflow.amount,
              date: cashflow.transDate,
              type: cashflow.status,
            );
          },
          itemCount: cashflows.length,
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
