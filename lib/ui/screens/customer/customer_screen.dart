import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/customer.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/customer/customer_list_provider.dart';
import 'package:selleri/ui/components/search_app_bar.dart';
import 'package:selleri/ui/screens/customer/customer_detail.dart';
import 'package:selleri/ui/widgets/loading_widget.dart';

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
    if (pagination == null) {
      return;
    }

    if (pagination.currentPage >= pagination.to) {
      return;
    }
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !(pagination.loading ?? false)) {
      if (kDebugMode) {
        print('Load customers... ${pagination.currentPage}/${pagination.to}');
      }
      ref
          .read(customerListNotifierProvider.notifier)
          .loadCustomers(page: pagination.currentPage + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customerListNotifierProvider);
    final selectedCustomer = ref.watch(cartNotiferProvider).idCustomer;

    void onSelectCustomer(customer) {
      context.pop();
      ref.read(cartNotiferProvider.notifier).selectCustomer(customer);
    }

    void showCustomerSheet(Customer customer) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) =>
            CustomerDetail(customer: customer, onSelect: onSelectCustomer),
      );
    }

    return Scaffold(
      appBar: searchVisible
          ? SearchAppBar(
              controller: _searchController,
              placeholder: 'search_customer'.tr(),
              onBack: () => setState(() {
                searchVisible = false;
              }),
              onChanged: onSearchCustomers,
            )
          : AppBar(
              title: Text('select_customer'.tr()),
              actions: [
                IconButton(
                  onPressed: () => setState(() {
                    searchVisible = true;
                  }),
                  icon: const Icon(Icons.search),
                )
              ],
            ),
      body: customers.when(
        data: (data) => ListView.builder(
          controller: _scrollController,
          itemBuilder: (context, idx) {
            if (idx + 1 > data.data!.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: LoadingIndicator(color: Colors.teal),
                  ),
                ),
              );
            }
            Customer customer = data.data![idx];
            bool selected = selectedCustomer == customer.idCustomer;
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
                  : null,
            );
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
