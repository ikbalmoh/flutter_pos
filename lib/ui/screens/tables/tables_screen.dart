import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart' hide Table;
import 'package:flutter/material.dart' hide Table;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/data/models/table.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/table/tables_provider.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/screens/tables/add_table_dialog.dart';
import 'package:selleri/ui/screens/tables/edit_table_dialog.dart';
import 'package:selleri/ui/screens/tables/select_floor_menu.dart';
import 'package:selleri/ui/screens/tables/select_table_sheet.dart';
import 'package:selleri/utils/app_alert.dart';

class TablesScreen extends ConsumerStatefulWidget {
  const TablesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TablesScreenState();
}

class _TablesScreenState extends ConsumerState<TablesScreen> {
  final ScrollController scrollController = ScrollController();

  int currentFloor = 1;
  List<Table> selected = [];

  @override
  void initState() {
    initTable();
    super.initState();
  }

  void initTable() async {
    final cart = ref.read(cartProvider);
    final tables = cart.tables != null && cart.tables!.isNotEmpty
        ? await ref.read(tablesProvider().notifier).getTables(cart.tables!)
        : [];
    setState(() {
      selected = List.from(tables);
      currentFloor = tables.isNotEmpty ? tables[0].floor! : 1;
    });
  }

  void onPickTable(Table table, {bool? confirmed}) {
    List<Table> currentTables = List.from(selected);
    if (table.usedBy != null && table.usedBy != '' && confirmed != true) {
      AppAlert.confirm(
        context,
        title: 'table_in_use'.tr(),
        subtitle: 'empty_table_confirmation'.tr(),
        onConfirm: () => onPickTable(table, confirmed: true),
      );
      return;
    }
    currentTables.add(table);
    setState(() {
      selected = currentTables;
    });
  }

  void onDeleteTable(Table table) {
    ref.read(tablesProvider().notifier).deleteTable(table.id);
  }

  void onEditTable(Table table) {
    showDialog(
        context: context, builder: (context) => EditTableDialog(table: table));
  }

  void onSelectFloor(floor) {
    setState(() {
      currentFloor = floor;
    });
  }

  void onSelectTable(Table table) {
    List<Table> currentTables = List.from(selected);
    int existIndex = currentTables.indexWhere((tbl) => tbl.id == table.id);
    if (existIndex >= 0) {
      currentTables.removeAt(existIndex);
      setState(() {
        selected = currentTables;
      });
      return;
    }
    showModalBottomSheet(
        context: context,
        builder: (context) => SelectTableSheet(
              table: table,
              onPickTable: onPickTable,
              onEditTable: onEditTable,
              onDeleteTable: onDeleteTable,
            ),
        backgroundColor: Colors.white);
  }

  void onSubmit() {
    ref.read(cartProvider.notifier).setTables(selected);
    context.pop();
  }

  Widget newTable() => Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
        child: InkWell(
          onTap: () => showDialog(
              context: context,
              builder: (context) => AddTableDialog(
                    floor: currentFloor,
                  )),
          borderRadius: BorderRadius.circular(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.add,
                size: 22,
                color: Colors.blue.shade500,
              ),
              SizedBox(height: 5),
              Text(
                'add_table'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.blue.shade500,
                ),
              )
            ],
          ),
        ),
      );

  Material tableItem(Table table,
      {required TextTheme textTheme, bool? selected}) {
    Color backgroundColor = selected == true
        ? Colors.green.shade300
        : table.usedBy != null && table.usedBy != ''
            ? Colors.red.shade50
            : Colors.blue.shade50;
    Color textColor = selected == true
        ? Colors.white
        : table.usedBy != null && table.usedBy != ''
            ? Colors.red.shade500
            : Colors.blue.shade500;
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: backgroundColor,
      child: InkWell(
        onTap: () => onSelectTable(table),
        borderRadius: BorderRadius.circular(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              table.name,
              style: textTheme.titleLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.person_2_fill,
                  size: 14,
                  color: textColor,
                ),
                SizedBox(width: 5),
                Text(
                  'x_person'.tr(args: ['${table.capacity ?? '0'}']),
                  style: textTheme.bodySmall?.copyWith(color: textColor),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    List<String> selectedIndex = selected.map((tbl) => tbl.id).toList();

    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: Text('select_x'.tr(args: ['table'.tr()])),
        elevation: 5,
        actions: [
          TextButton.icon(
            onPressed: () => showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              builder: (context) => SelectFloorMenu(
                  floor: currentFloor,
                  onChange: (floor) {
                    context.pop();
                    onSelectFloor(floor);
                  }),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              iconColor: Colors.blue,
              backgroundColor: Colors.blue.shade50,
            ),
            label: Text('${'floor'.tr()} $currentFloor'),
            icon: Icon(
              CupertinoIcons.chevron_down,
              size: 14,
            ),
            iconAlignment: IconAlignment.end,
          ),
          SizedBox(width: 10)
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isTablet
              ? Container(
                  padding: const EdgeInsets.all(10).copyWith(right: 0),
                  width: 350,
                  child: SelectFloorMenu(
                    floor: currentFloor,
                    onChange: onSelectFloor,
                  ),
                )
              : Container(),
          Expanded(
            child: RefreshIndicator(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LayoutBuilder(builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final int gridColumn = width > 800
                          ? 6
                          : width > 600
                              ? 5
                              : width > 400
                                  ? 4
                                  : 3;
                      return switch (
                          ref.watch(tablesProvider(floor: currentFloor))) {
                        AsyncData(:final value) => GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: gridColumn,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(10),
                            controller: scrollController,
                            itemCount: value.length + 1,
                            itemBuilder: (context, index) {
                              if (index == value.length) {
                                return newTable();
                              }
                              var table = value[index];
                              return tableItem(table,
                                  selected: selectedIndex.contains(table.id),
                                  textTheme: textTheme);
                            },
                          ),
                        AsyncError(:final error, :final stackTrace) =>
                          ErrorHandler(
                            error: error.toString(),
                            stackTrace: stackTrace.toString(),
                          ),
                        _ => GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: gridColumn,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(10),
                            controller: scrollController,
                            itemCount: 12,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(10)),
                              );
                            },
                          ),
                      };
                    }),
                  ),
                ),
              ),
              onRefresh: () {
                ref.read(tablesProvider(floor: currentFloor).notifier).build();
                return Future.delayed(Durations.medium4);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onSubmit,
        label: Text(selected.isEmpty
            ? 'no_table'.tr()
            : 'use_table_x'
                .tr(args: [selected.map((tbl) => tbl.name).join(', ')])),
        icon: Icon(selected.isEmpty ? Icons.undo_rounded : Icons.check_rounded),
      ),
    );
  }
}
