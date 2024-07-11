// import 'dart:math';
import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/cart_holded.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/cart/holded_provider.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/components/generic/item_list_skeleton.dart';
import 'package:selleri/ui/components/hold/hold_form.dart';
import 'package:selleri/ui/components/search_app_bar.dart';

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
    final pagination = ref.read(holdedNofierProvider).asData?.value;
    if (pagination == null ||
        pagination.to == null ||
        (pagination.to != null && pagination.currentPage >= pagination.to!)) {
      return;
    }

    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !(pagination.loading ?? false)) {
      log('Load hold... ${pagination.currentPage}/${pagination.to}');
      ref.read(holdedNofierProvider.notifier).loadTransaction(
            page: pagination.currentPage + 1,
            search: query,
          );
    }
  }

  void onSearchCustomers(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref
          .read(holdedNofierProvider.notifier)
          .loadTransaction(page: 1, search: query);
    });
  }

  void openHoldedTransaction(CartHolded holded) {
    ref.read(cartNotiferProvider.notifier).openHoldedCart(holded);
    while (context.canPop()) {
      context.pop();
    }
  }

  void onOpenHoldedCart(CartHolded cartHolded) {
    final currentCart = ref.read(cartNotiferProvider);
    if (currentCart.items.isNotEmpty || currentCart.holdAt != null) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        builder: (context) {
          return HoldForm(
            onHolded: () => openHoldedTransaction(cartHolded),
          );
        },
      );
    } else {
      openHoldedTransaction(cartHolded);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchVisible
          ? SearchAppBar(
              controller: _searchController,
              placeholder: 'search_customer'.tr(),
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
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black87),
              titleTextStyle: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
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
      body: ref.watch(holdedNofierProvider).when(
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
                      return HoldedItem(hold: hold, onSelect: onOpenHoldedCart);
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
                stackTrace: e.toString(),
              ),
            ),
            loading: () => ListView.builder(
              itemBuilder: (context, _) => const ItemListSkeleton(),
              itemCount: 10,
            ),
            skipError: true,
          ),
    );
  }
}
