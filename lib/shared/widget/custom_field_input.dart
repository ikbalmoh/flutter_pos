import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/shared/widget/generic/custom_text_input.dart';
import 'package:selleri/shared/widget/generic/date_input.dart';
import '../model/custom_field.dart' as model;

class CustomFieldInput extends StatelessWidget {
  const CustomFieldInput(
      {super.key, required this.field, this.onValueChange, this.value});

  final model.CustomField field;
  final ValueChanged<dynamic>? onValueChange;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    switch (field.inputType) {
      case model.FieldType.textBox:
        return CustomTextInput(
          label: field.label,
          initialValue: value,
          onChange: (value) => onValueChange?.call(value),
        );
      case model.FieldType.textArea:
        return CustomTextInput(
          label: field.label,
          initialValue: value,
          onChange: (value) => onValueChange?.call(value),
        );
      case model.FieldType.date:
        return DateInput(
          label: field.label,
          value: value,
          onChange: (value) => onValueChange?.call(value),
        );
      case model.FieldType.radioButton:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              field.label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.blueGrey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            RadioGroup<bool>(
              onChanged: (value) => onValueChange?.call(value),
              groupValue: value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IntrinsicWidth(
                    child: RadioListTile<bool>(
                      title: Text('yes'.tr()),
                      value: true,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  IntrinsicWidth(
                    child: RadioListTile<bool>(
                      title: Text('no'.tr()),
                      value: false,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
