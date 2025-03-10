import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/table/table_stream_provider.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/screens/tables/select_floor_sheet.dart';

class TablesScreen extends ConsumerStatefulWidget {
  const TablesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TablesScreenState();
}

class _TablesScreenState extends ConsumerState<TablesScreen> {
  final ScrollController scrollController = ScrollController();

  void onSelectFloor() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => DraggableScrollableSheet(
        maxChildSize: 0.9,
        minChildSize: 0.4,
        initialChildSize: 0.6,
        expand: false,
        builder: (context, controller) {
          return SelectFloorSheet(
            scrollController: controller,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('select_table'.tr()),
        elevation: 5,
        actions: [
          IconButton(
            onPressed: onSelectFloor,
            icon: Badge.count(
              count: 1,
              child: Icon(CupertinoIcons.square_stack_3d_up),
            ),
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        final int gridColumn = width > 510
            ? 6
            : width > 400
                ? 5
                : 3;

        return switch (ref.watch(tableStreamProvider())) {
          AsyncData(:final value) => GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridColumn,
                mainAxisSpacing: 7.5,
                crossAxisSpacing: 8,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              controller: scrollController,
              itemCount: value.length,
              itemBuilder: (context, index) {
                var table = value[index];
                return Material(
                  borderRadius: BorderRadius.circular(10),
                  color: table.usedBy != null && table.usedBy != ''
                      ? Colors.red.shade300
                      : Colors.green.shade300,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          table.name,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.person_2_fill,
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'x_person'.tr(args: ['${table.capacity ?? '0'}']),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.white),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          AsyncError(:final error, :final stackTrace) => ErrorHandler(
              error: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          _ => const CircularProgressIndicator(),
        };
      }),
    );
  }
}
