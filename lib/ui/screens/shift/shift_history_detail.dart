import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/providers/shift/detail_shift_info_provider.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/components/shift/sales_summary.dart';
import 'package:selleri/ui/components/shift/shift_skeleton.dart';
import 'package:selleri/ui/components/shift/sold_items.dart';
import 'package:selleri/ui/screens/shift/components/active_shift_info.dart';
import 'package:selleri/ui/screens/shift/components/active_shift_info_horizontal.dart';
import 'package:selleri/ui/screens/shift/components/shift_cashflows.dart';
import 'package:selleri/ui/screens/shift/components/shift_summary_card.dart';
import 'package:selleri/utils/app_alert.dart';

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
        ref.read(detailShiftInfoNotifierProvider(widget.shiftId)).value;
    if (shiftInfo == null) {
      return;
    }
    try {
      await ref
          .read(shiftNotifierProvider.notifier)
          .printShift(shiftInfo, throwError: true);
    } catch (e) {
      AppAlert.toast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    return Scaffold(
      appBar: widget.asWidget == true
          ? null
          : AppBar(
              title: Text('shift_detail'.tr()),
            ),
      backgroundColor: isTablet ? Colors.blueGrey.shade50 : Colors.white,
      body: ref.watch(detailShiftInfoNotifierProvider(widget.shiftId)).when(
            data: (data) {
              if (isTablet) {
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      ActiveShiftInfoHorizontal(
                        shiftInfo: data!,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 300,
                            child: summaryMenu(context),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.55,
                              child: Card(
                                color: Colors.white,
                                elevation: 0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: SingleChildScrollView(
                                    child: viewSummary == 'cashflow'
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            child: ShiftCashflows(
                                              withoutLabel: true,
                                              cashflows: data.cashFlows.data,
                                            ),
                                          )
                                        : viewSummary == 'summary'
                                            ? SalesSummaryList(
                                                summary: data.summary,
                                              )
                                            : Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                  vertical: 10,
                                                ),
                                                child: data.soldItems.isEmpty
                                                    ? const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 150),
                                                        child:
                                                            EmptySoldItemsPlaceholder(),
                                                      )
                                                    : SoldItemsList(
                                                        items: data.soldItems,
                                                      ),
                                              ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ActiveShiftInfo(
                          shiftInfo: data!,
                          showPrintButton: true,
                        ),
                      ),
                    ),
                    ShiftSummaryCards(shiftInfo: data),
                    const SizedBox(
                      height: 15,
                    ),
                    ShiftCashflows(cashflows: data.cashFlows.data)
                  ],
                ),
              );
            },
            error: (error, stackTrace) => ErrorHandler(
              error: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
            loading: () => const ShiftSkeleon(),
          ),
      floatingActionButton: isTablet
          ? FloatingActionButton.extended(
              icon: const Icon(CupertinoIcons.printer),
              onPressed: onPrint,
              label: Text('print'.tr()))
          : null,
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
