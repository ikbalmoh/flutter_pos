import 'package:flutter/material.dart';
import 'package:selleri/data/models/promotion.dart';
import 'package:selleri/ui/components/promotions/promotion_date.dart';
import 'package:selleri/ui/components/promotions/promotion_days.dart';
import 'package:selleri/ui/components/promotions/promotion_policy.dart';
import 'package:selleri/ui/components/promotions/promotion_type_badge.dart';

class CartPromotionItem extends StatelessWidget {
  const CartPromotionItem({
    super.key,
    required this.promo,
  });

  final Promotion promo;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        splashColor: Colors.green.shade50,
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(5)),
          padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      promo.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 3),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 10,
                      runSpacing: 5,
                      children: [
                        PromotionPolicy(policy: promo.policy),
                        PromotionDays(days: promo.days),
                        PromotionDate(
                          allTime: promo.allTime,
                          startDate: promo.startDate,
                          endDate: promo.endDate,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      promo.description ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w400, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              PromotionTypeBadge(type: promo.type)
            ],
          ),
        ),
      ),
    );
  }
}
