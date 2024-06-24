import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/shift.dart';
import 'package:selleri/providers/shift/current_shift_info_provider.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/components/shift/cashflow_form.dart';
import 'package:selleri/ui/screens/shift/components/active_shift_info.dart';
import 'package:selleri/ui/screens/shift/components/shift_cashflows.dart';
import 'package:selleri/ui/screens/shift/components/shift_inactive.dart';
import 'components/shift_summary_card.dart';

class CurrentShiftScreen extends ConsumerStatefulWidget {
  const CurrentShiftScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CurrentShiftScreenState();
}

class _CurrentShiftScreenState extends ConsumerState<CurrentShiftScreen>
    with AutomaticKeepAliveClientMixin {
  void onAddCashflow() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        enableDrag: false,
        builder: (context) {
          return const PopScope(
            canPop: false,
            child: CashflowForm(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Shift? shift = ref.watch(shiftNotifierProvider).value;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(shiftInfoNotifierProvider.notifier).reload(),
        child: shift != null
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 85),
                child: ref.watch(shiftInfoNotifierProvider).when(
                      data: (data) {
                        return Column(
                          children: [
                            ActiveShiftInfo(shiftInfo: data!),
                            ShiftSummaryCards(shiftInfo: data),
                            ShiftCashflows(cashflows: data.cashFlows.data)
                          ],
                        );
                      },
                      error: (error, stackTrace) => ErrorHandler(
                        error: error.toString(),
                        stackTrace: stackTrace.toString(),
                      ),
                      loading: () => const Column(
                        children: [
                          ActiveShiftInfoSkeleton(),
                          ShiftSummaryCardSkeleton(),
                          ShiftCashflowsSkeleton()
                        ],
                      ),
                    ),
              )
            : const ShiftInactive(),
      ),
      floatingActionButton: shift != null
          ? ref.watch(shiftInfoNotifierProvider).value != null
              ? FloatingActionButton.extended(
                  onPressed: onAddCashflow,
                  label: Text(
                    'cashflow'.tr(),
                  ),
                  icon: const Icon(Icons.add),
                )
              : null
          : null,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
