import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selleri/utils/formater.dart';

class DiscountPromotion extends StatelessWidget {
  const DiscountPromotion({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text('discount_&_promotion'.tr, style: textTheme.bodyLarge),
          ),
          Divider(
            height: 1,
            color: Colors.blueGrey.shade50,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.blueGrey.shade100),
              ),
            ),
            child: const Column(
              children: [DiscountItem(), PromotionItem()],
            ),
          )
        ],
      ),
    );
  }
}

class DiscountItem extends StatelessWidget {
  const DiscountItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Material(
      child: InkWell(
        onTap: () {},
        splashColor: Colors.blueGrey.shade50,
        highlightColor: Colors.blueGrey.shade100,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.percent,
                size: 14,
                color: Colors.red.shade700,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'discount_transaction'.tr.capitalize!,
                style: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '-${CurrencyFormat.currency(0)}',
                  textAlign: TextAlign.right,
                  style:
                      textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.blueGrey.shade300,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PromotionItem extends StatelessWidget {
  const PromotionItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Material(
      child: InkWell(
        splashColor: Colors.blueGrey.shade50,
        highlightColor: Colors.blueGrey.shade100,
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                CupertinoIcons.tag,
                size: 14,
                color: Colors.amber.shade700,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  'add_promotion_code'.tr.capitalize!,
                  style: textTheme.bodyMedium
                      ?.copyWith(color: Colors.grey.shade700),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.blueGrey.shade300,
              )
            ],
          ),
        ),
      ),
    );
  }
}
