import 'package:easy_localization/easy_localization.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:selleri/features/settings/model/printer.dart';
import 'package:selleri/features/settings/provider/printer_provider.dart';

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
  bool printImage = false;

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
      printImage = currentPrinter?.macAddress == widget.device.macAdress
          ? currentPrinter!.printImage
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
          printImage: printImage,
        );
  }

  void onDisconnectPrinter() {
    context.pop();
    ref.read(printerProvider.notifier).disconnect();
  }

  bool get isConnected =>
      ref.watch(printerProvider).value?.macAddress == widget.device.macAdress;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.7,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 4),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'connect_printer'.tr(),
                        style: textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (isConnected)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'connected'.tr(),
                          style: textTheme.bodySmall
                              ?.copyWith(color: Colors.teal.shade700),
                        ),
                      ),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.blueGrey.shade50),
              // Scrollable content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  children: [
                    Text(
                      'Printer',
                      style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 5),
                    Text(widget.device.name, style: textTheme.bodyMedium),
                    Text(widget.device.macAdress,
                        style:
                            textTheme.bodySmall?.copyWith(color: Colors.grey)),
                    const SizedBox(height: 20),
                    Text(
                      'paper_size'.tr(),
                      style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 7.5,
                      children: paperSizeSettings
                          .map(
                            (paper) => TextButton(
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
                                  ),
                                ),
                              ),
                              onPressed: () =>
                                  setState(() => size = paper.size),
                              child: Text('${paper.width}mm'),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    _SettingRow(
                      label: 'support_auto_cut'.tr(),
                      value: cut,
                      onChanged: (v) => setState(() => cut = v),
                    ),
                    _SettingRow(
                      label: 'print_receipt_as_image'.tr(),
                      note: 'turn_on_this_option_if_receipt_is_blank'.tr(),
                      value: printImage,
                      onChanged: (v) => setState(() => printImage = v),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              // Action buttons
              Padding(
                padding: EdgeInsets.fromLTRB(
                  15,
                  8,
                  15,
                  MediaQuery.of(context).padding.bottom + 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: isConnected
                      ? [
                          TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.red),
                            onPressed: onDisconnectPrinter,
                            child: Text('disconnect_printer'.tr()),
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(
                                backgroundColor: Colors.teal),
                            onPressed: onUpdatePrinter,
                            child: Text('update'.tr()),
                          ),
                        ]
                      : [
                          const Spacer(),
                          FilledButton(
                            style: FilledButton.styleFrom(
                                backgroundColor: Colors.teal),
                            onPressed: onConnectPrinter,
                            child: Text('connect_printer'.tr()),
                          ),
                        ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.note,
  });

  final String label;
  final String? note;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 8,
      children: [
        SizedBox(
          width: 45,
          height: 35,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Switch(
              value: value,
              onChanged: onChanged,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black54),
            ),
            if (note != null)
              Text(
                note!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
              ),
          ],
        )
      ],
    );
  }
}
