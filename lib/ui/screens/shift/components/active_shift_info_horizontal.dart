import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/shift_info.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/formater.dart';

class ActiveShiftInfoHorizontal extends ConsumerWidget {
  const ActiveShiftInfoHorizontal({
    required this.shiftInfo,
    this.onCloseShift,
    this.showPrintButton,
    super.key,
  });

  final ShiftInfo shiftInfo;
  final Function()? onCloseShift;
  final bool? showPrintButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = Theme.of(context).textTheme;
    bool active = shiftInfo.closeShift == null;

    void onPrint() async {
      try {
        await ref
            .read(shiftNotifierProvider.notifier)
            .printShift(shiftInfo, throwError: true);
      } catch (e) {
        AppAlert.toast(e.toString());
      }
    }

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      CupertinoIcons.person_circle_fill,
                      size: 18,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      shiftInfo.openedBy,
                      style:
                          textTheme.bodySmall?.copyWith(color: Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.key,
                      size: 18,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      shiftInfo.codeShift,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'cash'.tr(),
                          style: textTheme.bodySmall
                              ?.copyWith(color: Colors.black54),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Rp'),
                            Text(
                              CurrencyFormat.currency(
                                shiftInfo.summary.expectedCashEnd,
                                symbol: false,
                              ),
                              style: textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    showPrintButton == true
                        ? IconButton(
                            onPressed: onPrint,
                            icon: const Icon(CupertinoIcons.printer),
                            tooltip: 'print'.tr(),
                          )
                        : Container()
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          DateTimeFormater.dateToString(shiftInfo.openShift,
                              format: 'dd/MM/y'),
                          style: textTheme.bodySmall
                              ?.copyWith(color: Colors.black87),
                        ),
                        Text(
                          DateTimeFormater.dateToString(shiftInfo.openShift,
                              format: 'HH:mm'),
                          style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87),
                        )
                      ],
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 28,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 10),
                    onCloseShift != null
                        ? TextButton.icon(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red),
                            onPressed: onCloseShift,
                            label: Text('close'.tr()),
                            icon: const Icon(Icons.stop),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                DateTimeFormater.dateToString(
                                    shiftInfo.closeShift ?? DateTime.now(),
                                    format: 'dd/MM/y'),
                                style: textTheme.bodySmall?.copyWith(
                                    color:
                                        active ? Colors.white : Colors.black87),
                              ),
                              Text(
                                DateTimeFormater.dateToString(
                                    shiftInfo.closeShift ?? DateTime.now(),
                                    format: 'HH:mm'),
                                style: textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        active ? Colors.white : Colors.black87),
                              )
                            ],
                          ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
