import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdjustmentDateFilter extends ConsumerStatefulWidget {
  const AdjustmentDateFilter(
      {super.key, this.from, this.to, required this.onSelect});

  final DateTime? from;
  final DateTime? to;
  final Function(DateTime? from, DateTime? to) onSelect;

  @override
  ConsumerState<AdjustmentDateFilter> createState() =>
      _AdjustmentDateFilterState();
}

class _AdjustmentDateFilterState extends ConsumerState<AdjustmentDateFilter> {
  DateTime? from;
  DateTime? to;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    log('${args.value}');
    PickerDateRange range = args.value;
    setState(() {
      from = range.startDate;
      to = range.endDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        left: 15,
        right: 15,
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Colors.blueGrey.shade100,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'adjustment_date'.tr(args: []),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(
                    Icons.close,
                    color: Colors.grey,
                    size: 18,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          SfDateRangePicker(
            backgroundColor: Colors.white,
            headerStyle:
                const DateRangePickerHeaderStyle(backgroundColor: Colors.white),
            view: DateRangePickerView.month,
            enableMultiView: false,
            selectionMode: DateRangePickerSelectionMode.extendableRange,
            maxDate: DateTime.now(),
            onSelectionChanged: _onSelectionChanged,
            initialSelectedRanges: [PickerDateRange(widget.from, widget.to)],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    context.pop();
                    widget.onSelect(null, null);
                  },
                  icon: const Icon(Icons.undo_sharp)),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: from != null
                      ? () {
                          context.pop();
                          widget.onSelect(from, to);
                        }
                      : null,
                  label: Text('apply'.tr()),
                  icon: const Icon(Icons.check),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
