import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class SelectFloorSheet extends ConsumerWidget {
  const SelectFloorSheet({super.key, this.scrollController});

  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            'select_x'.tr(args: ['floor'.tr()]),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 15),
          Expanded(
              child: ListView(
            controller: scrollController,
            shrinkWrap: true,
            children: [
              ListTile(
                leading: Icon(CupertinoIcons.circle),
                title: Text('floor 1'),
              )
            ],
          )),
          SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: () {},
            label: Text('add'.tr(args: ['floor'.tr()])),
            icon: Icon(CupertinoIcons.plus),
          )
        ],
      ),
    );
  }
}
