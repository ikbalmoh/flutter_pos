// import 'dart:math';
import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:open_file/open_file.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/config/api_url.dart';
import 'package:selleri/data/models/adjustment_history.dart' as model;
import 'package:selleri/data/models/cart_holded.dart';
import 'package:selleri/providers/adjustment/adjustment_history_provider.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/components/generic/item_list_skeleton.dart';
import 'package:selleri/ui/components/search_app_bar.dart';
import 'package:selleri/ui/screens/adjustments/components/adjustment_date_filter.dart';
import 'package:selleri/ui/screens/adjustments/components/adjustment_preview.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/file_download.dart';
import 'package:selleri/utils/formater.dart';

import 'components/adjustment_history_item.dart';

class AdjustmentHistoryScreen extends ConsumerStatefulWidget {
  const AdjustmentHistoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdjustmentHistoryScreenState();
}

class _AdjustmentHistoryScreenState
    extends ConsumerState<AdjustmentHistoryScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  FileDownload downloader = FileDownload();

  bool searchVisible = false;
  String query = '';
  Timer? _debounce;

  DateTime? from;
  DateTime? to;

  model.AdjustmentHistory? viewAdjustment;
  String downloading = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(loadMore);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void loadMore() {
    final pagination = ref.read(adjustmentHistoryProvider).asData?.value;
    if (pagination == null ||
        pagination.to == null ||
        (pagination.to != null && pagination.currentPage >= pagination.to!)) {
      return;
    }

    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !(pagination.loading ?? false)) {
      log('Load adjustment... ${pagination.currentPage}/${pagination.to}');
      ref.read(adjustmentHistoryProvider.notifier).loadAdjustmentHistory(
          page: pagination.currentPage + 1, search: query, from: from, to: to);
    }
  }

  void onSearchAdjustments(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref
          .read(adjustmentHistoryProvider.notifier)
          .loadAdjustmentHistory(page: 1, search: query, from: from, to: to);
    });
  }

  void onFilterAdjustmentDate(DateTime? f, DateTime? t) {
    setState(() {
      from = f;
      to = t;
    });
    ref
        .read(adjustmentHistoryProvider.notifier)
        .loadAdjustmentHistory(page: 1, search: query, from: f, to: t);
  }

  void openHoldedTransaction(CartHolded holded) {
    ref.read(cartProvider.notifier).openHoldedCart(holded);
    while (context.canPop()) {
      context.pop();
    }
  }

  void onOpenAdjustment(model.AdjustmentHistory adjustment) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    setState(() {
      viewAdjustment = adjustment;
    });
    if (!isTablet) {
      showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return AdjustmentPreview(
              adjustment: adjustment,
            );
          });
    }
  }

  void download(BuildContext context, DateTime adjustmentDate) async {
    if (downloading != '') {
      return;
    }
    try {
      AppAlert.toast('downloading'.tr());

      String dateString =
          DateTimeFormater.dateToString(adjustmentDate, format: 'y-MM-dd');

      log('downloading: $dateString');

      setState(() {
        downloading = dateString;
      });

      Map<String, dynamic> params = {
        "date": dateString,
        "type": "export",
        "id_outlet": ref.read(outletProvider).value is OutletSelected
            ? (ref.read(outletProvider).value as OutletSelected).outlet.idOutlet
            : ''
      };
      String fileName = 'sales-report-$dateString.xlsx';

      String path = await downloader.download(
        ApiUrl.reportAdjustment,
        openAfterDownload: false,
        fileName: fileName,
        params: params,
        options: Options(method: 'POST'),
      );

      setState(() {
        downloading = '';
      });

      if (context.mounted) {
        AppAlert.snackbar(
            context, 'x_downloaded'.tr(args: ['sales_report'.tr()]),
            action: SnackBarAction(
                label: 'open'.tr(), onPressed: () => OpenFile.open(path)));
      }
    } on Exception catch (e) {
      setState(() {
        downloading = '';
      });
      log('Download error: $e');
      AppAlert.toast(e.toString(), backgroundColor: Colors.red);
    }
  }

  void showAdjustmentDatePicked() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        builder: (context) {
          return AdjustmentDateFilter(
              from: from, to: to, onSelect: onFilterAdjustmentDate);
        });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    final history = ref.watch(adjustmentHistoryProvider);

    var emptyPlaceholder = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'select_x'.tr(args: ['adjustment'.tr()]),
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: Colors.blueGrey.shade300),
          textAlign: TextAlign.center,
        )
      ],
    );
    return Scaffold(
      appBar: searchVisible
          ? SearchAppBar(
              controller: _searchController,
              placeholder: 'search_x'.tr(args: ['adjustment'.tr()]),
              onBack: () {
                setState(() {
                  searchVisible = false;
                });
                _searchController.text = '';
                onSearchAdjustments('');
              },
              onChanged: onSearchAdjustments,
            )
          : AppBar(
              title: Text('adjustment_history'.tr()),
              iconTheme: const IconThemeData(color: Colors.black87),
              titleTextStyle: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              centerTitle: false,
              actionsIconTheme: const IconThemeData(color: Colors.black87),
              actions: [
                IconButton(
                  onPressed: () => setState(() {
                    searchVisible = true;
                  }),
                  icon: const Icon(Icons.search),
                ),
                from == null
                    ? IconButton(
                        onPressed: showAdjustmentDatePicked,
                        icon: const Icon(CupertinoIcons.calendar),
                      )
                    : TextButton.icon(
                        onPressed: showAdjustmentDatePicked,
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.teal.shade50),
                        icon: const Icon(CupertinoIcons.calendar),
                        label: Text(
                          '${DateTimeFormater.dateToString(from!, format: 'dd MMM')} ${to != null && to != from ? DateTimeFormater.dateToString(to!, format: ' - dd MMM') : ''}',
                        ),
                      ),
                const SizedBox(width: 10)
              ],
            ),
      body: Row(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref
                  .read(adjustmentHistoryProvider.notifier)
                  .loadAdjustmentHistory(
                    page: 1,
                    search: query,
                  ),
              child: switch (history) {
                AsyncData(:final value) =>
                  GroupedListView<model.AdjustmentHistory, String>(
                    controller: _scrollController,
                    elements: value.data ?? [],
                    padding: const EdgeInsets.symmetric(vertical: 7.5),
                    groupBy: (model.AdjustmentHistory element) => DateTime(
                      element.adjustmentDate.year,
                      element.adjustmentDate.month,
                      element.adjustmentDate.day,
                    ).toString(),
                    order: GroupedListOrder.DESC,
                    groupHeaderBuilder: (model.AdjustmentHistory header) =>
                        Container(
                      width: double.maxFinite,
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(DateTimeFormater.dateToString(
                              header.adjustmentDate,
                              format: 'dd MMM y')),
                          TextButton.icon(
                            style: downloading == ''
                                ? TextButton.styleFrom(
                                    iconColor: Colors.teal,
                                    foregroundColor: Colors.teal)
                                : TextButton.styleFrom(
                                    iconColor: Colors.grey,
                                    foregroundColor: Colors.grey),
                            icon: downloading ==
                                    DateTimeFormater.dateToString(
                                        header.adjustmentDate,
                                        format: 'y-MM-dd')
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 1),
                                  )
                                : const Icon(
                                    CupertinoIcons.cloud_download,
                                    size: 16,
                                  ),
                            onPressed: () =>
                                download(context, header.adjustmentDate),
                            label: Text(
                              'download'.tr(),
                            ),
                          )
                        ],
                      ),
                    ),
                    itemComparator: (element1, element2) =>
                        DateTimeFormater.stringToTimestamp(
                                element1.adjustmentDate)
                            .compareTo(
                                DateTimeFormater.stringToTimestamp(element2)),
                    itemBuilder: (context, element) => AdjustmentHistoryItem(
                      adjustment: element,
                      onSelect: onOpenAdjustment,
                      color:
                          viewAdjustment?.idAdjustment == element.idAdjustment
                              ? Colors.grey.shade100
                              : Colors.white,
                    ),
                    useStickyGroupSeparators: true,
                    floatingHeader: true,
                    footer: value.loading == true ||
                            value.currentPage < value.lastPage
                        ? const ItemListSkeleton(
                            leading: false,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Text(
                                'x_data_displayed'.tr(args: [
                                  CurrencyFormat.currency(
                                    value.total,
                                    symbol: false,
                                  )
                                ]),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.grey.shade500),
                              ),
                            ),
                          ),
                  ),
                AsyncError(:final error, :final stackTrace) => ErrorHandler(
                    error: error.toString(),
                    stackTrace: stackTrace.toString(),
                  ),
                _ => ListView.builder(
                    itemBuilder: (context, _) => const ItemListSkeleton(),
                    itemCount: 10,
                  ),
              },
            ),
          ),
          isTablet
              ? Container(
                  color: Colors.grey.shade50,
                  width: MediaQuery.of(context).size.width - 400,
                  child: viewAdjustment != null
                      ? AdjustmentPreview(
                          adjustment: viewAdjustment!,
                          asWidget: true,
                        )
                      : emptyPlaceholder,
                )
              : Container(),
        ],
      ),
    );
  }
}
