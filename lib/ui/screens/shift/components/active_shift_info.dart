import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/shift_info.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/formater.dart';

class ActiveShiftInfo extends ConsumerWidget {
  const ActiveShiftInfo({
    required this.shiftInfo,
    this.onEditOpenAmount,
    this.onCloseShift,
    this.showPrintButton,
    super.key,
  });

  final ShiftInfo shiftInfo;
  final Function()? onCloseShift;
  final Function()? onEditOpenAmount;
  final bool? showPrintButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = Theme.of(context).textTheme;
    bool active = shiftInfo.closeShift == null;

    void onPrint() async {
      try {
        await ref
            .read(shiftProvider.notifier)
            .printShift(shiftInfo, throwError: true);
      } catch (e) {
        AppAlert.toast(e.toString());
      }
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.all(0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
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
                                  onEditOpenAmount != null
                                      ? IconButton(
                                          onPressed: onEditOpenAmount,
                                          padding: const EdgeInsets.all(0),
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 16,
                                          ),
                                          tooltip: 'edit_open_amount'.tr(),
                                        )
                                      : Container()
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
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: active
                                ? Colors.green.shade500
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateTimeFormater.dateToString(
                                          shiftInfo.openShift,
                                          format: 'dd/MM/y'),
                                      style: textTheme.bodySmall?.copyWith(
                                          color: Colors.green.shade700),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      DateTimeFormater.dateToString(
                                          shiftInfo.openShift,
                                          format: 'HH:mm'),
                                      style: textTheme.headlineMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green.shade700),
                                      textAlign: TextAlign.left,
                                    )
                                  ],
                                ),
                                shiftInfo.closeShift != null ||
                                        onCloseShift != null
                                    ? Row(
                                        children: [
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
                                                      foregroundColor:
                                                          Colors.white,
                                                      backgroundColor:
                                                          Colors.red),
                                                  onPressed: onCloseShift,
                                                  label: Text('close'.tr()),
                                                  icon: const Icon(
                                                    Icons.stop,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : shiftInfo.closeShift != null
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          DateTimeFormater
                                                              .dateToString(
                                                                  shiftInfo
                                                                      .closeShift!,
                                                                  format:
                                                                      'dd/MM/y'),
                                                          style: textTheme
                                                              .bodySmall
                                                              ?.copyWith(
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                        Text(
                                                          DateTimeFormater
                                                              .dateToString(
                                                                  shiftInfo
                                                                      .closeShift!,
                                                                  format:
                                                                      'HH:mm'),
                                                          style: textTheme
                                                              .headlineMedium
                                                              ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .red),
                                                        )
                                                      ],
                                                    )
                                                  : Container(),
                                        ],
                                      )
                                    : Container()
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.key,
                                  size: 16,
                                  color: Colors.black54,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  shiftInfo.codeShift,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Colors.black54,
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
