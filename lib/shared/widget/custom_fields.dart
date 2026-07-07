import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/shared/model/custom_field.dart' as model;
import 'package:selleri/shared/widget/custom_field_input.dart';

class CustomFields extends StatelessWidget {
  const CustomFields(
      {super.key, required this.fields, this.values, this.onValuesChange});

  final List<model.CustomField> fields;
  final Map<String, dynamic>? values;
  final ValueChanged<Map<String, dynamic>>? onValuesChange;

  void show(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        useSafeArea: true,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                AppBar(title: const Text('Add Custom Fields')),
                Expanded(
                  child: SingleChildScrollView(
                    child: fieldsWidgets,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: Text('save'.tr()),
                ),
              ],
            ),
          );
        });
  }

  Widget get fieldsWidgets => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: fields.map((field) {
          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: CustomFieldInput(
              field: field,
              value: values?[field.id],
              onValueChange: (value) {
                final updatedValues = Map<String, dynamic>.from(values ?? {});
                updatedValues[field.id] = value;
                onValuesChange?.call(updatedValues);
              },
            ),
          );
        }).toList(),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
