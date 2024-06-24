import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
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
            child: ref.watch(shiftInfoNotifierProvider).when(
                  data: (data) {
                    return Row(
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
                                      data?.summary.expectedCashEnd ?? 0,
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
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    shift.createdName,
                                    style: textTheme.bodySmall
                                        ?.copyWith(color: Colors.black54),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    size: 16,
                                    color: Colors.red.shade600,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    DateTimeFormater.dateToString(
                                        shift.startShift,
                                        format: 'EEE, d MMM ' 'yy HH:mm'),
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
                                    shift.codeShift ?? shift.id,
                                    style: textTheme.bodySmall
                                        ?.copyWith(color: Colors.black54),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                            backgroundColor: Colors.red.shade50,
                          ),
                          onPressed: onCloseShift,
                          label: Text('close'.tr()),
                          icon: const Icon(Icons.stop),
                        )
                      ],
                    );
                  },
                  error: (error, _) => Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        error.toString(),
                        style: textTheme.titleSmall
                            ?.copyWith(color: Colors.red.shade600),
                      ),
                      const SizedBox(height: 25),
                      TextButton.icon(
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.red),
                        onPressed: () => ref
                            .read(shiftInfoNotifierProvider.notifier)
                            .reload(),
                        icon: const Icon(Icons.replay_outlined),
                        label: Text(
                          'retry'.tr(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  loading: () => Column(
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
      ),
    );
  }
}
