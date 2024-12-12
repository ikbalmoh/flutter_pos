import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/adjustment_history.dart';
import 'package:selleri/ui/screens/adjustments/components/adjustment_status_badge.dart';

class AdjustmentHistoryItem extends StatelessWidget {
  final AdjustmentHistory adjustment;
  final Function(AdjustmentHistory) onSelect;
  final Color color;

  const AdjustmentHistoryItem({
    required this.adjustment,
    required this.onSelect,
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return ListTile(
      titleAlignment: ListTileTitleAlignment.top,
      title: Text(adjustment.adjustmentNo),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                CupertinoIcons.person_crop_circle,
                size: 16,
              ),
              const SizedBox(width: 5),
              Text(adjustment.createdName!),
            ],
          ),
          adjustment.description != null && adjustment.description != ''
              ? Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.text_quote,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        adjustment.description!,
                        style: textTheme.bodySmall
                            ?.copyWith(color: Colors.black54),
                      )
                    ],
                  ),
                )
              : Container()
        ],
      ),
      shape: Border(
        bottom: BorderSide(
          width: 0.5,
          color: Colors.blueGrey.shade50,
        ),
      ),
      onTap: () => onSelect(adjustment),
      tileColor: color,
      trailing: AdjustmentStatusBadge(status: adjustment.approval),
    );
  }
}
