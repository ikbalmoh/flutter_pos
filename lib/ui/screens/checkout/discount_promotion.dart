import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/utils/formater.dart';

class DiscountPromotion extends StatelessWidget {
  const DiscountPromotion({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.all(10),
      color: Colors.white,
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text('Discount & Promotion', style: textTheme.bodyLarge),
          ),
          Divider(
            height: 1,
            color: Colors.blueGrey.shade50,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30))
      ),
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
                'Discount Transaction',
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30))
      ),
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
                  'Add Promo Code',
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
