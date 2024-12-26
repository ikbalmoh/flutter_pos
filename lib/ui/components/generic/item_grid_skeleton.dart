import 'package:flutter/material.dart';

class ItemGridSkeleton extends StatelessWidget {
  const ItemGridSkeleton({super.key, this.leading});

  final bool? leading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(5)),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 70,
            height: 20,
            decoration: BoxDecoration(
                color: Colors.blueGrey.shade50.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(5)),
          ),
        ],
      ),
    );
  }
}
