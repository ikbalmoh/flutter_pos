import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/settings/app_settings_provider.dart';

class AutoPrintScreen extends StatelessWidget {
  const AutoPrintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sync_data'.tr()),
      ),
      body: const AutoPrint(),
    );
  }
}

class AutoPrint extends ConsumerStatefulWidget {
  const AutoPrint({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AutoPrintState();
}

class _AutoPrintState extends ConsumerState<AutoPrint> {
  void onToggleAutoPrint(String key, bool value) {
    switch (key) {
      case 'autoPrintReceipt':
        ref.read(appSettingsProvider.notifier).toggleAutoPrintReceipt(value);
        break;

      case 'autoPrintOnMakePayment':
        ref.read(appSettingsProvider.notifier).toggleAutoPrintOnMakePayment(value);
        break;

      case 'autoPrintShiftReport':
        ref
            .read(appSettingsProvider.notifier)
            .toggleAutoPrintShiftReport(value);
        break;

      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: Text('transaction_receipt'.tr()),
            trailing: Switch(
                value: ref.watch(appSettingsProvider).autoPrintReceipt,
                onChanged: (bool value) =>
                    onToggleAutoPrint('autoPrintReceipt', value)),
          ),
          ListTile(
            title: Text('payment'.tr(args: [''])),
            trailing: Switch(
                value: ref.watch(appSettingsProvider).autoPrintOnMakePayment,
                onChanged: (bool value) =>
                    onToggleAutoPrint('autoPrintOnMakePayment', value)),
          ),
          ListTile(
            title: Text('shift'.tr()),
            trailing: Switch(
                value: ref.watch(appSettingsProvider).autoPrintShiftReport,
                onChanged: (bool value) =>
                    onToggleAutoPrint('autoPrintShiftReport', value)),
          ),
        ],
      ),
    );
  }
}
