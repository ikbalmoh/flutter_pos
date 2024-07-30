import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DatePicker extends ConsumerStatefulWidget {
  const DatePicker({this.initialForm, this.initialTo, super.key});

  final DateTime? initialForm;
  final DateTime? initialTo;

  @override
  ConsumerState<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends ConsumerState<DatePicker> {
  DateTime? from;
  DateTime? to;

  @override
  void initState() {
    setState(() {
      from = widget.initialForm;
      to = widget.initialTo;
    });
    super.initState();
  }

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
                  'select_x'.tr(args: ['date'.tr()]),
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
            initialSelectedRanges: [
              PickerDateRange(widget.initialForm, widget.initialTo)
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: from != null ? () => context.pop([from, to]) : null,
            child: Text('apply'.tr()),
          )
        ],
      ),
    );
  }
}
