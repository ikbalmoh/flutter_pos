import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart' hide Table;
import 'package:flutter/material.dart' hide Table;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/table.dart';

class TableItem extends ConsumerWidget {
  const TableItem(
      {super.key,
      required this.selected,
      required this.table,
      required this.onSelect});

  final Table table;
  final bool selected;
  final Function(Table) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color backgroundColor = selected == true
        ? Colors.green.shade300
        : table.usedBy != null && table.usedBy != ''
            ? Colors.red.shade50
            : Colors.blue.shade50;
    Color textColor = selected == true
        ? Colors.white
        : table.usedBy != null && table.usedBy != ''
            ? Colors.red.shade500
            : Colors.blue.shade500;

    TextTheme textTheme = Theme.of(context).textTheme;

    return Material(
      borderRadius: BorderRadius.circular(10),
      color: backgroundColor,
      child: InkWell(
        onTap: () => onSelect(table),
        borderRadius: BorderRadius.circular(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              table.name,
              style: textTheme.titleLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.person_2_fill,
                  size: 14,
                  color: textColor,
                ),
                SizedBox(width: 5),
                Text(
                  'x_person'.tr(args: ['${table.capacity ?? '0'}']),
                  style: textTheme.bodySmall?.copyWith(color: textColor),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
