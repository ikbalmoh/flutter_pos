import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/settings/printer_provider.dart';

class PrinterSetting extends ConsumerWidget {
  const PrinterSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 5),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Colors.black12,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Printer',
                  style: textTheme.headlineSmall,
                ),
                IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () => ref
                      .read(printerNotifierProvider.notifier)
                      .startScanDevices(),
                  icon: const Icon(
                    CupertinoIcons.search,
                    size: 18,
                    color: Colors.teal,
                  ),
                )
              ],
            ),
          ),
          ref.watch(printerNotifierProvider).when(
                data: (printers) => printers.isNotEmpty
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: printers
                            .map(
                              (d) => ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 0,
                                ),
                                title: Text(d.name ?? ''),
                                subtitle: Text(d.address ?? '-'),
                                onTap: () {},
                              ),
                            )
                            .toList(),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'no_device_found'.tr(),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                error: (e, trace) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      'scanning_devices'.tr(),
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                loading: () => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      'no_device_found'.tr(),
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
