import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/shift.dart';
import 'package:selleri/providers/shift/shift_info_provider.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/utils/formater.dart';

class ShiftActive extends ConsumerWidget {
  const ShiftActive({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onCloseShift() {
      ref.read(shiftNotifierProvider.notifier).closeShift(0);
    }

    final Shift shift = ref.watch(shiftNotifierProvider).value!;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      color: Colors.lightGreen.shade100,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            shift.createdName,
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          Chip(
            backgroundColor: Colors.lightGreen,
            labelStyle: textTheme.labelSmall?.copyWith(color: Colors.white),
            side: BorderSide.none,
            padding: const EdgeInsets.all(3),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            label: Text(
              shift.codeShift ?? shift.id,
              textAlign: TextAlign.center,
            ),
            avatar: const Icon(
              Icons.key_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              color: Colors.white,
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ref.watch(shiftInfoNotifierProvider).when(
                      data: (data) {
                        return [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Rp'),
                              Text(
                                CurrencyFormat.currency(
                                  data?.summary.expectedCashEnd ?? 0,
                                  symbol: false,
                                ),
                                style: textTheme.headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                size: 16,
                                color: Colors.black45,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                DateTimeFormater.dateToString(shift.startShift,
                                    format: 'EEE, d MMM ' 'yy HH:mm'),
                                style: textTheme.bodyMedium
                                    ?.copyWith(color: Colors.black54),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          SizedBox(
                            width: 160,
                            height: 40,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.red.shade300,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              onPressed: onCloseShift,
                              label: Text('close_shift'.tr()),
                              icon: const Icon(Icons.stop),
                            ),
                          )
                        ];
                      },
                      error: (error, _) => [],
                      loading: () => [
                            Container(
                              width: 150,
                              height: 35,
                              decoration: BoxDecoration(
                                  color:
                                      Colors.blueGrey.shade50.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 180,
                              height: 20,
                              decoration: BoxDecoration(
                                  color:
                                      Colors.blueGrey.shade50.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: 160,
                              height: 40,
                              decoration: BoxDecoration(
                                  color:
                                      Colors.blueGrey.shade50.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
