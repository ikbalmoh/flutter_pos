import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/shift_info.dart';
import 'package:selleri/data/models/sold_item.dart';
import 'package:selleri/ui/components/shift/sales_summary.dart';
import 'package:selleri/ui/components/shift/sold_items.dart';
import 'package:selleri/ui/components/summary_card.dart';
import 'package:selleri/utils/formater.dart';
import 'package:selleri/data/models/shift_summary.dart';

class ShiftSummaryCards extends StatelessWidget {
  const ShiftSummaryCards({required this.shiftInfo, super.key});

  final ShiftInfo shiftInfo;

  @override
  Widget build(BuildContext context) {
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
        SingleChildScrollView(
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
                value: CurrencyFormat.currency(shiftInfo.summary.cashSales),
                onTap: () => onShowRecap(shiftInfo.summary),
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
                    shiftInfo.soldItems.isNotEmpty
                        ? shiftInfo.soldItems
                            .map((sold) => sold.sold)
                            .reduce((a, b) => a + b)
                        : 0,
                    symbol: false),
                onTap: () => onShowSoldItems(shiftInfo.soldItems),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }
}

class ShiftSummaryCardSkeleton extends StatelessWidget {
  const ShiftSummaryCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
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
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              SummaryCardSkeleton(),
              SizedBox(width: 10),
              SummaryCardSkeleton(),
            ],
          ),
        ),
      ],
    );
  }
}
