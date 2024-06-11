import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:selleri/data/models/printer.dart';
import 'package:selleri/providers/settings/printer_list_provider.dart';
import 'package:selleri/providers/settings/printer_provider.dart';
import 'package:selleri/ui/screens/settings/printer/connect_printer.dart';
import 'package:selleri/ui/widgets/loading_widget.dart';
import 'package:selleri/utils/app_alert.dart';

class PrinterSetting extends ConsumerWidget {
  const PrinterSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPrinter = ref.watch(printerNotifierProvider).value;

    void onSelectPrinter(BluetoothInfo device) {
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          builder: (context) {
            return ConnectPrinter(device: device);
          });
    }

    ref.listen(printerNotifierProvider, (prev, next) {
      next.when(data: (printer) {
        if (printer != null) {
          AppAlert.snackbar(
              context, 'printer_connected'.tr(args: [printer.name]));
        }
      }, error: (e, stack) {
        AppAlert.snackbar(
            context, 'connect_printer_failed'.tr(args: [e.toString()]));
      }, loading: () {
        AppAlert.snackbar(context, 'printer_connecting'.tr());
      });
    });

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ref.watch(printerListNotifierProvider).when(
            data: (printers) => printers.isNotEmpty
                ? Column(
                    children: printers
                        .map(
                          (d) => ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            title: Text(d.name),
                            subtitle: Text(
                              d.macAdress,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            trailing: currentPrinter?.macAddress == d.macAdress
                                ? const Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.teal,
                                  )
                                : null,
                            onTap: () => onSelectPrinter(d),
                          ),
                        )
                        .toList(),
                  )
                : const DeviceEmpty(),
            error: (e, trace) => DeviceEmpty(
              message: e.toString(),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
              child: Center(
                child: LoadingIndicator(
                  color: Colors.teal,
                ),
              ),
            ),
          ),
    );
  }
}

class DeviceEmpty extends ConsumerWidget {
  final String? message;

  const DeviceEmpty({this.message, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.print,
              size: 50,
              color: Colors.grey,
            ),
            const SizedBox(height: 15),
            Text(
              message ?? 'no_device_found'.tr(),
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              'printer_setting_instruction'.tr(),
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            TextButton.icon(
              onPressed: () => ref
                  .read(printerListNotifierProvider.notifier)
                  .startScanDevices(),
              icon: const Icon(Icons.search),
              label: Text(
                'scan_again'.tr(),
              ),
            )
          ]),
    );
  }
}
