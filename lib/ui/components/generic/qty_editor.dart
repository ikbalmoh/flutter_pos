import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QtyEditor extends StatefulWidget {
  final int qty;
  final Function(int) onChange;

  const QtyEditor({super.key, required this.qty, required this.onChange});

  @override
  State<QtyEditor> createState() => _QtyEditorState();
}

class _QtyEditorState extends State<QtyEditor> {
  TextEditingController qtyController = TextEditingController();
  @override
  void initState() {
    qtyController.text = widget.qty.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: IconButton(
            onPressed:
                widget.qty > 0 ? () => widget.onChange(widget.qty - 1) : null,
            icon: const Icon(CupertinoIcons.minus),
            iconSize: 16,
            color: Colors.teal,
            padding: EdgeInsets.zero,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            widget.qty.toString(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        SizedBox(
          width: 22,
          height: 22,
          child: IconButton(
            onPressed: () => widget.onChange(widget.qty + 1),
            icon: const Icon(CupertinoIcons.add),
            iconSize: 16,
            color: Colors.teal,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
