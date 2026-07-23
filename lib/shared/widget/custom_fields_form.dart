import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/shared/model/custom_field.dart' as model;
import 'package:selleri/shared/widget/custom_field_input.dart';

class CustomFieldsForm extends StatelessWidget {
  const CustomFieldsForm(
      {super.key,
      required this.fields,
      this.onValuesChange,
      this.onSkip,
      this.title});

  final List<model.CustomField> fields;
  final String? title;
  final ValueChanged<List<model.CustomField>>? onValuesChange;
  final VoidCallback? onSkip;

  void show(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        useSafeArea: true,
        builder: (context) {
          return DraggableScrollableSheet(
            minChildSize: 0.3,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) => _CustomFieldsSheet(
              initialFields: fields,
              onValuesChange: onValuesChange,
              onSkip: onSkip,
              title: title,
              scrollController: scrollController,
            ),
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
    this.onSkip,
    this.title,
    this.scrollController,
  });

  final List<model.CustomField> initialFields;
  final ValueChanged<List<model.CustomField>>? onValuesChange;
  final VoidCallback? onSkip;
  final String? title;
  final ScrollController? scrollController;

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
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        left: 15,
        right: 15,
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 12),
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
                    widget.title ?? 'additional_information'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => context.pop(),
                    visualDensity: VisualDensity.comfortable,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: widget.scrollController,
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
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
            Row(
              spacing: 10,
              children: [
                TextButton(
                    onPressed: () {
                      context.pop();
                      widget.onSkip?.call();
                    },
                    child: Text('skip'.tr())),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        widget.onValuesChange?.call(fields);
                        context.pop();
                      }
                    },
                    child: Text('save'.tr()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
