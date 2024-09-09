import 'package:easy_localization/easy_localization.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:selleri/data/models/printer.dart';
import 'package:selleri/providers/settings/printer_provider.dart';

class ConnectPrinter extends ConsumerStatefulWidget {
  final BluetoothInfo device;
  const ConnectPrinter({required this.device, super.key});

  @override
  ConsumerState<ConnectPrinter> createState() => _ConnectPrinterState();
}

List<PaperSizeSetting> paperSizeSettings = [
  const PaperSizeSetting(width: 58, size: PaperSize.mm58),
  const PaperSizeSetting(width: 72, size: PaperSize.mm72),
  const PaperSizeSetting(width: 80, size: PaperSize.mm80),
];

class _ConnectPrinterState extends ConsumerState<ConnectPrinter> {
  PaperSize? size;

  @override
  void initState() {
    final currentPrinter = ref.read(printerProvider).value;
    setState(() {
      size = currentPrinter?.macAddress == widget.device.macAdress
          ? currentPrinter?.size
          : PaperSize.mm58;
    });
    super.initState();
  }

  void onConnectPrinter() {
    context.pop();
    ref.read(printerProvider.notifier).connectPrinter(
          widget.device,
          size: size ?? PaperSize.mm58,
        );
  }

  void onUpdatePrinter() {
    context.pop();
    ref.read(printerProvider.notifier).updatePrinter(
          widget.device,
          size: size ?? PaperSize.mm58,
        );
  }

  void onDisconnectPrinter() {
    context.pop();
    ref.read(printerProvider.notifier).disconnect();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.only(
        top: 10,
        left: 15,
        right: 15,
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
      ),
      height: (MediaQuery.of(context).size.height * 0.5) +
          MediaQuery.of(context).viewInsets.bottom +
          15,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding:
                const EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Colors.blueGrey.shade100,
                ),
              ),
            ),
            child: Text(
              'connect_printer'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Printer',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.device.name,
                    style: textTheme.bodyMedium,
                  ),
                  Text(
                    widget.device.macAdress,
                    style: textTheme.bodySmall,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'paper_size'.tr(),
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ...paperSizeSettings
                      .map(
                        (paper) => ListTile(
                          minLeadingWidth: 0,
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0),
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -4),
                          horizontalTitleGap: -7,
                          title: Text('${paper.width} mm'),
                          leading: Radio<PaperSize>(
                            visualDensity: const VisualDensity(horizontal: 0),
                            value: paper.size,
                            groupValue: size,
                            onChanged: (PaperSize? value) {
                              setState(() {
                                size = value;
                              });
                            },
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.blueGrey.shade50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ref.watch(printerProvider).value?.macAddress ==
                    widget.device.macAdress
                ? [
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: onDisconnectPrinter,
                      child: Text(
                        'disconnect_printer'.tr(),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.teal),
                      onPressed: onUpdatePrinter,
                      child: Text(
                        'update'.tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ]
                : [
                    Container(),
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.teal),
                      onPressed: onConnectPrinter,
                      child: Text(
                        'connect_printer'.tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ],
          )
        ],
      ),
    );
  }
}
