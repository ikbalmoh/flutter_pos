import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/shift.dart';
import 'package:selleri/providers/shift/shift_info_provider.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/ui/components/shift/cashflow_form.dart';
import 'package:selleri/ui/screens/shift/components/shift_active.dart';
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
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Shift? shift = ref.watch(shiftNotifierProvider).value;

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

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(shiftInfoNotifierProvider.notifier).reload(),
        child: shift != null
            ? const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 85),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShiftActive(),
                    ShiftSummaryCards(),
                    ShiftCashflows()
                  ],
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
