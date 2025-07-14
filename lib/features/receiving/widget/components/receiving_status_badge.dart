import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ReceivingStatusBadge extends StatelessWidget {
  const ReceivingStatusBadge({
    super.key,
    required this.status,
  });

  final int status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
          color: status == 1
              ? Colors.green
              : status == 2
                  ? Colors.red
                  : Colors.blue,
          borderRadius: BorderRadius.circular(5)),
      child: Text(
        status == 1
            ? 'done'.tr()
            : status == 2
                ? 'canceled'.tr()
                : 'new'.tr(),
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Colors.white),
      ),
    );
  }
}
