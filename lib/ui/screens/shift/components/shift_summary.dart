import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/shift/shift_info_provider.dart';
import 'package:selleri/ui/components/summary_card.dart';
import 'package:selleri/utils/formater.dart';

class ShiftSummary extends ConsumerWidget {
  const ShiftSummary({super.key});

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
            'summary'.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 10),
        ref.watch(shiftInfoNotifierProvider).when(
              data: (data) {
                if(data == null) {
                  return Container();
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      SummaryCard(
                        icon: const Icon(
                          Icons.bar_chart_rounded,
                          color: Colors.purple,
                        ),
                        color: Colors.purple.shade50,
                        label: 'total_sales'.tr(),
                        value: CurrencyFormat.currency(data.summary.cashSales),
                      ),
                      const SizedBox(width: 10),
                      SummaryCard(
                        icon: const Icon(
                          Icons.shopping_cart_rounded,
                          color: Colors.green,
                        ),
                        color: Colors.green.shade50,
                        label: 'item_sold'.tr(),
                        value: CurrencyFormat.currency(
                            data.soldItems
                                .map((sold) => sold.sold)
                                .reduce((a, b) => a + b),
                            symbol: false),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                );
              },
              error: (error, _) => Container(),
              loading: () => const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      SummaryCardSkeleton(),
                      SizedBox(width: 10),
                      SummaryCardSkeleton(),
                    ],
                  )),
            ),
      ],
    );
  }
}
