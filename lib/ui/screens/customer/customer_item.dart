import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/customer.dart';

class CustomerItem extends StatelessWidget {
  const CustomerItem({
    super.key,
    required this.customer,
    required this.selected,
    required this.onTap,
  });

  final Customer customer;
  final bool selected;
  final Function(Customer) onTap;

  @override
  Widget build(BuildContext context) {
    bool isExpired = customer.expiredDate != null
        ? customer.expiredDate!.isBefore(DateTime.now())
        : false;

    return ListTile(
      title: Text(customer.customerName.trim()),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customer.code.trim()),
          customer.groups != null && customer.groups!.isNotEmpty
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.blue.shade50),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.person_2_fill,
                        size: 16,
                        color: Colors.blue.shade600,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        customer.groups!
                            .map((group) => group.groupName)
                            .join(', '),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.blue.shade600),
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
      shape: Border(
        bottom: BorderSide(
          width: 0.5,
          color: Colors.blueGrey.shade50,
        ),
      ),
      onTap: () => onTap(customer),
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
                    borderRadius: BorderRadius.circular(20),
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
  }
}
