import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/features/promotion/model/promotion.dart';
import 'package:selleri/features/promotion/widget/components/promotion_assign.dart';
import 'package:selleri/features/promotion/widget/components/promotion_date.dart';
import 'package:selleri/features/promotion/widget/components/promotion_days.dart';
import 'package:selleri/features/promotion/widget/components/promotion_policy.dart';
import 'package:selleri/features/promotion/widget/components/promotion_times.dart';
import 'package:selleri/features/promotion/widget/components/promotion_type_badge.dart';

class PromotionItem extends StatelessWidget {
  final Promotion promo;
  final bool isActive;
  const PromotionItem({required this.promo, this.isActive = false, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: isActive ? Colors.white : Colors.grey.shade100,
      shape: Border(
        bottom: BorderSide(
          width: 0.5,
          color: Colors.blueGrey.shade50,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 15,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PromotionTypeBadge(type: promo.type),
                if (promo.needCode)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        CupertinoIcons.tag_fill,
                        color: Colors.amber,
                        size: 12,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        promo.promoCode!,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: Colors.amber),
                      )
                    ],
                  ),
              ],
            ),
            Text(promo.name),
          ],
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          promo.description != null
              ? Text(
                  promo.description!,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.grey.shade600),
                )
              : Container(),
          const SizedBox(
            height: 5,
          ),
          Wrap(
            direction: Axis.horizontal,
            spacing: 10,
            runSpacing: 3,
            children: [
              PromotionAssign(
                assignCustomer: promo.assignCustomer,
                groups: promo.assignGroups,
              ),
              PromotionPolicy(policy: promo.policy),
              PromotionDays(days: promo.days),
              PromotionDate(
                allTime: promo.allTime,
                startDate: promo.startDate,
                endDate: promo.endDate,
              ),
              PromotionTimes(times: promo.times ?? [])
            ],
          ),
        ],
      ),
    );
  }
}
