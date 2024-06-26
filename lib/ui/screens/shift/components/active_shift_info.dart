import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/shift_info.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/utils/formater.dart';

class ActiveShiftInfo extends ConsumerWidget {
  const ActiveShiftInfo(
      {required this.shiftInfo,
      this.onCloseShift,
      this.showPrintButton,
      super.key});

  final ShiftInfo shiftInfo;
  final Function()? onCloseShift;
  final bool? showPrintButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = Theme.of(context).textTheme;
    bool active = shiftInfo.closeShift == null;
    return Container(
      color: active ? Colors.lightGreen.shade100 : Colors.grey.shade200,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
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
                                  onPressed: () => ref
                                      .read(shiftNotifierProvider.notifier)
                                      .print(shiftInfo),
                                  icon: const Icon(CupertinoIcons.printer),
                                  tooltip: 'print'.tr(),
                                )
                              : Container()
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.person_circle_fill,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            shiftInfo.openedBy,
                            style: textTheme.bodySmall
                                ?.copyWith(color: Colors.black45),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                            color: active
                                ? Colors.lightBlue.shade500
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateTimeFormater.dateToString(
                                          shiftInfo.openShift,
                                          format: 'dd/MM/y'),
                                      style: textTheme.bodySmall?.copyWith(
                                          color: active
                                              ? Colors.white
                                              : Colors.black87),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      DateTimeFormater.dateToString(
                                          shiftInfo.openShift,
                                          format: 'HH:mm'),
                                      style: textTheme.headlineMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: active
                                              ? Colors.white
                                              : Colors.black87),
                                      textAlign: TextAlign.left,
                                    )
                                  ],
                                ),
                                const SizedBox(width: 5),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 26,
                                  color: active ? Colors.white : Colors.black87,
                                ),
                                const SizedBox(width: 5),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            DateTimeFormater.dateToString(
                                                shiftInfo.closeShift ??
                                                    DateTime.now(),
                                                format: 'dd/MM/y'),
                                            style: textTheme.bodySmall
                                                ?.copyWith(
                                                    color: active
                                                        ? Colors.white
                                                        : Colors.black87),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            DateTimeFormater.dateToString(
                                                shiftInfo.closeShift ??
                                                    DateTime.now(),
                                                format: 'HH:mm'),
                                            style: textTheme.headlineMedium
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: active
                                                        ? Colors.white
                                                        : Colors.black87),
                                            textAlign: TextAlign.left,
                                          )
                                        ],
                                      ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 10),
                                Icon(
                                  Icons.key,
                                  size: 16,
                                  color:
                                      active ? Colors.white70 : Colors.black54,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  shiftInfo.codeShift,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: active
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ActiveShiftInfoSkeleton extends ConsumerWidget {
  const ActiveShiftInfoSkeleton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.lightGreen.shade100,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 140,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(5)),
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
