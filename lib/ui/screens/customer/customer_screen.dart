import 'dart:async';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/customer.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/customer/customer_list_provider.dart';
import 'package:selleri/ui/components/customer/customer_form.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/components/generic/item_list_skeleton.dart';
import 'package:selleri/ui/components/search_app_bar.dart';
import 'package:selleri/ui/screens/customer/customer_detail.dart';

class CustomerScreen extends ConsumerStatefulWidget {
  const CustomerScreen({super.key});

  @override
  ConsumerState<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends ConsumerState<CustomerScreen> {
  final _scrollController = ScrollController();

  final _searchController = TextEditingController();
  bool searchVisible = false;
  Timer? _debounce;

  @override
  void initState() {
    final name = ref.read(cartNotiferProvider).customerName;
    if (name != null) {
      setState(() {
        searchVisible = true;
        _searchController.text = name;
      });
    }
    super.initState();
    _scrollController.addListener(loadMore);
  }

  void onSearchCustomers(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref
          .read(customerListNotifierProvider.notifier)
          .loadCustomers(page: 1, search: query);
    });
  }

  void loadMore() {
    final pagination = ref.read(customerListNotifierProvider).asData?.value;
    if (pagination == null ||
        pagination.to == null ||
        (pagination.to != null && pagination.currentPage >= pagination.to!)) {
      return;
    }

    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !(pagination.loading ?? false)) {
      log('Load customers... ${pagination.currentPage}/${pagination.to}');
      ref.read(customerListNotifierProvider.notifier).loadCustomers(
            page: pagination.currentPage + 1,
            search: _searchController.text,
          );
    }
  }

  void onCreateNewCustomer() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        enableDrag: false,
        builder: (context) {
          return CustomerForm(query: _searchController.text);
        });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCustomer = ref.watch(cartNotiferProvider).idCustomer;

    void onSelectCustomer(customer) {
      while (context.canPop() == true) {
        context.pop();
      }
      ref.read(cartNotiferProvider.notifier).selectCustomer(customer);
    }

    void showCustomerSheet(Customer customer) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        builder: (BuildContext context) => CustomerDetail(
          customer: customer,
          onSelect: onSelectCustomer,
        ),
      );
    }

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
              title: Text('select_customer'.tr()),
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () => setState(() {
                    searchVisible = true;
                  }),
                  icon: const Icon(Icons.search),
                )
              ],
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black87),
              actionsIconTheme: const IconThemeData(color: Colors.black87),
              titleTextStyle: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
      body: RefreshIndicator(
          onRefresh: () => ref
              .read(customerListNotifierProvider.notifier)
              .loadCustomers(page: 1, search: _searchController.text),
          child: ref.watch(customerListNotifierProvider).when(
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
                            return const ItemListSkeleton(leading: false);
                          }
                          Customer customer = data.data![idx];
                          bool selected =
                              selectedCustomer == customer.idCustomer;
                          bool isExpired = customer.expiredDate != null
                              ? customer.expiredDate!.isBefore(DateTime.now())
                              : false;
                          return ListTile(
                            title: Text(customer.customerName.trim()),
                            subtitle: Text(customer.code.trim()),
                            shape: Border(
                              bottom: BorderSide(
                                width: 0.5,
                                color: Colors.blueGrey.shade50,
                              ),
                            ),
                            onTap: () => showCustomerSheet(customer),
                            trailing: selected
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.teal,
                                  )
                                : isExpired
                                    ? Chip(
                                        padding: const EdgeInsets.all(3),
                                        label: Text('expired'.tr()),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: const BorderSide(
                                            color: Colors.red,
                                          ),
                                        ),
                                        backgroundColor: Colors.red.shade50,
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.red),
                                      )
                                    : null,
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
                              'no_data'.tr(args: ['customer'.tr()]),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _searchController.text.length >= 3
                                ? TextButton.icon(
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                        foregroundColor: Colors.white),
                                    onPressed: onCreateNewCustomer,
                                    icon: const Icon(Icons.add),
                                    label:
                                        Text('new'.tr(args: ['customer'.tr()])))
                                : Container()
                          ],
                        ),
                      ),
                error: (e, stack) => ErrorHandler(
                  error: e.toString(),
                  stackTrace: stack.toString(),
                ),
                loading: () => ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, _) => const ItemListSkeleton(
                    leading: false,
                  ),
                ),
                skipError: true,
              )),
    );
  }
}
