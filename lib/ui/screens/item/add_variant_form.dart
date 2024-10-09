import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/item_attribute_variant.dart';
import 'package:selleri/ui/components/generic/chip_input.dart';

class AddVariantForm extends StatefulWidget {
  const AddVariantForm({super.key});

  @override
  State<AddVariantForm> createState() => _AddVariantFormState();
}

class _AddVariantFormState extends State<AddVariantForm> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _chipFocusNode = FocusNode();

  String variantName = '';
  List<String> options = [];
  List<String> attributes = [];
  String? optionsError;

  Widget _chipBuilder(BuildContext context, String topping) {
    return VariantInputChip(
      topping: topping,
      onDeleted: _onChipDeleted,
      onSelected: (_) => {},
    );
  }

  void _onChipDeleted(String topping) {
    setState(() {
      options.remove(topping);
    });
  }

  void _onOptionsChanged(List<String> data) {
    setState(() {
      optionsError = null;
      options = data;
    });
  }

  void _onOptionSubmitted(String text) {
    log('submit options: $text');
    if (text.trim().isNotEmpty) {
      setState(() {
        optionsError = null;
        options = <String>[...options, text.trim()];
      });
    }
    _chipFocusNode.requestFocus();
  }

  void onSubmit() {
    setState(() {
      optionsError = null;
    });
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (options.isEmpty) {
      setState(() {
        optionsError =
            'field_cannot_empty'.tr(args: ['options'.tr().toLowerCase()]);
      });
      return;
    }
    context.pop(AttributeVariant(attrName: variantName, options: options));
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? labelStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Colors.blueGrey.shade600);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      height: MediaQuery.of(context).size.height *
          (MediaQuery.of(context).viewInsets.bottom > 0 ? 0.9 : 0.6),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 3, left: 5, right: 5),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'add_variant'.tr(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.close))
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          variantName = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'field_required'
                              .tr(args: ['variant_name'.tr().toLowerCase()]);
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              left: 0, bottom: 15, right: 0),
                          label: Text(
                            'variant_name'.tr(),
                            style: labelStyle,
                          ),
                          hintText: 'color, size'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'options'.tr(),
                      style: labelStyle,
                    ),
                    const SizedBox(height: 5),
                    ChipsInput<String>(
                      values: options,
                      chipBuilder: _chipBuilder,
                      onChanged: _onOptionsChanged,
                      onSubmitted: _onOptionSubmitted,
                      decoration: InputDecoration(
                        hintText: 'red, blue, S, M, L',
                        errorStyle:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: optionsError == null
                                      ? Colors.grey.shade600
                                      : Colors.red,
                                ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: optionsError == null
                                  ? Colors.grey.shade500
                                  : Colors.red,
                              width: 1),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: optionsError == null
                                  ? Colors.grey.shade500
                                  : Colors.red,
                              width: 1),
                        ),
                        errorText: optionsError ?? 'chip_input_note'.tr(),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                ),
                onPressed: onSubmit,
                child: Text(
                  'save'.tr(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class VariantInputChip extends StatelessWidget {
  const VariantInputChip({
    super.key,
    required this.topping,
    required this.onDeleted,
    required this.onSelected,
  });

  final String topping;
  final ValueChanged<String> onDeleted;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: InputChip(
        key: ObjectKey(topping),
        label: Text(topping),
        onDeleted: () => onDeleted(topping),
        onSelected: (bool value) => onSelected(topping),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(2),
      ),
    );
  }
}
