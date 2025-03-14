import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/table.dart';
import 'package:selleri/providers/table/tables_provider.dart';
import 'package:selleri/ui/components/generic/qty_editor.dart';

class EditTableDialog extends ConsumerStatefulWidget {
  const EditTableDialog({
    super.key,
    required this.table,
  });

  final Table table;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditTableDialogState();
}

class _EditTableDialogState extends ConsumerState<EditTableDialog> {
  final _formKey = GlobalKey<FormState>();

  int capacity = 1;
  int floor = 1;
  String error = '';

  @override
  void initState() {
    setState(() {
      capacity = widget.table.capacity ?? 2;
      floor = widget.table.floor ?? 1;
    });
    super.initState();
  }

  void onSubmit() async {
    setState(() {
      error = '';
    });
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      ref
          .read(tablesProvider().notifier)
          .editTable(widget.table.id, capacity: capacity);
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
                  '${'edit'.tr(args: ['table'.tr()])} ${widget.table.name}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 15,
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
                          qty: capacity,
                          min: 1,
                          onChange: (value) {
                            setState(() {
                              capacity = value;
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
