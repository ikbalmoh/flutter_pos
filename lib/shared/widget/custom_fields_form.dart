import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/shared/model/custom_field.dart' as model;
import 'package:selleri/shared/widget/custom_field_input.dart';

class CustomFieldsForm extends StatelessWidget {
  const CustomFieldsForm(
      {super.key, required this.fields, this.onValuesChange, this.title});

  final List<model.CustomField> fields;
  final String? title;
  final ValueChanged<List<model.CustomField>>? onValuesChange;

  void show(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        useSafeArea: true,
        builder: (context) {
          return _CustomFieldsSheet(
            initialFields: fields,
            onValuesChange: onValuesChange,
            title: title,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class _CustomFieldsSheet extends StatefulWidget {
  const _CustomFieldsSheet({
    required this.initialFields,
    this.onValuesChange,
    this.title,
  });

  final List<model.CustomField> initialFields;
  final ValueChanged<List<model.CustomField>>? onValuesChange;
  final String? title;

  @override
  State<_CustomFieldsSheet> createState() => _CustomFieldsSheetState();
}

class _CustomFieldsSheetState extends State<_CustomFieldsSheet> {
  late List<model.CustomField> fields;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fields = List.from(widget.initialFields);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        height: MediaQuery.of(context).size.height * 0.8,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppBar(
                title: Text(widget.title ?? 'custom_field'.tr()),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => context.pop())
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: fields.map((field) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: CustomFieldInput(
                          field: field,
                          value: field.value,
                          onValueChange: (value) {
                            setState(() {
                              fields = fields.map((f) {
                                if (f.id == field.id) {
                                  return f.copyWith(value: value);
                                }
                                return f;
                              }).toList();
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    widget.onValuesChange?.call(fields);
                    context.pop();
                  }
                },
                child: Text('save'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
