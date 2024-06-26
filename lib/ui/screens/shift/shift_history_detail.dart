import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/shift/detail_shift_info_provider.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/screens/shift/components/active_shift_info.dart';
import 'package:selleri/ui/screens/shift/components/shift_cashflows.dart';
import 'package:selleri/ui/screens/shift/components/shift_summary_card.dart';

class ShiftHistoryDetailScreen extends ConsumerStatefulWidget {
  const ShiftHistoryDetailScreen({required this.shiftId, super.key});

  final String shiftId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShiftHistoryDetailScreenState();
}

class _ShiftHistoryDetailScreenState
    extends ConsumerState<ShiftHistoryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('shift_detail'.tr()),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 85),
        child: ref.watch(detailShiftInfoNotifierProvider(widget.shiftId)).when(
              data: (data) {
                return Column(
                  children: [
                    ActiveShiftInfo(
                      shiftInfo: data!,
                      showPrintButton: true,
                    ),
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
      ),
    );
  }
}
