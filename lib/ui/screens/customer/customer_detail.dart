import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/customer.dart';

class CustomerDetail extends StatelessWidget {
  final Customer customer;
  final Function(Customer) onSelect;

  const CustomerDetail(
      {required this.customer, required this.onSelect, super.key});

  @override
  Widget build(BuildContext context) {
    Widget listTile(String title, String? value) => ListTile(
          title: Text(title),
          subtitle: Text(value ?? '-'),
          shape: Border(
            bottom: BorderSide(
              width: 1,
              color: Colors.blueGrey.shade200,
            ),
          ),
        );
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      margin: const EdgeInsets.all(0),
      child: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(
                top: 10, left: 12.5, right: 12.5, bottom: 12.5),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Colors.blueGrey.shade100,
                ),
              ),
            ),
            child: Text(
              'customer_detail'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                listTile('customer_code'.tr(), customer.code.trim()),
                listTile('customer_name'.tr(), customer.customerName.trim()),
                listTile('group', customer.groupNames),
                listTile('Email', customer.email),
                listTile('phone'.tr(), customer.phoneNumber),
                listTile('address'.tr(), customer.address),
                listTile('Barcode', customer.barcode),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
                  onPressed: () => context.pop(),
                  child: Text('close'.tr()),
                ),
                TextButton(
                  onPressed: () => onSelect(customer),
                  child: Text('select'.tr()),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
