import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/features/customer/model/customer.dart';
import 'package:selleri/features/customer/model/customer_vehicle.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/shared/utils/formater.dart';

class CustomerDetail extends ConsumerStatefulWidget {
  final Customer customer;
  final Function(Customer, {CustomerVehicle? vehicle}) onSelect;
  final Function(Customer) onEdit;
  final bool isSelected;
  final CustomerVehicle? vehicle;

  const CustomerDetail({
    required this.customer,
    required this.onSelect,
    required this.onEdit,
    required this.isSelected,
    required this.vehicle,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomerDetailState();
}

class _CustomerDetailState extends ConsumerState<CustomerDetail> {
  CustomerVehicle? selectedVehicle;

  @override
  void initState() {
    setState(() {
      selectedVehicle = widget.vehicle;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final outletConfig = ref.watch(outletProvider).value as OutletSelected;
    List<String> customerMandatory =
        outletConfig.config.customMandatory?.customers ?? [];

    bool vehicleEnabled = customerMandatory.contains('vehicle');

    Widget listTile(String title, String? value) =>
        value != null && value.isNotEmpty
            ? ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
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

    bool isExpired = widget.customer.expiredDate != null
        ? DateTimeFormater.stringToDateTime(widget.customer.expiredDate!)!
            .isBefore(DateTime.now())
        : false;

    Widget selectButton() {
      return TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        onPressed: () =>
            widget.onSelect(widget.customer, vehicle: selectedVehicle),
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
              // padding: const EdgeInsets.symmetric(horizontal: 15),
              shrinkWrap: true,
              children: [
                Column(
                  children: [
                    listTile('customer_code'.tr(), widget.customer.code.trim()),
                    listTile('customer_name'.tr(),
                        widget.customer.customerName.trim()),
                    listTile('group'.tr(), widget.customer.groupNames),
                    listTile('Email', widget.customer.email),
                    listTile('phone'.tr(), widget.customer.phoneNumber),
                    listTile('address'.tr(), widget.customer.address),
                    listTile('barcode'.tr(), widget.customer.barcode),
                    listTile(
                        'expired_date'.tr(),
                        widget.customer.expiredDate != null
                            ? widget.customer.expiredDate!
                            : '-'),
                  ],
                ),
                if (widget.customer.vehicles?.isNotEmpty == true) ...[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 15, bottom: 8),
                    child: Text(vehicleEnabled
                        ? 'select_vehicle'.tr()
                        : 'vehicle'.tr()),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, idx) {
                      if (idx == 0 && vehicleEnabled) {
                        return ListTile(
                          onTap: () => setState(() {
                            selectedVehicle = null;
                          }),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          dense: false,
                          title: Text('without_vehicle'.tr()),
                          horizontalTitleGap: 10,
                          leading: Icon(
                            Icons.person,
                            size: 20,
                          ),
                          trailing: Icon(
                            selectedVehicle == null
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off_rounded,
                            size: 18,
                            color: selectedVehicle == null
                                ? Colors.teal
                                : Colors.blueGrey,
                          ),
                          visualDensity: VisualDensity.compact,
                          minVerticalPadding: 0,
                          minTileHeight: 0,
                        );
                      }
                      final vehicle = widget.customer.vehicles![idx - 1];
                      return ListTile(
                        onTap: () => setState(() {
                          selectedVehicle = vehicle;
                        }),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        dense: true,
                        title: Text(vehicle.licensePlate),
                        subtitle: Text(
                            '${vehicle.vehicleType} - ${vehicle.vehicleBrand}'),
                        horizontalTitleGap: 10,
                        leading: Icon(
                          Icons.drive_eta_rounded,
                          size: 20,
                        ),
                        trailing: vehicleEnabled
                            ? Icon(
                                selectedVehicle == vehicle
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.radio_button_off_rounded,
                                size: 18,
                                color: selectedVehicle == vehicle
                                    ? Colors.teal
                                    : Colors.blueGrey,
                              )
                            : null,
                        visualDensity: VisualDensity.compact,
                        minVerticalPadding: 0,
                        minTileHeight: 0,
                      );
                    },
                    itemCount: widget.customer.vehicles!.length +
                        (vehicleEnabled ? 1 : 0),
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
                  onPressed: () => widget.onEdit(widget.customer),
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
