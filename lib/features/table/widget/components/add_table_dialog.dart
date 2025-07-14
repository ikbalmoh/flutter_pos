import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/features/table/provider/tables_provider.dart';
import 'package:selleri/shared/widget/generic/qty_editor.dart';

class AddTableDialog extends ConsumerStatefulWidget {
  const AddTableDialog({
    super.key,
    required this.floor,
  });

  final int floor;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTableDialogState();
}

class _AddTableDialogState extends ConsumerState<AddTableDialog> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  int capacity = 1;
  int floor = 1;
  String error = '';

  void onSubmit() async {
    setState(() {
      error = '';
    });
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      await ref.read(tablesProvider().notifier).addNewTable(
          name: nameController.text, capacity: capacity, floor: widget.floor);
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        context.pop();
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
      _formKey.currentState!.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? labelStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Colors.blueGrey.shade600);

    return Dialog(
      child: SizedBox(
        width: 350,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'add_table'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 0, top: 10, right: 0, bottom: 10),
                    label: Text(
                      'table_no'.tr(),
                      style: labelStyle,
                    ),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter_x'.tr(args: ['table_no'.tr()]);
                    }
                    if (error != '') {
                      return error;
                    }
                    return null;
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    width: 0.5,
                    color: Colors.blueGrey.shade100,
                  ))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'chair'.tr(),
                        style: labelStyle,
                      ),
                      QtyEditor(
                          qty: capacity.toDouble(),
                          min: 1,
                          onChange: (value) {
                            setState(() {
                              capacity = value.toInt();
                            });
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => context.pop(),
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.grey.shade700),
                      child: Text('cancel'.tr()),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: onSubmit,
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(999)),
                          ),
                        ),
                        child: Text('save'.tr()),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
