import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart' hide Table;
import 'package:flutter/material.dart' hide Table;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/features/cart/model/cart.dart';
import 'package:selleri/features/table/model/table.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/shift/provider/shift_provider.dart';
import 'package:selleri/features/transaction/provider/offline_transactions_provider.dart';
import 'package:selleri/features/transaction/provider/transactions_provider.dart';
import 'package:selleri/features/transaction/widget/component/transaction_item.dart';
import 'package:selleri/shared/utils/app_alert.dart';
import 'package:selleri/shared/widget/app_drawer/app_drawer.dart';
import 'package:selleri/shared/widget/connection_baner_widget.dart';
import 'package:selleri/shared/widget/error_handler.dart';
import 'package:selleri/shared/widget/generic/item_list_skeleton.dart';
import 'package:selleri/shared/widget/search_app_bar.dart';
import 'package:selleri/features/transaction/widget/component/transaction_report_downloader.dart';
import 'package:selleri/features/table/widget/table_selector.dart';
import 'package:selleri/features/transaction/widget/transaction_detail_screen.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends ConsumerState<TransactionHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool currentShift = false;
  bool searchVisible = false;
  Timer? _debounce;
  Table? table;

  Cart? viewTransaction;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    _searchController.addListener(() => onSearchItems(page: 1));
    _scrollController.addListener(loadMore);
    setState(() {
      currentShift = ref.read(shiftProvider).value != null;
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void onSearchItems({int page = 1}) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        viewTransaction = null;
      });
      ref.read(transactionsProvider.notifier).loadTransactions(
            page: page,
            search: _searchController.text,
            currentShift: currentShift,
            table: table?.name,
          );
    });
  }

  void loadMore() {
    final pagination = ref.read(transactionsProvider).asData?.value;
    if (pagination == null ||
        pagination.to == null ||
        (pagination.to != null && pagination.currentPage >= pagination.to!)) {
      return;
    }

    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !(pagination.loading ?? false)) {
      log('Load transaction... ${pagination.currentPage}/${pagination.to}');
      onSearchItems(page: pagination.currentPage + 1);
    }
  }

  void showSalesReportDownloader() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        useSafeArea: true,
        builder: (context) {
          return const TransactionReportDownloader();
        });
  }

  void onSelectTable(Table? tbl) {
    setState(() {
      table = tbl;
    });
    onSearchItems();
  }

  Widget filterTableButton(BuildContext context) {
    bool? hasTableAddon = (ref.watch(outletProvider).value as OutletSelected)
        .config
        .addOns
        ?.contains('table');
    return hasTableAddon == true
        ? IconButton(
            onPressed: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) => TableSelector(
                  selected: table,
                  onSelect: onSelectTable,
                ),
              );
            },
            icon: table != null
                ? Container(
                    decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        borderRadius: BorderRadius.circular(5)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                    child: Text(
                      table!.name,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Icon(CupertinoIcons.square_grid_3x2))
        : Container();
  }

  Widget transactionFilter(bool isTablet) {
    var shiftFilter = Row(
      children: [
        Expanded(
          child: Text(
            'current_shift'.tr(),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.black87),
          ),
        ),
        SizedBox(
          height: 35,
          width: 45,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Switch(
              value: currentShift,
              onChanged: (value) {
                setState(() {
                  currentShift = value;
                });
                onSearchItems(page: 1);
              },
            ),
          ),
        ),
      ],
    );
    return ref.watch(shiftProvider).value != null
        ? Card(
            margin: const EdgeInsets.all(0),
            elevation: 1,
            color: Colors.white,
            shadowColor: Colors.blueGrey.shade50.withValues(alpha: 0.5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 7.5,
                horizontal: 15,
              ),
              child: isTablet
                  ? Column(
                      children: [
                        shiftFilter,
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                width: double.maxFinite,
                                child: SearchBar(
                                  leading: const Icon(CupertinoIcons.search),
                                  hintText: 'search'.tr(),
                                  controller: _searchController,
                                ),
                              ),
                            ),
                            filterTableButton(context)
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  : shiftFilter,
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: searchVisible
          ? SearchAppBar(
              onBack: () => setState(
                () {
                  searchVisible = false;
                  _searchController.text = '';
                },
              ),
              controller: _searchController,
              onChanged: (_) {},
              actions: [
                filterTableButton(context),
              ],
            )
          : AppBar(
              automaticallyImplyLeading: false,
              title: Text('transaction_history'.tr()),
              elevation: 1,
              leading: Builder(builder: (context) {
                return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(Icons.menu));
              }),
              actionsPadding: const EdgeInsets.only(right: 5),
              actions: [
                isTablet
                    ? Container()
                    : IconButton(
                        tooltip: 'search'.tr(),
                        onPressed: () => setState(() {
                          searchVisible = true;
                        }),
                        icon: const Icon(CupertinoIcons.search),
                      ),
                IconButton(
                  tooltip: 'download'.tr(),
                  onPressed: showSalesReportDownloader,
                  icon: const Icon(CupertinoIcons.doc_chart),
                ),
                ref.watch(offlineTransactionsProvider).when(
                      data: (data) => data.isNotEmpty
                          ? IconButton(
                              tooltip: 'sync'.tr(),
                              onPressed: () => ref
                                  .read(offlineTransactionsProvider.notifier)
                                  .sync(),
                              icon: Icon(Icons.cloud_upload_outlined),
                            )
                          : IconButton(
                              onPressed: () {
                                AppAlert.toast('all_transactions_synced'.tr());
                              },
                              color: Colors.green,
                              icon: Icon(Icons.cloud_done_outlined),
                            ),
                      error: (error, st) => Container(),
                      loading: () => IconButton(
                        onPressed: null,
                        icon: SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                          ),
                        ),
                      ),
                    )
              ],
            ),
      drawer: const AppDrawer(),
      body: Row(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(transactionsProvider.notifier).loadTransactions(
                        page: 1,
                        search: _searchController.text,
                        currentShift: currentShift,
                        table: table?.name,
                      ),
              child: Column(
                children: [
                  ConnectionBanerWidget(),
                  transactionFilter(isTablet),
                  Expanded(
                    child: ref.watch(transactionsProvider).when(
                          data: (data) => data.data!.isNotEmpty
                              ? ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  controller: _scrollController,
                                  itemBuilder: (context, idx) {
                                    if (idx + 1 > data.data!.length) {
                                      if (data.currentPage >= data.lastPage) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 10),
                                          child: Center(
                                            child: Text(
                                              'x_data_displayed'.tr(
                                                args: ['all'.tr()],
                                              ),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: Colors.grey.shade600,
                                                  ),
                                            ),
                                          ),
                                        );
                                      }
                                      return const ItemListSkeleton();
                                    }
                                    Cart cart = data.data![idx];
                                    return TransactionItem(
                                        cart: cart,
                                        active:
                                            viewTransaction?.idTransaction ==
                                                cart.idTransaction,
                                        onTap: () {
                                          setState(() {
                                            viewTransaction = cart;
                                          });
                                          if (!isTablet) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    TransactionDetailScreen(
                                                        cart: cart),
                                              ),
                                            );
                                          }
                                        });
                                  },
                                  itemCount: data.data!.length + 1,
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'no_data'.tr(
                                            args: ['transaction_history'.tr()]),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                          error: (e, stack) => ErrorHandler(
                            error: e.toString(),
                            stackTrace: stack.toString(),
                          ),
                          loading: () => ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context, index) =>
                                const ItemListSkeleton(),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ),
          isTablet
              ? Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    color: Colors.grey.shade100,
                  ),
                  width:
                      ResponsiveBreakpoints.of(context).largerOrEqualTo(DESKTOP)
                          ? MediaQuery.of(context).size.width - 400
                          : MediaQuery.of(context).size.width * 0.5,
                  child: viewTransaction != null
                      ? Card(
                          margin: const EdgeInsets.all(15),
                          color: Colors.grey.shade100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: TransactionDetailScreen(
                                asWidget: true, cart: viewTransaction!),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'select_x'.tr(args: ['transaction'.tr()]),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(color: Colors.blueGrey.shade300),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                )
              : Container()
        ],
      ),
    );
  }
}
