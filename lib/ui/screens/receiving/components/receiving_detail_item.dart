import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/receiving/receiving_detail.dart';
import 'package:selleri/ui/screens/receiving/components/receiving_status_badge.dart';

class ReceivingDetailItem extends StatelessWidget {
  final ReceivingDetail receiving;
  final Function(ReceivingDetail) onSelect;
  final Color color;

  const ReceivingDetailItem({
    required this.receiving,
    required this.onSelect,
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return ListTile(
      titleAlignment: ListTileTitleAlignment.top,
      title: Text(receiving.receiveNumber),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                receiving.type == 1
                    ? CupertinoIcons.cart_badge_plus
                    : CupertinoIcons.arrow_right_arrow_left_circle,
                size: 16,
              ),
              const SizedBox(width: 5),
              Text(receiving.typeName ?? '-'),
            ],
          ),
          receiving.descriptions != null && receiving.descriptions != ''
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
                        receiving.descriptions!,
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
      onTap: () => onSelect(receiving),
      tileColor: color,
      trailing: ReceivingStatusBadge(status: receiving.status),
    );
  }
}
