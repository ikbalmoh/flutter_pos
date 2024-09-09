import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/promotion.dart';

class PromotionTypeFilter extends StatelessWidget {
  const PromotionTypeFilter({required this.selected, super.key});

  final int selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: PromotionType.filter()
            .map(
              (type) => ListTile(
                minLeadingWidth: 0,
                dense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                horizontalTitleGap: -7,
                title: Text(type.name),
                leading: Radio<int>(
                  visualDensity: const VisualDensity(horizontal: 0),
                  value: type.id,
                  groupValue: selected,
                  onChanged: (value) {
                    context.pop(value);
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
