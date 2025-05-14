import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AdjustmentStatusBadge extends StatelessWidget {
  const AdjustmentStatusBadge({
    super.key,
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
          color: status == 'approve'
              ? Colors.green
              : status == 'reject'
                  ? Colors.red
                  : Colors.blue,
          borderRadius: BorderRadius.circular(5)),
      child: Text(
        status == 'approve'
            ? 'approved'.tr()
            : status == 'reject'
                ? 'rejected'.tr()
                : 'new'.tr(),
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Colors.white),
      ),
    );
  }
}
