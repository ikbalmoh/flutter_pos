import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/customer.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/customer/customer_list_provider.dart';
import 'package:selleri/ui/screens/customer/customer_detail.dart';
import 'package:selleri/ui/widgets/loading_widget.dart';

class CustomerScreen extends ConsumerWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      appBar: AppBar(
        title: Text('select_customer'.tr()),
      ),
      body: customers.when(
        data: (data) => ListView.builder(
          itemBuilder: (context, idx) {
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
          itemCount: data.data?.length,
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
