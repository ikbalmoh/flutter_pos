import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/shift_cashflow.dart';
import 'package:selleri/providers/shift/shift_info_provider.dart';
import 'package:selleri/ui/components/shift/cashflow_item.dart';

class ShiftCashflows extends ConsumerWidget {
  const ShiftCashflows({super.key});

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
        ref.watch(shiftInfoNotifierProvider).when(
            data: (data) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, idx) {
                  ShiftCashflow cashflow = data!.cashFlows.data[idx];
                  return CashflowItem(
                    label: cashflow.codeCf,
                    value: cashflow.amount,
                    date: cashflow.transDate,
                    type: cashflow.status,
                  );
                },
                itemCount: data?.cashFlows.data.length,
              );
            },
            error: (error, _) {
              return Container();
            },
            loading: () => ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      CashflowItemSkeleton(),
                      CashflowItemSkeleton(),
                      CashflowItemSkeleton(),
                      CashflowItemSkeleton(),
                    ])),
      ],
    );
  }
}
