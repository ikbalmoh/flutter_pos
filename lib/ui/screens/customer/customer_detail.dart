import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/customer/customer.dart';
import 'package:selleri/utils/formater.dart';

class CustomerDetail extends StatelessWidget {
  final Customer customer;
  final Function(Customer) onSelect;
  final Function(Customer) onEdit;

  const CustomerDetail({
    required this.customer,
    required this.onSelect,
    required this.onEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget listTile(String title, String? value) =>
        value != null && value.isNotEmpty
            ? ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                dense: true,
                title: Text(title),
                subtitle: Text(value),
                shape: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.blueGrey.shade50,
                  ),
                ),
              )
            : Container();

    bool isExpired = customer.expiredDate != null
        ? DateTimeFormater.stringToDateTime(customer.expiredDate!)!
            .isBefore(DateTime.now())
        : false;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
                top: 10, left: 12.5, right: 12.5, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Colors.blueGrey.shade100,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'customer_detail'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              shrinkWrap: true,
              children: [
                listTile('customer_code'.tr(), customer.code.trim()),
                listTile('customer_name'.tr(), customer.customerName.trim()),
                listTile('group'.tr(), customer.groupNames),
                listTile('Email', customer.email),
                listTile('phone'.tr(), customer.phoneNumber),
                listTile('address'.tr(), customer.address),
                listTile('barcode'.tr(), customer.barcode),
                listTile('expired_date'.tr(),
                    customer.expiredDate != null ? customer.expiredDate! : '-'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  width: 0.5,
                  color: Colors.blueGrey.shade100,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 10,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue.shade700,
                  ),
                  onPressed: () => onEdit(customer),
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue.shade700,
                  ),
                  label: Text('edit'.tr(args: ['customer'.tr()])),
                ),
                if (!isExpired)
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => onSelect(customer),
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    label: Text('select'.tr()),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
