import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart' hide Table;
import 'package:flutter/material.dart' hide Table;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/features/table/model/table.dart';
import 'package:selleri/features/table/provider/tables_provider.dart';
import 'package:selleri/shared/utils/app_alert.dart';

class SelectTableSheet extends ConsumerWidget {
  const SelectTableSheet({
    super.key,
    required this.table,
    required this.onPickTable,
    required this.onEditTable,
    required this.onDeleteTable,
  });

  final Table table;
  final Function(Table) onPickTable;
  final Function(Table) onEditTable;
  final Function(Table) onDeleteTable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onConfirmDelete() {
      context.pop();
      AppAlert.confirm(
        context,
        title: '${'delete_x'.tr(args: ['table'.tr()])} ${table.name}',
        subtitle: 'are_you_sure'.tr(),
        danger: true,
        onConfirm: () => onDeleteTable(table),
      );
    }

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Colors.grey.shade300,
                ),
              )),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Text(
                        table.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('x_person'.tr(args: ['${table.capacity ?? '0'}']),
                          style: Theme.of(context).textTheme.bodyLarge),
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 1),
                        decoration: BoxDecoration(
                            color:
                                table.usedBy != null ? Colors.red : Colors.green,
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          table.usedBy ?? 'empty'.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.white),
                        ),
                      )
                    ],
                  )),
                  IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.grey.shade500,
                      ))
                ],
              ),
            ),
            table.usedBy != null && table.usedBy != ''
                ? Material(
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        context.pop();
                        ref.read(tablesProvider().notifier).clearTable(table);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.cleaning_services_rounded,
                              color: Colors.amber,
                            ),
                            Expanded(
                              child: Text('clear'.tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.amber)),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Material(
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        context.pop();
                        onPickTable(table);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.blue,
                            ),
                            Expanded(
                                child: Text('use_table_x'.tr(args: ['']),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.blue)))
                          ],
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              height: 5,
            ),
            Material(
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  context.pop();
                  onEditTable(table);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                      ),
                      Expanded(
                          child: Text(
                        'edit'.tr(args: ['table'.tr()]),
                        textAlign: TextAlign.center,
                      ))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Material(
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: onConfirmDelete,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.trash,
                        color: Colors.red,
                      ),
                      Expanded(
                          child: Text(
                        'delete_x'.tr(args: ['table'.tr()]),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
