import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/features/customer/model/customer.dart';
import 'package:selleri/features/customer/model/customer_vehicle.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/shared/utils/formater.dart';

class CustomerDetail extends ConsumerWidget {
  final Customer customer;
  final Function(Customer, {CustomerVehicle? vehicle}) onSelect;
  final Function(Customer) onEdit;

  const CustomerDetail({
    required this.customer,
    required this.onSelect,
    required this.onEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outletConfig = ref.watch(outletProvider).value as OutletSelected;
    List<String> customerMandatory =
        outletConfig.config.customMandatory?.customers ?? [];

    bool vehicleEnabled = customerMandatory.contains('vehicle');

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

    Widget selectButton() {
      ButtonStyle style = ButtonStyle(
        overlayColor: WidgetStateProperty.all<Color>(
            Colors.teal.shade200.withValues(alpha: 0.2)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        padding: WidgetStateProperty.all<EdgeInsets?>(
            EdgeInsets.symmetric(horizontal: 17)),
      );

      return vehicleEnabled &&
              customer.vehicles != null &&
              customer.vehicles!.isNotEmpty
          ? MenuAnchor(
              alignmentOffset: Offset(-120, -30),
              useRootOverlay: true,
              menuChildren: [
                MenuItemButton(
                  child: Text(
                    'select_vehicle'.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: Colors.grey.shade600),
                  ),
                ),
                ...customer.vehicles!.map(
                  (v) => MenuItemButton(
                    onPressed: () => onSelect(customer, vehicle: v),
                    style: style,
                    leadingIcon: Icon(
                      Icons.drive_eta_rounded,
                      size: 22,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          v.licensePlate,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          v.vehicleType,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ),
                MenuItemButton(
                  onPressed: () => onSelect(customer),
                  style: style,
                  leadingIcon: Icon(
                    Icons.person,
                    size: 22,
                  ),
                  child: Text('without_vehicle'.tr()),
                ),
                PopupMenuDivider(
                  thickness: 0.2,
                ),
                MenuItemButton(
                  onPressed: () => {},
                  style: style.copyWith(
                    iconColor:
                        WidgetStateProperty.all<Color>(Colors.grey.shade600),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.grey.shade600),
                    overlayColor: WidgetStateProperty.all<Color>(
                        Colors.red.shade200.withValues(alpha: 0.1)),
                  ),
                  leadingIcon: Icon(
                    Icons.undo,
                    size: 22,
                  ),
                  child: Text('cancel'.tr()),
                ),
              ],
              builder: (context, controller, child) {
                return TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  label: Text('select'.tr()),
                );
              },
              style: MenuStyle(
                backgroundColor: WidgetStateProperty.all<Color?>(Colors.white),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                padding:
                    WidgetStateProperty.all<EdgeInsets?>(EdgeInsets.all(10)),
                elevation: WidgetStateProperty.all<double>(15),
              ),
            )
          : TextButton.icon(
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
            );
    }

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
                if (customer.vehicles?.isNotEmpty == true) ...[
                  SizedBox(height: 12),
                  Text('vehicle'.tr()),
                  SizedBox(height: 5),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, idx) {
                      final vehicle = customer.vehicles![idx];
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        dense: true,
                        title: Text(vehicle.licensePlate),
                        subtitle: Text(
                            '${vehicle.vehicleType} - ${vehicle.vehicleBrand}'),
                        horizontalTitleGap: 10,
                        leading: Icon(
                          Icons.drive_eta_rounded,
                          size: 22,
                        ),
                        visualDensity: VisualDensity.compact,
                        minVerticalPadding: 0,
                        minTileHeight: 0,
                      );
                    },
                    itemCount: customer.vehicles!.length,
                  )
                ],
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
                if (!isExpired) selectButton()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
