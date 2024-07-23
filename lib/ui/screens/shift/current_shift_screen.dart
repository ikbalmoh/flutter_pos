import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/data/models/shift.dart';
import 'package:selleri/data/models/shift_cashflow.dart';
import 'package:selleri/data/models/shift_info.dart';
import 'package:selleri/providers/shift/current_shift_info_provider.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/components/shift/cashflow_form.dart';
import 'package:selleri/ui/components/shift/close_shift_form.dart';
import 'package:selleri/ui/components/shift/shift_skeleton.dart';
import 'package:selleri/ui/screens/shift/components/active_shift_info.dart';
import 'package:selleri/ui/screens/shift/components/shift_cashflows.dart';
import 'package:selleri/ui/components/shift/shift_inactive.dart';
import 'components/shift_summary_card.dart';

class CurrentShiftScreen extends ConsumerStatefulWidget {
  const CurrentShiftScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CurrentShiftScreenState();
}

class _CurrentShiftScreenState extends ConsumerState<CurrentShiftScreen>
    with AutomaticKeepAliveClientMixin {
  void onShowCashflowForm({ShiftCashflow? cashflow}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        enableDrag: false,
        builder: (context) {
          return CashflowForm(cashflow: cashflow);
        });
  }

  void onCloseShift(ShiftInfo shiftInfo) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        enableDrag: false,
        builder: (context) {
          return CloseShiftForm(
            shift: shiftInfo,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Shift? shift = ref.watch(shiftNotifierProvider).value;

    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => ref.read(shiftInfoNotifierProvider.notifier).reload(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 85),
          child: shift != null
              ? ref.watch(shiftInfoNotifierProvider).when(
                    data: (data) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: ActiveShiftInfo(
                                      shiftInfo: data!,
                                      onCloseShift: () => onCloseShift(data),
                                    ),
                                  ),
                                ),
                                ShiftSummaryCards(
                                  shiftInfo: data,
                                  isColumn: isTablet,
                                ),
                                isTablet
                                    ? Container()
                                    : ShiftCashflows(
                                        cashflows: data.cashFlows.data,
                                        onEdit: (cashflow) =>
                                            onShowCashflowForm(
                                          cashflow: cashflow,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          isTablet
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height - 80,
                                  width:
                                      MediaQuery.of(context).size.width - 400,
                                  child: SingleChildScrollView(
                                    child: ShiftCashflows(
                                      cashflows: data.cashFlows.data,
                                      onEdit: (cashflow) => onShowCashflowForm(
                                        cashflow: cashflow,
                                      ),
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      );
                    },
                    error: (error, stackTrace) => ErrorHandler(
                      error: error.toString(),
                      stackTrace: stackTrace.toString(),
                    ),
                    loading: () => const ShiftSkeleon(),
                  )
              : const ShiftInactive(),
        ),
      ),
      floatingActionButton: shift != null
          ? ref.watch(shiftInfoNotifierProvider).value != null
              ? FloatingActionButton.extended(
                  onPressed: onShowCashflowForm,
                  label: Text(
                    'cashflow'.tr(),
                  ),
                  icon: const Icon(Icons.add),
                )
              : null
          : null,
    );
  }

  Card summaryMenu(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(15),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'summary'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.black87),
            ),
          ),
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
              vertical: 17.5,
              horizontal: 15,
            ),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ListTile(
                onTap: () {},
                tileColor: Colors.blue.shade700,
                textColor: Colors.white,
                iconColor: Colors.white,
                leading: const Icon(
                  CupertinoIcons.arrow_right_arrow_left_circle_fill,
                  size: 28,
                ),
                title: Text('cashflow'.tr()),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                trailing: const Icon(
                  CupertinoIcons.chevron_right,
                  size: 16,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
