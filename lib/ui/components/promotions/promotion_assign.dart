import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/customer_group.dart';
import 'package:selleri/data/models/promotion.dart';

class PromotionAssign extends StatelessWidget {
  const PromotionAssign({
    super.key,
    required this.assignCustomer,
    this.groups,
  });

  final int assignCustomer;
  final List<CustomerGroup>? groups;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3), color: Colors.blue.shade50),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            assignCustomer == 4
                ? CupertinoIcons.person_2_fill
                : assignCustomer == 3
                    ? CupertinoIcons.person
                    : assignCustomer == 2
                        ? CupertinoIcons.person_crop_rectangle_fill
                        : CupertinoIcons.person_3,
            size: 16,
            color: Colors.blue.shade600,
          ),
          const SizedBox(width: 10),
          Text(
            assignCustomer == 4
                ? groups!.map((group) => group.groupName).join(', ')
                : Promotion.assignsType[assignCustomer]!,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.blue.shade600),
          ),
        ],
      ),
    );
  }
}
