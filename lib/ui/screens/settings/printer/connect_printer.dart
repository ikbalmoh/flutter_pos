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
  bool cut = true;

  @override
  void initState() {
    final currentPrinter = ref.read(printerProvider).value;
    setState(() {
      size = currentPrinter?.macAddress == widget.device.macAdress
          ? currentPrinter?.size
          : PaperSize.mm58;
      cut = currentPrinter?.macAddress == widget.device.macAdress
          ? currentPrinter!.cut
          : false;
    });
    super.initState();
  }

  void onConnectPrinter() {
    context.pop();
    ref.read(printerProvider.notifier).connectPrinter(
          widget.device,
          size: size ?? PaperSize.mm58,
          cut: cut,
        );
  }

  void onUpdatePrinter() {
    context.pop();
    ref.read(printerProvider.notifier).updatePrinter(
          widget.device,
          size: size ?? PaperSize.mm58,
          cut: cut,
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
                  Wrap(
                    spacing: 7.5,
                    children: List<PaperSizeSetting>.from(paperSizeSettings)
                        .map((paper) => TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: size == paper.size
                                  ? Colors.teal.shade50
                                  : Colors.grey.shade100,
                              foregroundColor: size == paper.size
                                  ? Colors.teal.shade700
                                  : Colors.grey.shade700,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.5),
                                  side: BorderSide(
                                    width: 1,
                                    color: size == paper.size
                                        ? Colors.teal
                                        : Colors.grey.shade100,
                                  )),
                            ),
                            onPressed: () => setState(() {
                                  size = paper.size;
                                }),
                            child: Text('${paper.width}')))
                        .toList(),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'support_auto_cut'.tr(),
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      Switch(
                          value: cut,
                          onChanged: (value) {
                            setState(() {
                              cut = value;
                            });
                          })
                    ],
                  )
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
