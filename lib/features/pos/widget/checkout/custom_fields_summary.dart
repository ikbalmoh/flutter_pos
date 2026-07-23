import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/features/cart/provider/cart_provider.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/shared/model/custom_field.dart';
import 'package:selleri/shared/utils/formater.dart';
import 'package:selleri/shared/widget/custom_fields_form.dart';

class CustomFieldsSummary extends ConsumerWidget {
  const CustomFieldsSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final customFieldsConfig =
        (ref.read(outletProvider).value as OutletSelected)
                .config
                .customFields
                ?.modules
                .transaction ??
            [];
    final customFields = cart.customFields ?? [];

    if (customFieldsConfig.isEmpty) {
      return const SizedBox.shrink();
    }

    final isSkipped = cart.skipCustomField;
    final hasValues = !isSkipped &&
        customFields.any(
            (f) => f.value != null && f.value.toString().trim().isNotEmpty);

    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.all(10),
      color: Colors.white,
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'additional_information'.tr(),
                    style: textTheme.bodyLarge,
                  ),
                ),
                SizedBox(
                  height: 35,
                  width: 45,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Switch(
                      value: !isSkipped,
                      onChanged: (v) => isSkipped
                          ? CustomFieldsForm(
                              title: 'additional_information'.tr(),
                              fields: customFields,
                              onValuesChange: (values) => ref
                                  .read(cartProvider.notifier)
                                  .setCustomField(values),
                              onSkip: () => ref
                                  .read(cartProvider.notifier)
                                  .setSkipCustomField(true),
                            ).show(context)
                          : ref
                              .read(cartProvider.notifier)
                              .setSkipCustomField(true),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (hasValues) ...[
            Divider(
              height: 1,
              color: Colors.blueGrey.shade50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: customFields
                    .where((f) =>
                        f.value != null && f.value.toString().trim().isNotEmpty)
                    .map((field) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  field.label,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Colors.blueGrey.shade500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  _formatValue(field),
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          ]
        ],
      ),
    );
  }

  String _formatValue(CustomField field) {
    final value = field.value;
    if (value == null) return '-';

    if (field.typeData == TypeData.boolean) {
      if (value is bool) return value ? 'yes'.tr() : 'no'.tr();
      final strVal = value.toString().toLowerCase();
      if (strVal == 'true' || strVal == '1') return 'yes'.tr();
      if (strVal == 'false' || strVal == '0') return 'no'.tr();
    }
    if (field.inputType == FieldType.date) {
      return DateTimeFormater.dateFromString(field.value as String,
          format: 'dd MMMM yyyy');
    }

    final strVal = value.toString().trim();
    return strVal.isEmpty ? '-' : strVal;
  }
}
