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
import 'package:selleri/data/models/cart_holded.dart';
import 'package:selleri/data/models/receiving/receiving_detail.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/providers/receiving/receiving_history_provider.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/components/generic/item_list_skeleton.dart';
import 'package:selleri/ui/components/search_app_bar.dart';
import 'package:selleri/ui/screens/receiving/components/receiving_preview.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/file_download.dart';
import 'package:selleri/utils/formater.dart';

import 'components/receiving_detail_item.dart';

class ReceivingHistoryScreen extends ConsumerStatefulWidget {
  const ReceivingHistoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReceivingHistoryScreenState();
}

class _ReceivingHistoryScreenState
    extends ConsumerState<ReceivingHistoryScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  FileDownload downloader = FileDownload();

  bool searchVisible = false;
  String query = '';
  Timer? _debounce;

  DateTime? from;
  DateTime? to;
  String status = '';

  ReceivingDetail? viewReceiving;
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
    final pagination = ref.read(receivingHistoryProvider).asData?.value;
    if (pagination == null ||
        pagination.to == null ||
        (pagination.to != null && pagination.currentPage >= pagination.to!)) {
      return;
    }

    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !(pagination.loading ?? false)) {
      log('Load adjustment... ${pagination.currentPage}/${pagination.to}');
      ref.read(receivingHistoryProvider.notifier).loadReceivingHistory(
            page: pagination.currentPage + 1,
            search: query,
            date: from,
            type: status,
          );
    }
  }

  void onSearchAdjustments(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(receivingHistoryProvider.notifier).loadReceivingHistory(
          page: 1, search: query, date: from, type: status);
    });
  }

  void onFilterAdjustmentDate(DateTime? f, DateTime? t) {
    setState(() {
      from = f;
      to = t;
    });
    ref
        .read(receivingHistoryProvider.notifier)
        .loadReceivingHistory(page: 1, search: query, date: f, type: status);
  }

  void openHoldedTransaction(CartHolded holded) {
    ref.read(cartProvider.notifier).openHoldedCart(holded);
    while (context.canPop()) {
      context.pop();
    }
  }

  void onOpenAdjustment(ReceivingDetail receiving) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    setState(() {
      viewReceiving = receiving;
    });
    if (!isTablet) {
      showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return ReceivingPreview(
              receiving: receiving,
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

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    final history = ref.watch(receivingHistoryProvider);

    var emptyPlaceholder = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'select_x'.tr(args: ['receiving'.tr()]),
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
              placeholder: 'search_x'.tr(args: ['receiving'.tr()]),
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
              title: Text('receiving_history'.tr()),
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
                const SizedBox(width: 10)
              ],
            ),
      body: Row(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref
                  .read(receivingHistoryProvider.notifier)
                  .loadReceivingHistory(
                    page: 1,
                    search: query,
                  ),
              child: switch (history) {
                AsyncData(:final value) =>
                  GroupedListView<ReceivingDetail, String>(
                    controller: _scrollController,
                    elements: value.data ?? [],
                    padding: const EdgeInsets.symmetric(vertical: 7.5),
                    groupBy: (ReceivingDetail element) => DateTime(
                      element.receiveDate.year,
                      element.receiveDate.month,
                      element.receiveDate.day,
                    ).toString(),
                    order: GroupedListOrder.DESC,
                    groupHeaderBuilder: (ReceivingDetail header) => Container(
                      width: double.maxFinite,
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Text(
                        DateTimeFormater.dateToString(header.receiveDate,
                            format: 'dd MMM y'),
                      ),
                    ),
                    itemComparator: (element1, element2) =>
                        DateTimeFormater.stringToTimestamp(element1.receiveDate)
                            .compareTo(
                                DateTimeFormater.stringToTimestamp(element2)),
                    itemBuilder: (context, element) => ReceivingDetailItem(
                      receiving: element,
                      onSelect: onOpenAdjustment,
                      color: viewReceiving?.id == element.id
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
                  child: viewReceiving != null
                      ? ReceivingPreview(
                          receiving: viewReceiving!,
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
