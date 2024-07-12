import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/outlet_config.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';

class PicPicker extends ConsumerWidget {
  const PicPicker({this.selected, super.key});

  final String? selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outletState = ref.watch(outletNotifierProvider).value;
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.only(
        top: 10,
        left: 0,
        right: 0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 8, left: 15, right: 15, bottom: 12),
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
              children: [
                Text(
                  'select_x'.tr(args: ['pic'.tr()]),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child: outletState is OutletSelected
                ? ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, idx) {
                      PersonInCharge pic = outletState.config.listUser![idx];
                      return ListTile(
                        title: Text(pic.name),
                        shape: Border(
                          bottom: BorderSide(
                            width: 0.5,
                            color: Colors.blueGrey.shade50,
                          ),
                        ),
                        onTap: () => context.pop(pic),
                        trailing: pic.id == selected
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.teal,
                              )
                            : null,
                      );
                    },
                    itemCount: outletState.config.listUser?.length ?? 0,
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}
