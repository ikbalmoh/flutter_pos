import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/providers/settings/printer_list_provider.dart';
import 'package:selleri/providers/settings/printer_provider.dart';
import 'package:selleri/ui/screens/settings/printer/printer_setting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrinterSettingScreen extends ConsumerWidget {
  const PrinterSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('printer_setting'.tr()),
        actions: [
          IconButton(
            onPressed: ref.watch(printerListNotifierProvider).isLoading
                ? null
                : () => ref
                    .read(printerListNotifierProvider.notifier)
                    .startScanDevices(),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: const PrinterSetting(),
      floatingActionButton: ref.watch(printerNotifierProvider).value != null
          ? FloatingActionButton.extended(
              onPressed: () =>
                  ref.read(printerNotifierProvider.notifier).printTest(),
              label: Text('print_test'.tr()),
              icon: const Icon(Icons.print),
            )
          : null,
    );
  }
}
