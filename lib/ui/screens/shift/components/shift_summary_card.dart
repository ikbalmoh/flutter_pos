import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/sold_item.dart';
import 'package:selleri/providers/shift/shift_info_provider.dart';
import 'package:selleri/ui/components/shift/sales_summary.dart';
import 'package:selleri/ui/components/shift/sold_items.dart';
import 'package:selleri/ui/components/summary_card.dart';
import 'package:selleri/utils/formater.dart';
import 'package:selleri/data/models/shift_summary.dart';

class ShiftSummaryCards extends ConsumerWidget {
  const ShiftSummaryCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onShowRecap(ShiftSummary summary) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          enableDrag: true,
          backgroundColor: Colors.white,
          builder: (context) {
            return SalesSummary(
              summary: summary,
            );
          });
    }

    void onShowSoldItems(List<SoldItem> items) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          enableDrag: true,
          backgroundColor: Colors.white,
          useSafeArea: false,
          builder: (context) {
            return SoldItems(
              items: items,
            );
          });
    }

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
                if (data == null) {
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
                        label: 'total_transaction'.tr(args: ['']),
                        value: CurrencyFormat.currency(data.summary.cashSales),
                        onTap: () => onShowRecap(data.summary),
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
                        onTap: () => onShowSoldItems(data.soldItems),
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
