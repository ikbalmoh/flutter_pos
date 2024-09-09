import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PromotionTimes extends StatelessWidget {
  const PromotionTimes({
    super.key,
    required this.times,
  });

  final List<String> times;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    if (times.isEmpty) {
      return Container();
    }

    return Container(
      decoration: BoxDecoration(
          color: Colors.blueGrey.shade100,
          borderRadius: BorderRadius.circular(5)),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      margin: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            CupertinoIcons.clock_fill,
            size: 16,
          ),
          const SizedBox(width: 5),
          Text(
            times.map((time) => time).join(', '),
            style: textTheme.bodySmall?.copyWith(
                color: Colors.blueGrey.shade600, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
