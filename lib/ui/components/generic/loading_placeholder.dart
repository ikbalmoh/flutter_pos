import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/ui/widgets/loading_widget.dart';

class LoadingPlaceholder extends StatelessWidget {
  final String? label;

  const LoadingPlaceholder({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          const LoadingIndicator(color: Colors.teal),
          const SizedBox(height: 30),
          Text(
            label ?? 'please_wait'.tr(),
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
