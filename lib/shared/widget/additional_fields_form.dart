import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/shared/model/custom_field.dart' as model;
import 'package:selleri/shared/widget/custom_field_input.dart';

class AdditionalFieldsForm extends StatelessWidget {
  const AdditionalFieldsForm({
    super.key,
    required this.fields,
    this.values = const [],
    this.onValuesChange,
    this.onSkip,
    this.title,
  });

  final List<model.CustomField> fields;
  final List<model.CustomField> values;
  final String? title;
  final ValueChanged<List<model.CustomField>>? onValuesChange;
  final VoidCallback? onSkip;

  void show(BuildContext context) {
    final sheetController = DraggableScrollableController();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        useSafeArea: true,
        builder: (context) {
          return DraggableScrollableSheet(
            controller: sheetController,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) => _AdditionalFieldsSheet(
              initialFields: fields,
              values: values,
              onValuesChange: onValuesChange,
              onSkip: onSkip,
              title: title,
              scrollController: scrollController,
              draggableController: sheetController,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class _AdditionalFieldsSheet extends StatefulWidget {
  const _AdditionalFieldsSheet({
    required this.initialFields,
    this.values = const [],
    this.onValuesChange,
    this.onSkip,
    this.title,
    this.scrollController,
    this.draggableController,
  });

  final List<model.CustomField> initialFields;
  final List<model.CustomField> values;
  final ValueChanged<List<model.CustomField>>? onValuesChange;
  final VoidCallback? onSkip;
  final String? title;
  final ScrollController? scrollController;
  final DraggableScrollableController? draggableController;

  @override
  State<_AdditionalFieldsSheet> createState() => _AdditionalFieldsSheetState();
}

class _AdditionalFieldsSheetState extends State<_AdditionalFieldsSheet> {
  late List<model.CustomField> fields;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fields = List.from(widget.initialFields);
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    if (isKeyboardVisible &&
        widget.draggableController != null &&
        widget.draggableController!.isAttached) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.draggableController!.isAttached &&
            widget.draggableController!.size < 0.9) {
          widget.draggableController!.animateTo(
            0.9,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }

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
                    final fieldValue = widget.values
                        .firstWhereOrNull((v) => v.id == field.id)
                        ?.value;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: CustomFieldInput(
                        field: field,
                        value: fieldValue.toString(),
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
                      widget.onSkip?.call();
                    },
                    child: Text('skip'.tr())),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        widget.onValuesChange?.call(fields);
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
