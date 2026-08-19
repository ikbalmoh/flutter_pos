import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/features/customer/model/customer.dart';
import 'package:selleri/features/customer/model/customer_vehicle.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/shared/model/custom_field.dart';
import 'package:selleri/shared/utils/formater.dart';
import 'package:selleri/shared/widget/custom_field_input.dart';

class CustomerDetail extends ConsumerStatefulWidget {
  final Customer customer;
  final List<CustomField>? customFields;
  final Function(
    Customer, {
    CustomerVehicle? vehicle,
    List<CustomField>? customFields,
    bool skipCustomField,
  })
  onSelect;
  final Function(Customer) onEdit;
  final bool isSelected;
  final CustomerVehicle? vehicle;

  const CustomerDetail({
    required this.customer,
    required this.onSelect,
    required this.onEdit,
    required this.isSelected,
    required this.vehicle,
    required this.customFields,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomerDetailState();
}

class _CustomerDetailState extends ConsumerState<CustomerDetail> {
  CustomerVehicle? selectedVehicle;
  List<CustomField> customFields = [];
  bool skipCustomField = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    setState(() {
      selectedVehicle =
          widget.vehicle != null &&
              widget.customer.vehicles?.contains(widget.vehicle) == true
          ? widget.vehicle
          : null;

      customFields = List.from(widget.customFields ?? []);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final outletConfig = ref.watch(outletProvider).value as OutletSelected;
    final customerMandatoryConfig =
        outletConfig.config.customMandatoryConfig.customers;

    final bool vehicleEnabled = customerMandatoryConfig.containsKey('vehicle');
    final bool customFieldEnabled =
        outletConfig.config.customFields?.modules.transaction?.isNotEmpty ??
        false;

    bool isExpired = widget.customer.expiredDate != null
        ? DateTimeFormater.stringToDateTime(
            widget.customer.expiredDate!,
          )!.isBefore(DateTime.now())
        : false;

    Widget selectButton() {
      return TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            widget.onSelect(
              widget.customer,
              vehicle: selectedVehicle,
              customFields: customFields,
              skipCustomField: skipCustomField,
            );
          }
        },
        icon: const Icon(Icons.check, color: Colors.white),
        label: Text('select'.tr()),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 10,
                left: 12.5,
                right: 12.5,
                bottom: 10,
              ),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.customer.customerName.trim(),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          widget.customer.code.trim(),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: Colors.blueGrey.shade600),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.close, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey.shade50,
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(15),
                  children: [
                    customerInformation(customerMandatoryConfig),
                    SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: Column(
                        spacing: 10,
                        children: [
                          if (vehicleEnabled) vehicleCard(),
                          if (customFieldEnabled) additionalInformation(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            if (MediaQuery.of(context).viewInsets.bottom == 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 10,
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue.shade700,
                      ),
                      onPressed: () => widget.onEdit(widget.customer),
                      icon: Icon(Icons.edit, color: Colors.blue.shade700),
                      label: Text('edit'.tr(args: ['']).trim()),
                    ),
                    if (!isExpired) selectButton(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget divider = Divider(
    height: 1,
    thickness: 0.5,
    color: Colors.blueGrey.shade100,
  );

  Widget listTile(String title, String? value) => ListTile(
    dense: true,
    visualDensity: VisualDensity.compact,
    title: Text(title),
    subtitle: Text(value ?? '-'),
  );

  Widget customerInformation(Map<String, bool> config) {
    List<Widget> informationTiles() {
      List<Widget> tiles = [];
      if (config.containsKey('groups')) {
        tiles.add(listTile('group'.tr(), widget.customer.groupNames ?? ''));
      }
      if (config.containsKey('email')) {
        tiles.add(listTile('Email', widget.customer.email));
      }
      if (config.containsKey('phone_number')) {
        tiles.add(listTile('phone'.tr(), widget.customer.phoneNumber));
      }
      if (config.containsKey('address')) {
        tiles.add(listTile('address'.tr(), widget.customer.address));
      }
      if (config.containsKey('barcode')) {
        tiles.add(listTile('barcode'.tr(), widget.customer.barcode));
      }
      if (config.containsKey('postal_code')) {
        tiles.add(listTile('postal_code'.tr(), widget.customer.postalCode));
      }
      if (config.containsKey('expired_date')) {
        tiles.add(listTile('expired_date'.tr(), widget.customer.expiredDate));
      }
      return tiles;
    }

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(15),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => informationTiles()[index],
        separatorBuilder: (context, idx) => divider,
        itemCount: informationTiles().length,
      ),
    );
  }

  Widget vehicleCard() {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(15),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 15,
              bottom: 8,
            ),
            child: Text('select_x'.tr(args: ['vehicle'.tr()])),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 12),
            itemBuilder: (context, idx) {
              if (idx == 0) {
                return ListTile(
                  onTap: () => setState(() {
                    selectedVehicle = null;
                  }),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 15,
                  ),
                  dense: false,
                  title: Text('without_vehicle'.tr()),
                  horizontalTitleGap: 10,
                  leading: Icon(Icons.person, size: 20),
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
                contentPadding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                dense: true,
                title: Text(
                  vehicle.licensePlate.isNotEmpty
                      ? vehicle.licensePlate.toUpperCase()
                      : '-',
                ),
                subtitle: Text(
                  '${vehicle.vehicleType} - ${vehicle.vehicleBrand}',
                ),
                horizontalTitleGap: 10,
                leading: Icon(Icons.drive_eta_rounded, size: 20),
                trailing: Icon(
                  selectedVehicle == vehicle
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  size: 18,
                  color: selectedVehicle == vehicle
                      ? Colors.teal
                      : Colors.blueGrey,
                ),
                visualDensity: VisualDensity.compact,
                minVerticalPadding: 0,
                minTileHeight: 0,
              );
            },
            itemCount: widget.customer.vehicles!.length + 1,
          ),
        ],
      ),
    );
  }

  Widget additionalInformation() {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(15),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 15,
              bottom: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('additional_information'.tr()),
                SizedBox(
                  height: 35,
                  width: 45,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Switch(
                      value: !skipCustomField,
                      onChanged: (v) => setState(() {
                        skipCustomField = !v;
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!skipCustomField)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: customFields.map((field) {
                  return CustomFieldInput(
                    field: field,
                    value: field.value,
                    onValueChange: (value) {
                      setState(() {
                        customFields = customFields.map((f) {
                          if (f.id == field.id) {
                            return f.copyWith(value: value);
                          }
                          return f;
                        }).toList();
                      });
                    },
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
