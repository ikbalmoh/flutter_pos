import 'package:flutter/material.dart';

class DiscountTypeToggle extends StatefulWidget {
  final bool isPercent;
  final bool? disabled;
  final Function? onChange;
  const DiscountTypeToggle({
    super.key,
    required this.isPercent,
    this.disabled,
    this.onChange,
  });

  @override
  State<DiscountTypeToggle> createState() => _DiscountTypeToggleState();
}

class _DiscountTypeToggleState extends State<DiscountTypeToggle> {
  @override
  Widget build(BuildContext context) {
    Color activeColor =
        widget.disabled == true ? Colors.grey.shade500 : Colors.teal;
    return InkWell(
      onTap: widget.onChange == null || widget.disabled == true
          ? null
          : () => widget.onChange!(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: widget.isPercent ? activeColor : Colors.white,
              border: Border.all(color: activeColor, width: 1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Text(
              '%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: widget.isPercent ? Colors.white : activeColor),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: widget.isPercent ? Colors.white : activeColor,
              border: Border.all(color: activeColor, width: 1),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Text(
              'Rp',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: widget.isPercent ? activeColor : Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
