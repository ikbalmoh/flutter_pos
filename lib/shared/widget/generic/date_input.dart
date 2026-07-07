import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/shared/utils/formater.dart';

class DateInput extends StatelessWidget {
  const DateInput({
    super.key,
    required this.label,
    required this.onChange,
    this.firstDate,
    this.lastDate,
    this.value,
  });

  final String label;
  final DateTime? value;
  final Function(DateTime?) onChange;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    void pickDate() async {
      final date = await showDatePicker(
        context: context,
        firstDate: firstDate ?? DateTime.now(),
        lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365)),
        barrierLabel: label,
        initialDate: value ?? DateTime.now(),
      );
      onChange(date);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.blueGrey.shade600, fontWeight: FontWeight.w500),
        ),
        Stack(
          children: [
            Material(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(5),
              child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  splashColor: Colors.grey.shade50.withValues(alpha: 0.4),
                  onTap: pickDate,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      spacing: 8,
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: Colors.blueGrey.shade800,
                        ),
                        Text(
                          value != null
                              ? DateTimeFormater.dateToString(value!,
                                  format: 'd MMMM y')
                              : 'select_x'.tr(args: ['date'.tr()]),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.blueGrey.shade600),
                        )
                      ],
                    ),
                  )),
            ),
            if (value != null)
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => onChange(null),
                    icon: Icon(
                      Icons.clear,
                      size: 18,
                    )),
              )
          ],
        ),
      ],
    );
  }
}
