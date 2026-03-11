import 'package:flutter/material.dart';
import 'package:selleri/features/promotion/model/promotion.dart';
import 'package:selleri/features/promotion/widget/components/promotion_assign.dart';
import 'package:selleri/features/promotion/widget/components/promotion_date.dart';
import 'package:selleri/features/promotion/widget/components/promotion_incremental.dart';
import 'package:selleri/features/promotion/widget/components/promotion_policy.dart';
import 'package:selleri/features/promotion/widget/components/promotion_times.dart';
import 'package:selleri/features/promotion/widget/components/promotion_type_badge.dart';

class CartPromotionItem extends StatelessWidget {
  const CartPromotionItem({
    super.key,
    required this.promo,
    this.onSelect,
    required this.active,
    this.disabled,
  });

  final Promotion promo;
  final bool active;
  final bool? disabled;
  final Function(Promotion)? onSelect;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: disabled == true
          ? Colors.grey.shade200
          : active
              ? Colors.green.shade50
              : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        splashColor: Colors.green.shade50,
        onTap: disabled == true || onSelect == null
            ? null
            : () => onSelect!(promo),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color:
                      active ? Colors.green.shade200 : Colors.blueGrey.shade200,
                  width: 1),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.5, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    PromotionTypeBadge(type: promo.type),
                    if (promo.eligibleItems.isNotEmpty)
                      Wrap(
                        spacing: 7,
                        runSpacing: 6,
                        children: promo.eligibleItems
                            .map(
                              (e) => Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.shade50
                                      .withValues(alpha: 0.75),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2.5,
                                ),
                                child: Text(
                                  [e.itemName, e.variantName]
                                      .where((e) => e != null && e.isNotEmpty)
                                      .join(' - '),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.green.shade800),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    Text(
                      promo.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      promo.description ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w400, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.blueGrey.shade50.withValues(alpha: 0.5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 10,
                  runSpacing: 5,
                  children: [
                    PromotionAssign(
                        assignCustomer: promo.assignCustomer,
                        groups: promo.assignGroups),
                    PromotionPolicy(policy: promo.policy),
                    PromotionIncremental(incremental: promo.kelipatan),
                    PromotionDate(
                      allTime: promo.allTime,
                      startDate: promo.startDate,
                      endDate: promo.endDate,
                    ),
                    PromotionTimes(times: promo.times ?? []),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
