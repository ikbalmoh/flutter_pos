import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide AppBar;
import 'package:selleri/app/widget/app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/shift/provider/detail_shift_info_provider.dart';
import 'package:selleri/features/shift/provider/shift_notifier_provider.dart';
import 'package:selleri/features/shift/widget/components/shift_summary_receipt.dart';
import 'package:selleri/shared/widget/error_handler.dart';
import 'package:selleri/features/shift/widget/components/shift_skeleton.dart';
import 'package:selleri/shared/utils/app_alert.dart';

class SummaryMenu {
  final String title;
  final String keyMenu;
  final IconData icon;

  SummaryMenu({required this.title, required this.keyMenu, required this.icon});
}

class ShiftHistoryDetailScreen extends ConsumerStatefulWidget {
  const ShiftHistoryDetailScreen(
      {required this.shiftId, this.asWidget, super.key});

  final String shiftId;
  final bool? asWidget;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShiftHistoryDetailScreenState();
}

class _ShiftHistoryDetailScreenState
    extends ConsumerState<ShiftHistoryDetailScreen> {
  String viewSummary = 'cashflow';

  void onPrint() async {
    final shiftInfo =
        ref.read(detailShiftInfoProvider(widget.shiftId)).value;
    log('Print Shift History: $shiftInfo');
    if (shiftInfo == null) {
      return;
    }
    try {
      await ref
          .read(shiftProvider.notifier)
          .printShift(shiftInfo, throwError: true);
    } catch (e) {
      AppAlert.toast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.asWidget == true
          ? null
          : AppBar(
              title: Text('shift_detail'.tr()),
            ),
      backgroundColor: Colors.blueGrey.shade50,
      body: ref.watch(detailShiftInfoProvider(widget.shiftId)).when(
            data: (data) {
              final outletSelected =
                  ref.watch(outletProvider).value as OutletSelected;
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(10),
                child: ShiftSummaryReceipt(
                  shift: data!,
                  outlet: outletSelected.outlet,
                  attributeReceipts: outletSelected.config.attributeReceipts,
                  withAttribute: true,
                ),
              );
            },
            error: (error, stackTrace) => ErrorHandler(
              error: error,
              stackTrace: stackTrace.toString(),
            ),
            loading: () => const ShiftSkeleon(),
          ),
      floatingActionButton: widget.asWidget == true
          ? null
          : FloatingActionButton.extended(
              icon: const Icon(CupertinoIcons.printer),
              onPressed: onPrint,
              label: Text('print'.tr())),
    );
  }

  Card summaryMenu(BuildContext context) {
    final List<SummaryMenu> menus = [
      SummaryMenu(
        title: 'cashflow'.tr(),
        keyMenu: 'cashflow',
        icon: CupertinoIcons.arrow_right_arrow_left_circle_fill,
      ),
      SummaryMenu(
        title: 'summary'.tr(),
        keyMenu: 'summary',
        icon: CupertinoIcons.creditcard_fill,
      ),
      SummaryMenu(
        title: 'item_sold'.tr(),
        keyMenu: 'item_sold',
        icon: CupertinoIcons.bag_fill,
      ),
    ];

    return Card(
      color: Colors.white,
      elevation: 0,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(
          vertical: 17.5,
          horizontal: 15,
        ),
        physics: const NeverScrollableScrollPhysics(),
        children: menus
            .map((menu) => ListTile(
                  onTap: () => setState(() {
                    viewSummary = menu.keyMenu;
                  }),
                  tileColor: viewSummary == menu.keyMenu
                      ? Colors.blue.shade700
                      : Colors.white,
                  textColor: viewSummary == menu.keyMenu
                      ? Colors.white
                      : Colors.grey.shade700,
                  iconColor: viewSummary == menu.keyMenu
                      ? Colors.white
                      : Colors.grey.shade700,
                  leading: Icon(
                    menu.icon,
                    size: 20,
                  ),
                  title: Text(menu.title),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  trailing: const Icon(
                    CupertinoIcons.chevron_right,
                    size: 16,
                  ),
                ))
            .toList(),
      ),
    );
  }
}
