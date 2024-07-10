import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/providers/transaction/transactions_provider.dart';
import 'package:selleri/ui/components/app_drawer/app_drawer.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/components/generic/item_list_skeleton.dart';
import 'package:selleri/ui/components/search_app_bar.dart';
import 'package:selleri/ui/components/transaction/transaction_report_downloader.dart';
import 'package:selleri/ui/screens/transaction_history/transaction_detail_screen.dart';
import 'package:selleri/utils/formater.dart';

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

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    _searchController.addListener(() => onSearchItems(_searchController.text));
    _scrollController.addListener(loadMore);
    setState(() {
      currentShift = ref.read(shiftNotifierProvider).value != null;
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void onSearchItems(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref
          .read(transactionsNotifierProvider.notifier)
          .loadTransactions(page: 1, search: query, currentShift: currentShift);
    });
  }

  void loadMore() {
    final pagination = ref.read(transactionsNotifierProvider).asData?.value;
    if (pagination == null ||
        pagination.to == null ||
        (pagination.to != null && pagination.currentPage >= pagination.to!)) {
      return;
    }

    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !(pagination.loading ?? false)) {
      log('Load transaction... ${pagination.currentPage}/${pagination.to}');
      ref.read(transactionsNotifierProvider.notifier).loadTransactions(
          page: pagination.currentPage + 1,
          search: _searchController.text,
          currentShift: currentShift);
    }
  }

  void showSalesReportDownloader() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        builder: (context) {
          return const TransactionReportDownloader();
        });
  }

  Widget shiftFilter() {
    return ref.watch(shiftNotifierProvider).value != null
        ? Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Colors.blueGrey.shade50,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'current_shift'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.black87),
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
                        onSearchItems(_searchController.text);
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
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
            )
          : AppBar(
              automaticallyImplyLeading: false,
              title: Text('transaction_history'.tr()),
              leading: Builder(builder: (context) {
                return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(Icons.menu));
              }),
              actions: [
                IconButton(
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
              ],
            ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(transactionsNotifierProvider.notifier).loadTransactions(
                  page: 1,
                  search: _searchController.text,
                  currentShift: currentShift,
                ),
        child: Column(
          children: [
            shiftFilter(),
            Expanded(
              child: ref.watch(transactionsNotifierProvider).when(
                    data: (data) => data.data!.isNotEmpty
                        ? ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
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
                                          args: [data.total.toString()],
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
                              return ListTile(
                                tileColor: Colors.white,
                                title: Text(cart.transactionNo),
                                trailing: Text(
                                  CurrencyFormat.currency(
                                    cart.grandTotal,
                                    symbol: true,
                                  ),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                leading: cart.deletedAt != null
                                    ? const Icon(
                                        CupertinoIcons.xmark_circle_fill,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                        CupertinoIcons
                                            .checkmark_alt_circle_fill,
                                        color: Colors.green,
                                      ),
                                shape: Border(
                                  bottom: BorderSide(
                                    width: 0.5,
                                    color: Colors.blueGrey.shade50,
                                  ),
                                ),
                                titleTextStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                                subtitleTextStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.grey.shade600),
                                subtitle: Text(
                                  DateTimeFormater.msToString(
                                      cart.transactionDate,
                                      format: 'd MMM y HH:mm'),
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TransactionDetailScreen(cart: cart),
                                  ),
                                ),
                              );
                            },
                            itemCount: data.data!.length + 1,
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'no_data'
                                      .tr(args: ['transaction_history'.tr()]),
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
                      itemBuilder: (context, index) => const ItemListSkeleton(),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
