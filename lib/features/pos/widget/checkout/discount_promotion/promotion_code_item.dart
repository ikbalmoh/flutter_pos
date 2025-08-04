import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PromotionCodeItem extends StatelessWidget {
  const PromotionCodeItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
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
                      ?.copyWith(color: Colors.grey.shade800),
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
