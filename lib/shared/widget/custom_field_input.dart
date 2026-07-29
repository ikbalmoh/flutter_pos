import 'dart:developer';

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
    String? validate(dynamic val) {
      if (field.isRequired) {
        if (val == null || val.toString().trim().isEmpty) {
          return 'field_cannot_empty'.tr(args: [field.label]);
        }
      }
      return null;
    }

    Widget labelWidget(BuildContext context, bool hasError) => Text.rich(
          TextSpan(
            text: field.label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: hasError
                      ? Theme.of(context).colorScheme.error
                      : Colors.blueGrey.shade600,
                  fontWeight: FontWeight.w500,
                ),
            children: [
              TextSpan(
                text: field.isRequired ? ' *' : '',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );

    switch (field.inputType) {
      case model.FieldType.textBox:
        return CustomTextInput(
          label: field.label,
          isRequired: field.isRequired,
          initialValue: value,
          onChange: (value) => onValueChange?.call(value),
          validator: validate,
          inputType: field.typeData == model.TypeData.numeric
              ? TextInputType.number
              : TextInputType.text,
        );
      case model.FieldType.textArea:
        return CustomTextInput(
          label: field.label,
          isRequired: field.isRequired,
          initialValue: value,
          onChange: (value) => onValueChange?.call(value),
          validator: validate,
          inputType: TextInputType.multiline,
          maxLines: 3,
          minLines: 2,
        );
      case model.FieldType.date:
        DateTime? dateValue;
        if (value is DateTime) {
          dateValue = value;
        } else if (value != null) {
          dateValue = DateTime.tryParse(value.toString());
        }

        return FormField<DateTime>(
          initialValue: dateValue,
          validator: validate,
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DateInput(
                  label: field.label,
                  value: dateValue,
                  onChange: (date) {
                    state.didChange(date);
                    onValueChange?.call(date?.toIso8601String());
                  },
                  firstDate:
                      DateTime.now().subtract(const Duration(days: 365 * 100)),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 100)),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 12),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      case model.FieldType.radioButton:
        bool? boolValue;
        if (value is bool) {
          boolValue = value;
        } else if (value != null && value.toString().isNotEmpty) {
          final str = value.toString().toLowerCase();
          boolValue = str == 'true' || str == '1';
        }

        return FormField<bool>(
          initialValue: boolValue,
          validator: validate,
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                labelWidget(context, state.hasError),
                RadioGroup<bool>(
                  onChanged: (val) {
                    log('select $val');
                    state.didChange(val);
                    onValueChange?.call(val);
                  },
                  groupValue: state.value,
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
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 12),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
