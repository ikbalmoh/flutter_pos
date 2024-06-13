// import 'dart:math';
import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/cart_holded.dart';
import 'package:selleri/providers/cart/holded_provider.dart';
import 'package:selleri/ui/components/search_app_bar.dart';
import 'package:selleri/ui/widgets/loading_widget.dart';
import 'package:selleri/utils/formater.dart';

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
    if (pagination == null) {
      return;
    }

    if (pagination.currentPage >= pagination.to) {
      return;
    }
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !(pagination.loading ?? false)) {
      log('Load hold... ${pagination.currentPage}/${pagination.to}');
      ref
          .read(holdedNofierProvider.notifier)
          .loadTransaction(page: pagination.currentPage + 1);
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
            data: (data) => ListView.builder(
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
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                        ),
                      ),
                    );
                  }
                  return const Center(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: LoadingIndicator(color: Colors.teal),
                      ),
                    ),
                  );
                }

                final hold = data.data![idx];
                return HoldItem(hold: hold);
              },
              itemCount: data.data!.length + 1,
            ),
            error: (e, stack) => null,
            loading: () => const LoadingWidget(
              color: Colors.teal,
            ),
            skipError: true,
          ),
    );
  }
}

class HoldItem extends StatelessWidget {
  final CartHolded hold;

  const HoldItem({required this.hold, super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return ListTile(
      titleAlignment: ListTileTitleAlignment.top,
      title: Text(hold.transactionNo.trim()),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CurrencyFormat.currency(hold.dataHold.grandTotal),
            style: textTheme.bodyMedium,
          ),
          Text(
            '${'cashier'.tr()}: ${hold.createdName ?? ''}',
            style: textTheme.bodySmall?.copyWith(color: Colors.black54),
          ),
          Text(
            '${'customer'.tr()}: ${hold.customerName ?? ''}',
            style: textTheme.bodySmall?.copyWith(color: Colors.black54),
          ),
        ],
      ),
      shape: Border(
        bottom: BorderSide(
          width: 0.5,
          color: Colors.blueGrey.shade50,
        ),
      ),
      onTap: () {},
      leading: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: hold.dataHold.isApp
            ? Icon(
                Icons.smartphone,
                color: Colors.green.shade700,
                size: 20,
              )
            : const Icon(
                Icons.laptop,
                color: Colors.black45,
                size: 20,
              ),
      ),
      trailing: Text(
        DateTimeFormater.dateToString(hold.createdAt, format: 'dd/MM HH:mm'),
        style: textTheme.bodySmall,
      ),
    );
  }
}
