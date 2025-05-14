import 'package:flutter/material.dart';

class ButtonSelection extends StatelessWidget {
  const ButtonSelection(
      {super.key,
      required this.label,
      required this.onSelect,
      required this.color,
      this.selected});

  final String label;
  final Function() onSelect;
  final Color color;
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 40,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          backgroundColor:
              selected == true ?  color.withValues(alpha: 0.15) : Colors.transparent,
          side: BorderSide(color: color),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
        ),
        onPressed: onSelect,
        child: Text(label),
      ),
    );
  }
}
