import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selleri/utils/formater.dart';

class QtyEditor extends StatefulWidget {
  final int qty;
  final int? max;
  final Function(int) onChange;

  const QtyEditor(
      {super.key, required this.qty, required this.onChange, this.max});

  @override
  State<QtyEditor> createState() => _QtyEditorState();
}

class _QtyEditorState extends State<QtyEditor> {
  TextEditingController qtyController = TextEditingController();
  double qty = 0;
  final _qtyFormater = CurrencyFormat.currencyInput();

  @override
  void initState() {
    super.initState();
    setState(() {
      qty = widget.qty.toDouble();
    });
    qtyController.text = _qtyFormater.formatDouble(widget.qty.toDouble());
  }

  void onChangeQty(value) {
    double value = _qtyFormater.getUnformattedValue().toDouble();
    if (widget.max != null && value > widget.max!) {
      value = widget.max!.toDouble();
    }
    setState(() {
      qty = value;
    });
    widget.onChange(value.toInt());
  }

  void onIncreaseQty(bool increase) {
    double value = increase ? qty + 1 : qty - 1;
    if (widget.max != null && value > widget.max!) {
      return;
    }
    setState(() {
      qty = value;
    });
    qtyController.text = CurrencyFormat.currency(value, symbol: false);
    widget.onChange(value.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey.shade200,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 25,
            height: 25,
            child: IconButton(
              onPressed: widget.qty > 0 ? () => onIncreaseQty(false) : null,
              icon: const Icon(CupertinoIcons.minus),
              iconSize: 16,
              color: Colors.teal,
              padding: const EdgeInsets.all(3),
              constraints: const BoxConstraints(),
              style: IconButton.styleFrom(backgroundColor: Colors.teal.shade50),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: IntrinsicWidth(
              child: TextFormField(
                inputFormatters: <TextInputFormatter>[_qtyFormater],
                controller: qtyController,
                onChanged: onChangeQty,
                onTap: () => qtyController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: qtyController.value.text.length,
                ),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 25,
            height: 25,
            child: IconButton(
              onPressed: () => onIncreaseQty(true),
              icon: const Icon(CupertinoIcons.add),
              iconSize: 16,
              color: Colors.teal,
              padding: const EdgeInsets.all(3),
              constraints: const BoxConstraints(),
              style: IconButton.styleFrom(backgroundColor: Colors.teal.shade50),
            ),
          ),
        ],
      ),
    );
  }
}
