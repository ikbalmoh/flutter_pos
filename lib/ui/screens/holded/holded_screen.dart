// import 'dart:math';
import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/data/models/cart_holded.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/cart/holded_provider.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/components/generic/item_list_skeleton.dart';
import 'package:selleri/ui/components/search_app_bar.dart';
import 'package:selleri/ui/screens/holded/holded_preview.dart';

import 'holded_item.dart';

class HoldedScreen extends ConsumerStatefulWidget {
  const HoldedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HoldedScreenState();
}

class _HoldedScreenState extends ConsumerState<HoldedScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  bool searchVisible = false;
  String query = '';
  Timer? _debounce;
  CartHolded? viewTransaction;

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
    final pagination = ref.read(holdedProvider).asData?.value;
    if (pagination == null ||
        pagination.to == null ||
        (pagination.to != null && pagination.currentPage >= pagination.to!)) {
      return;
    }

    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !(pagination.loading ?? false)) {
      log('Load hold... ${pagination.currentPage}/${pagination.to}');
      ref.read(holdedProvider.notifier).loadTransaction(
            page: pagination.currentPage + 1,
            search: query,
          );
    }
  }

  void onSearchCustomers(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(holdedProvider.notifier).loadTransaction(page: 1, search: query);
    });
  }

  void openHoldedTransaction(CartHolded holded) {
    ref.read(cartProvider.notifier).openHoldedCart(holded);
    while (context.canPop()) {
      context.pop();
    }
  }

  void onOpenHoldedCart(CartHolded cartHolded) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    setState(() {
      viewTransaction = cartHolded;
    });
    if (!isTablet) {
      showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return HoldedPreview(cartHolded: cartHolded);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    var emptyPlaceholder = Column(
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
    );
    return Scaffold(
      appBar: searchVisible
          ? SearchAppBar(
              controller: _searchController,
              placeholder: 'search_x'.tr(args: ['transaction'.tr()]),
              onBack: () {
                setState(() {
                  searchVisible = false;
                });
                _searchController.text = '';
                onSearchCustomers('');
              },
              onChanged: onSearchCustomers,
            )
          : AppBar(
              title: Text('holded_transactions'.tr()),
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
                )
              ],
            ),
      body: Row(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(holdedProvider.notifier).loadTransaction(
                        page: 1,
                        search: query,
                      ),
              child: ref.watch(holdedProvider).when(
                    data: (data) => data.data!.isNotEmpty
                        ? ListView.builder(
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

                              final hold = data.data![idx];
                              return HoldedItem(
                                  color: viewTransaction?.transactionId ==
                                          hold.transactionId
                                      ? Colors.grey.shade100
                                      : Colors.white,
                                  hold: hold,
                                  onSelect: onOpenHoldedCart);
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
                                  'no_data'.tr(args: ['']),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                    error: (e, stack) => Center(
                      child: ErrorHandler(
                        error: e.toString(),
                        stackTrace: stack.toString(),
                      ),
                    ),
                    loading: () => ListView.builder(
                      itemBuilder: (context, _) => const ItemListSkeleton(),
                      itemCount: 10,
                    ),
                    skipError: true,
                  ),
            ),
          ),
          isTablet
              ? Container(
                  color: Colors.grey.shade50,
                  width: MediaQuery.of(context).size.width - 400,
                  child: viewTransaction != null
                      ? HoldedPreview(
                          cartHolded: viewTransaction!,
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
