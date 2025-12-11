import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/features/table/model/table.dart';
import 'package:selleri/features/table/provider/tables_provider.dart';
import 'package:selleri/shared/widget/error_handler.dart';
import 'package:selleri/features/table/widget/components/table_item.dart';

class TableSelector extends ConsumerWidget {
  const TableSelector({super.key, this.selected, required this.onSelect});

  final Table? selected;
  final Function(Table?) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text('select_x'.tr(args: ['table'.tr()])),
        ),
        body: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            final width = constraints.maxWidth;
            final int gridColumn = width > 800
                ? 6
                : width > 600
                    ? 5
                    : width > 400
                        ? 4
                        : 3;
            return switch (ref.watch(tablesProvider())) {
              AsyncData(:final value) => GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridColumn,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    var table = value[index];
                    return TableItem(
                      table: table,
                      selected: selected?.id == table.id,
                      onSelect: (tbl) {
                        context.pop();
                        onSelect(selected?.id == table.id ? null : tbl);
                      },
                    );
                  },
                ),
              AsyncError(:final error, :final stackTrace) => ErrorHandler(
                  error: error.toString(),
                  stackTrace: stackTrace.toString(),
                ),
              _ => GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridColumn,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10)),
                    );
                  },
                )
            };
          }),
        ));
  }
}
