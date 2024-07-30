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
import 'package:selleri/ui/components/shift/edit_open_amount.dart';
import 'package:selleri/ui/components/shift/sales_summary.dart';
import 'package:selleri/ui/components/shift/shift_skeleton.dart';
import 'package:selleri/ui/components/shift/sold_items.dart';
import 'package:selleri/ui/screens/shift/components/active_shift_info.dart';
import 'package:selleri/ui/screens/shift/components/shift_cashflows.dart';
import 'package:selleri/ui/components/shift/shift_inactive.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/formater.dart';
import 'components/shift_summary_card.dart';
import 'components/active_shift_info_horizontal.dart';

class SummaryMenu {
  final String title;
  final String keyMenu;
  final IconData icon;

  SummaryMenu({required this.title, required this.keyMenu, required this.icon});
}

class CurrentShiftScreen extends ConsumerStatefulWidget {
  const CurrentShiftScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CurrentShiftScreenState();
}

class _CurrentShiftScreenState extends ConsumerState<CurrentShiftScreen>
    with AutomaticKeepAliveClientMixin {
  String viewSummary = 'cashflow';

  void onShowCashflowForm({ShiftCashflow? cashflow}) {
    double sheetHeight = MediaQuery.of(context).size.height * 0.8;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        enableDrag: true,
        builder: (context) {
          return CashflowForm(
            cashflow: cashflow,
            height: sheetHeight,
          );
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

  void onEditOpenAmount(ShiftInfo shiftInfo) async {
    final newAmount = await showDialog(
        context: context,
        builder: (context) {
          return EditOpenAmount(
            openAmount: shiftInfo.summary.startingCash,
          );
        });

    if (newAmount != shiftInfo.summary.startingCash) {
      ref.read(shiftNotifierProvider.notifier).updateOpenAmount(newAmount);
      AppAlert.toast('open_amount_updated_x'
          .tr(args: [CurrencyFormat.currency(newAmount)]));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Shift? shift = ref.watch(shiftNotifierProvider).value;

    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    return Scaffold(
      backgroundColor: isTablet ? Colors.blueGrey.shade50 : Colors.white,
      body: RefreshIndicator(
        onRefresh: () => ref.read(shiftInfoNotifierProvider.notifier).reload(),
        child: shift != null
            ? ref.watch(shiftInfoNotifierProvider).when(
                  data: (data) {
                    if (isTablet) {
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            ActiveShiftInfoHorizontal(
                              shiftInfo: data!,
                              onCloseShift: () => onCloseShift(data),
                              onEditOpenAmount: () => onEditOpenAmount(data),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: summaryMenu(context),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 350,
                                  height:
                                      MediaQuery.of(context).size.height * 0.55,
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 0,
                                    child: SingleChildScrollView(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: viewSummary == 'cashflow'
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 10,
                                                ),
                                                child: ShiftCashflows(
                                                  withoutLabel: true,
                                                  cashflows:
                                                      data.cashFlows.data,
                                                  onEdit: (cashflow) =>
                                                      onShowCashflowForm(
                                                    cashflow: cashflow,
                                                  ),
                                                ),
                                              )
                                            : viewSummary == 'summary'
                                                ? SalesSummaryList(
                                                    summary: data.summary,
                                                  )
                                                : Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 15,
                                                      vertical: 10,
                                                    ),
                                                    child: data
                                                            .soldItems.isEmpty
                                                        ? const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 150),
                                                            child:
                                                                EmptySoldItemsPlaceholder(),
                                                          )
                                                        : SoldItemsList(
                                                            items:
                                                                data.soldItems,
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
                      padding: const EdgeInsets.only(bottom: 100),
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
                                onEditOpenAmount: () => onEditOpenAmount(data),
                              ),
                            ),
                          ),
                          ShiftSummaryCards(
                            shiftInfo: data,
                          ),
                          const SizedBox(height: 15),
                          ShiftCashflows(
                            cashflows: data.cashFlows.data,
                            onEdit: (cashflow) => onShowCashflowForm(
                              cashflow: cashflow,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  error: (error, stackTrace) => ErrorHandler(
                    error: error.toString(),
                    stackTrace: stackTrace.toString(),
                  ),
                  loading: () => ShiftSkeleon(isTablet: isTablet),
                )
            : const ShiftInactive(),
      ),
      floatingActionButton:
          shift == null || ref.watch(shiftInfoNotifierProvider).value == null
              ? null
              : viewSummary == 'cashflow'
                  ? FloatingActionButton.extended(
                      onPressed: onShowCashflowForm,
                      label: Text(
                        'cashflow'.tr(),
                      ),
                      icon: const Icon(Icons.add),
                    )
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

  @override
  bool get wantKeepAlive => true;
}
