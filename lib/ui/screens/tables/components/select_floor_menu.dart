import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/table/table_config_provider.dart';

class SelectFloorMenu extends ConsumerStatefulWidget {
  const SelectFloorMenu(
      {super.key, required this.onChange, required this.floor});

  final int floor;
  final Function(int) onChange;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectFloorMenuState();
}

class _SelectFloorMenuState extends ConsumerState<SelectFloorMenu> {
  int selected = 1;

  @override
  void initState() {
    setState(() {
      selected = widget.floor;
    });
    super.initState();
  }

  void onSelectFloor(int floor) {
    setState(() {
      selected = floor;
    });
    widget.onChange(floor);
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(tableConfigProvider);
    return Card(
      color: Colors.white,
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 17, right: 10, top: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'select_x'.tr(args: ['floor'.tr()]),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.settings), tooltip: 'setting'.tr(),)
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 15,
            ),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: config.value?.totalFloor ?? 1,
            itemBuilder: (context, index) {
              final floor = index + 1;
              return ListTile(
                onTap: () => onSelectFloor(floor),
                tileColor:
                    selected == floor ? Colors.blue.shade700 : Colors.white,
                textColor:
                    selected == floor ? Colors.white : Colors.grey.shade700,
                iconColor:
                    selected == floor ? Colors.white : Colors.grey.shade700,
                title: Text('${'floor'.tr()} $floor'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                trailing: const Icon(
                  CupertinoIcons.chevron_right,
                  size: 16,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
