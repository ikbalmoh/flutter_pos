import 'package:flutter/material.dart';

class Switcher extends StatelessWidget {
  const Switcher({super.key, required this.options});

  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.teal,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(22),
        color: Colors.teal,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: InkWell(
            onTap: () {},
            highlightColor: Colors.teal,
            borderRadius: BorderRadius.circular(22),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: Text(
                options[0],
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
