import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/shift_info.dart';
import 'package:selleri/utils/formater.dart';

class ActiveShiftInfo extends StatelessWidget {
  const ActiveShiftInfo(
      {required this.shiftInfo, this.onCloseShift, super.key});

  final ShiftInfo shiftInfo;
  final Function()? onCloseShift;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      color: shiftInfo.closeShift == null || shiftInfo.closeShift == '-'
          ? Colors.lightGreen.shade100
          : Colors.red.shade100,
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
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            CupertinoIcons.person_circle_fill,
                            size: 16,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            shiftInfo.openedBy,
                            style: textTheme.bodySmall
                                ?.copyWith(color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.key,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            shiftInfo.codeShift,
                            style: textTheme.bodySmall
                                ?.copyWith(color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.play_arrow,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            DateTimeFormater.dateToString(shiftInfo.openShift,
                                format: 'd MMM ' 'yy HH:mm'),
                            style: textTheme.bodySmall
                                ?.copyWith(color: Colors.black54),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onCloseShift != null
                    ? TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                          backgroundColor: Colors.red.shade50,
                        ),
                        onPressed: onCloseShift,
                        label: Text('close'.tr()),
                        icon: const Icon(Icons.stop),
                      )
                    : Container()
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
                  height: 35,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 180,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(5)),
                ),
                const SizedBox(height: 15),
                Container(
                  width: 160,
                  height: 40,
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
