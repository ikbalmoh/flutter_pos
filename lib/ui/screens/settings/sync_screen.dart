import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/item/item_provider.dart';
import 'package:selleri/utils/app_alert.dart';

class SyncScreen extends StatelessWidget {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sync_data'.tr()),
      ),
      body: const SyncData(),
    );
  }
}

class SyncData extends ConsumerStatefulWidget {
  const SyncData({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SyncDataState();
}

class _SyncDataState extends ConsumerState<SyncData> {
  bool inSync = false;
  String syncStatus = '';

  Map<String, bool> selected = {
    'categories': false,
    'items': false,
    'promotions': false,
  };

  void onSelectItem(String key, bool value) {
    setState(() {
      selected[key] = value;
    });
  }

  void runSync() async {
    setState(() {
      inSync = true;
    });
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return const Dialog(
    //           child: Center(
    //         child: SizedBox(
    //           width: 20,
    //           height: 20,
    //           child: CircularProgressIndicator(),
    //         ),
    //       ));
    //     });
    try {
      if (selected['items'] == true || selected['promotions'] == true) {
        await ref.read(itemsStreamProvider().notifier).loadItems(
              refresh: true,
              fullSync: true,
              progressCallback: (progress) => setState(() {
                syncStatus = progress;
              }),
            );
      } else if (selected['categories'] == true) {
        await ref.read(itemsStreamProvider().notifier).syncCategories();
      }
      AppAlert.toast('synced'.tr());
      setState(() {
        inSync = false;
      });
    } catch (e) {
      setState(() {
        inSync = false;
      });
    }
    // context.pop();
  }

  @override
  Widget build(BuildContext context) {
    bool hasSelection = selected['categories'] == true ||
        selected['items'] == true ||
        selected['promotions'] == true;
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: Text('categories'.tr()),
            trailing: Switch(
                value: selected['categories'] ?? false,
                onChanged: (bool value) => onSelectItem('categories', value)),
          ),
          ListTile(
            title: Text('item'.tr()),
            trailing: Switch(
                value: selected['items'] ?? false,
                onChanged: (bool value) => onSelectItem('items', value)),
          ),
          ListTile(
            title: Text('promotions'.tr()),
            trailing: Switch(
                value: selected['promotions'] ?? false,
                onChanged: (bool value) => onSelectItem('promotions', value)),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: hasSelection && !inSync ? Colors.teal : Colors.grey,
          icon: inSync
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    color: Colors.white,
                  ),
                )
              : const Icon(CupertinoIcons.refresh),
          onPressed: hasSelection && !inSync ? runSync : null,
          label: Text(inSync ? 'please_wait'.tr() : 'run_sync'.tr())),
    );
  }
}
