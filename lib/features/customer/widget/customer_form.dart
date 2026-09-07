// ignore_for_file: unused_import

import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter/services.dart';
import 'package:selleri/app/widget/app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/features/customer/constant.dart';
import 'package:selleri/features/customer/model/customer.dart';
import 'package:selleri/features/customer/model/customer_group.dart';
import 'package:selleri/features/customer/model/customer_vehicle.dart';
import 'package:selleri/shared/model/option.dart';
import 'package:selleri/features/outlet/model/outlet_config.dart';
import 'package:selleri/features/shift/model/shift_cashflow.dart';
import 'package:selleri/features/shift/model/shift_cashflow_image.dart';
import 'package:selleri/features/shift/model/shift_info.dart';
import 'package:selleri/features/customer/provider/customer_groups_provider.dart';
import 'package:selleri/features/customer/provider/customer_list_provider.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/shift/provider/current_shift_info_provider.dart';
import 'package:selleri/features/shift/provider/shift_notifier_provider.dart';
import 'package:selleri/shared/widget/error_handler.dart';
import 'package:selleri/shared/widget/generic/button_selection.dart';
import 'package:selleri/shared/widget/generic/loading_placeholder.dart';
import 'package:selleri/shared/widget/generic/picked_image.dart';
import 'package:selleri/features/customer/widget/vehicle_form.dart';
import 'package:selleri/shared/utils/app_alert.dart';
import 'package:selleri/shared/utils/authorization_helper.dart';
import 'package:selleri/shared/utils/formater.dart';
import 'package:image_picker/image_picker.dart';

class CustomerForm extends ConsumerStatefulWidget {
  const CustomerForm({required this.query, this.customer, super.key});

  final String query;
  final Customer? customer;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomerFormState();
}

class _CustomerFormState extends ConsumerState<CustomerForm> {
  final _formKey = GlobalKey<FormState>();

  Customer customer = Customer.initial();

  bool isLoading = false;

  Map<String, String> errors = {};

  @override
  void initState() {
    if (widget.customer != null) {
      customer = widget.customer!;
    } else if (widget.query.isNotEmpty) {
      customer = customer.copyWith(customerName: widget.query);
    }
    super.initState();
  }

  void pickDob() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
      initialDate: customer.dob != null
          ? DateTime.parse(customer.dob!)
          : DateTime.now().subtract(Duration(days: 365 * 18)),
    );
    if (pickedDate != null) {
      setState(() {
        customer = customer.copyWith(dob: pickedDate.toString());
      });
    }
  }

  void picExpiredDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 365 * 10)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      initialDate: customer.expiredDate != null
          ? DateTimeFormater.stringToDateTime(customer.expiredDate!)
          : DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        customer = customer.copyWith(
          expiredDate: DateTimeFormater.dateToString(pickedDate),
        );
      });
    }
  }

  void showVehicleForm() async {
    CustomerVehicle? vehicle = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      useSafeArea: true,
      builder: (context) {
        return VehicleForm();
      },
    );
    if (vehicle != null) {
      setState(() {
        customer = customer.copyWith(
          vehicles: customer.vehicles != null
              ? [...customer.vehicles!, vehicle]
              : [vehicle],
        );
      });
    }
  }

  void submitCustomer({bool? isDelete}) async {
    Map<String, String> otherErrors = {};
    final outletConfig = ref.watch(outletProvider).value as OutletSelected;
    final customerMandatory =
        outletConfig.config.customMandatoryConfig.customers;

    if (customerMandatory['groups'] == true &&
        (customer.groups == null || customer.groups!.isEmpty)) {
      otherErrors['groups'] = 'field_required'.tr(
        args: ['groups'.tr().toLowerCase()],
      );
    }
    if (customerMandatory['dob'] == true && customer.dob == null) {
      otherErrors['dob'] = 'field_required'.tr(
        args: ['dob'.tr().toLowerCase()],
      );
    }
    if (customerMandatory['expired_date'] == true &&
        customer.expiredDate == null) {
      otherErrors['expired_date'] = 'field_required'.tr(
        args: ['expired_date'.tr().toLowerCase()],
      );
    }
    setState(() {
      errors = otherErrors;
    });
    if (!_formKey.currentState!.validate() || otherErrors.isNotEmpty) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      Map<String, dynamic> data = customer.toPayload();
      if (widget.customer == null) {
        await ref.read(customerListProvider.notifier).submitNewCustomer(data);
      } else {
        await AuthorizationHelper.authorize('edit-customer');
        if (!mounted) return;
        await ref
            .read(customerListProvider.notifier)
            .updateCustomer(widget.customer!.idCustomer, payload: data);
      }
      // ignore: use_build_context_synchronously
      context.pop();
      AppAlert.toast(
        widget.customer == null
            ? 'successfully_stored'.tr(args: ['customer'.tr()])
            : 'successfully_updated'.tr(args: ['customer'.tr()]),
      );
    } catch (e) {
      AppAlert.snackbar(e.toString(), alertType: AlertType.error);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String? validateField(String fieldName, String? value) {
    final outletConfig = ref.watch(outletProvider).value as OutletSelected;
    final customerMandatory =
        outletConfig.config.customMandatoryConfig.customers;

    if (customerMandatory.containsKey(fieldName) &&
        customerMandatory[fieldName] == true) {
      if (value == null || value.isEmpty) {
        return 'field_required'.tr(args: [fieldName.tr().toLowerCase()]);
      }
    }

    if (fieldName == 'email' && value != null && value.isNotEmpty) {
      // ignore: deprecated_member_use
      if (!RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      ).hasMatch(value)) {
        return 'invalid_email'.tr();
      }
    }

    return null;
  }

  void onSelectGroup(bool selected, CustomerGroup group) {
    List<CustomerGroup> groups = customer.groups != null
        ? List.from(customer.groups!)
        : [];
    if (selected) {
      groups.add(
        CustomerGroup(
          id: group.id,
          groupId: group.groupId,
          groupName: group.groupName,
        ),
      );
    } else {
      groups.removeWhere((element) => element.groupId == group.groupId);
    }
    setState(() {
      customer = customer.copyWith(groups: groups);
    });
  }

  void removeVehicle(int idVehicle) {
    setState(() {
      customer = customer.copyWith(
        vehicles: customer.vehicles
            ?.where((element) => element.idVehicle != idVehicle)
            .toList(),
      );
    });
  }

  Text labelWidget(String fieldName) {
    final outletConfig = ref.watch(outletProvider).value as OutletSelected;
    List<String> customerMandatory =
        outletConfig.config.customMandatory.customers;

    String label = fieldName.tr();
    bool isMandatory = customerMandatory.contains(fieldName);

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: label.capitalize()),
          if (isMandatory)
            TextSpan(
              text: " *",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.red),
            ),
        ],
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey.shade600),
      ),
    );
  }

  Widget customerData(Map<String, bool> config) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'data_x'.tr(args: ['customer'.tr()]),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Divider(color: Colors.blueGrey.shade50),
            if (config.isNotEmpty && config.containsKey('customer_name'))
              TextFormField(
                initialValue: customer.customerName,
                onChanged: (value) {
                  setState(() {
                    customer = customer.copyWith(customerName: value);
                  });
                },
                validator: (value) => validateField('customer_name', value),
                decoration: InputDecoration(
                  label: labelWidget('customer_name'),
                  alignLabelWithHint: true,
                ),
              ),
            if (config.isNotEmpty && config.containsKey('dob'))
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Colors.blueGrey.shade100,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    labelWidget('dob'),
                    TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: Colors.teal),
                      icon: const Icon(Icons.calendar_month, size: 18),
                      onPressed: pickDob,
                      label: Text(
                        customer.dob != null
                            ? DateTimeFormater.dateToString(
                                DateTime.parse(customer.dob!),
                                format: 'dd MMM yyyy',
                              )
                            : 'select'.tr(),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),
            if (config.isNotEmpty && config.containsKey('card_id'))
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  labelWidget('card_id'),
                  Flexible(
                    child: DropdownButton<Option>(
                      items: cardIdOptions.map<DropdownMenuItem<Option>>((
                        Option option,
                      ) {
                        return DropdownMenuItem<Option>(
                          value: option,
                          child: Text(option.text),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() {
                        customer = customer.copyWith(cardId: value?.id);
                      }),
                      value: cardIdOptions.firstWhereOrNull(
                        (option) => option.id == customer.cardId,
                      ),
                      dropdownColor: Colors.white,
                      hint: Text('select_x'.tr(args: ['card_id'.tr()])),
                      underline: const SizedBox(),
                      style: Theme.of(context).textTheme.titleSmall,
                      isDense: true,
                    ),
                  ),
                ],
              ),
            if (config.isNotEmpty && config.containsKey('card_id_number'))
              TextFormField(
                initialValue: customer.cardIdNumber,
                onChanged: (value) {
                  setState(() {
                    customer = customer.copyWith(cardIdNumber: value);
                  });
                },
                validator: (value) => validateField('card_id_number', value),
                decoration: InputDecoration(
                  label: labelWidget('card_id_number'),
                  alignLabelWithHint: true,
                ),
              ),
            if (config.isNotEmpty && config.containsKey('email'))
              TextFormField(
                initialValue: customer.email,
                onChanged: (value) {
                  setState(() {
                    customer = customer.copyWith(email: value);
                  });
                },
                validator: (value) => validateField('email', value),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  label: labelWidget('email'),
                  alignLabelWithHint: true,
                ),
              ),
            if (config.isNotEmpty && config.containsKey('barcode'))
              TextFormField(
                initialValue: customer.barcode,
                onChanged: (value) {
                  setState(() {
                    customer = customer.copyWith(barcode: value);
                  });
                },
                decoration: InputDecoration(
                  label: labelWidget('barcode'),
                  alignLabelWithHint: true,
                ),
                validator: (value) => validateField('barcode', value),
              ),
            if (config.isNotEmpty && config.containsKey('phone_number'))
              TextFormField(
                initialValue: customer.phoneNumber,
                onChanged: (value) {
                  setState(() {
                    customer = customer.copyWith(phoneNumber: value);
                  });
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  label: labelWidget('phone_number'),
                  alignLabelWithHint: true,
                ),
                validator: (value) => validateField('phone_number', value),
              ),
            if (config.isNotEmpty && config.containsKey('npwp'))
              TextFormField(
                initialValue: customer.npwp,
                onChanged: (value) {
                  setState(() {
                    customer = customer.copyWith(npwp: value);
                  });
                },
                decoration: InputDecoration(
                  label: labelWidget('npwp'),
                  alignLabelWithHint: true,
                ),
                validator: (value) => validateField('npwp', value),
              ),
            SizedBox(height: 30),
            if (config.isNotEmpty && config.containsKey('province') ||
                config.isNotEmpty && config.containsKey('city') ||
                config.isNotEmpty && config.containsKey('address') ||
                config.isNotEmpty && config.containsKey('postal_code'))
              Text(
                'address'.tr(),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            Divider(color: Colors.blueGrey.shade50),
            if (config.isNotEmpty && config.containsKey('province'))
              TextFormField(
                initialValue: customer.province,
                onChanged: (value) {
                  setState(() {
                    customer = customer.copyWith(province: value);
                  });
                },
                decoration: InputDecoration(
                  label: labelWidget('province'),
                  alignLabelWithHint: true,
                ),
                validator: (value) => validateField('province', value),
              ),
            if (config.isNotEmpty && config.containsKey('city'))
              TextFormField(
                initialValue: customer.city,
                onChanged: (value) {
                  setState(() {
                    customer = customer.copyWith(city: value);
                  });
                },
                decoration: InputDecoration(
                  label: labelWidget('city'),
                  alignLabelWithHint: true,
                ),
                validator: (value) => validateField('city', value),
              ),
            if (config.isNotEmpty && config.containsKey('address'))
              TextFormField(
                initialValue: customer.address,
                onChanged: (value) => setState(() {
                  customer = customer.copyWith(address: value);
                }),
                decoration: InputDecoration(
                  label: labelWidget('address'),
                  hintText: 'add'.tr(args: ['address'.tr()]),
                  alignLabelWithHint: true,
                ),
                validator: (value) => validateField('address', value),
              ),
            if (config.isNotEmpty && config.containsKey('postal_code'))
              TextFormField(
                initialValue: customer.postalCode,
                onChanged: (value) => setState(() {
                  customer = customer.copyWith(postalCode: value);
                }),
                decoration: InputDecoration(
                  label: labelWidget('postal_code'),
                  hintText: 'add'.tr(args: ['postal_code'.tr()]),
                  alignLabelWithHint: true,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => validateField('postal_code', value),
              ),
          ],
        ),
      ),
    );
  }

  Widget customerMembership(Map<String, bool> config) {
    if (!config.isNotEmpty && config.containsKey('expired_date') && !config.isNotEmpty && config.containsKey('groups')) {
      return SizedBox.shrink();
    }

    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'membership'.tr(),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Divider(color: Colors.blueGrey.shade50),
            if (config.isNotEmpty && config.containsKey('expired_date'))
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Colors.blueGrey.shade100,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    labelWidget('expired_date'),
                    TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: Colors.teal),
                      icon: const Icon(Icons.calendar_month, size: 18),
                      onPressed: picExpiredDate,
                      label: Text(
                        customer.expiredDate != null
                            ? customer.expiredDate!
                            : 'select'.tr(),
                      ),
                    ),
                  ],
                ),
              ),
            if (errors.isNotEmpty && errors['expired_date'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  errors['expired_date'] ?? '',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.red),
                ),
              ),
            SizedBox(height: 15),
            if (config.isNotEmpty && config.containsKey('groups'))
              Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  labelWidget('groups'),
                  ref
                      .watch(customerGroupsProvider)
                      .when(
                        data: (data) => data.isEmpty
                            ? Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  'no_data'.tr(args: ['groups'.tr()]),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey.shade500),
                                ),
                              )
                            : Wrap(
                                spacing: 5.0,
                                children: List<Widget>.generate(data.length, (
                                  int index,
                                ) {
                                  return ChoiceChip(
                                    label: Text(data[index].text),
                                    selected: customer.groups != null
                                        ? customer.groups!.any(
                                            (element) =>
                                                element.groupId ==
                                                data[index].id,
                                          )
                                        : false,
                                    onSelected: (selected) => onSelectGroup(
                                      selected,
                                      CustomerGroup(
                                        id: data[index].id,
                                        groupId: data[index].id,
                                        groupName: data[index].text,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                        error: (error, stackTrace) => ErrorHandler(
                          error: error,
                          stackTrace: stackTrace.toString(),
                        ),
                        loading: () => Container(),
                      ),
                  if (errors.isNotEmpty && errors['groups'] != null)
                    Text(
                      errors['groups'] ?? '',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.red),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget customerVehicle(Map<String, bool> config) {
    if (!config.isNotEmpty && config.containsKey('vehicle')) {
      return SizedBox.shrink();
    }

    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'vehicle'.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: showVehicleForm,
                  label: Text('new_x'.tr(args: ['vehicle'.tr()])),
                  icon: const Icon(CupertinoIcons.add, size: 16),
                ),
              ],
            ),
            Divider(color: Colors.blueGrey.shade50, height: 0),
            customer.vehicles == null || customer.vehicles!.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 100,
                      horizontal: 30,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.car_fill,
                            size: 50,
                            color: Colors.grey.shade400,
                          ),
                          Text(
                            'no_x_added'.tr(args: ['vehicle'.tr()]),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.grey.shade500),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      for (var vehicle in customer.vehicles!)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    vehicle.vehicleBrand,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: Colors.blueGrey.shade700,
                                        ),
                                  ),
                                  Text(
                                    vehicle.licensePlate,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Colors.blueGrey.shade600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              vehicle.vehicleType,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.blueGrey.shade600),
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 18),
                              onPressed: () => removeVehicle(vehicle.idVehicle),
                              color: Colors.red,
                            ),
                          ],
                        ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    final outletConfig = ref.watch(outletProvider).value as OutletSelected;
    final fieldConfig = outletConfig.config.customMandatoryConfig.customers;

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        elevation: 3,
        title: Text(
          widget.customer == null
              ? 'add'.tr(args: ['customer'.tr()])
              : 'edit'.tr(args: ['customer'.tr()]),
        ),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Colors.teal,
              backgroundColor: Colors.teal.shade50,
            ),
            onPressed: isLoading ? null : submitCustomer,
            icon: isLoading
                ? const SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(strokeWidth: 1),
                  )
                : const Icon(Icons.check),
            label: Text(
              widget.customer == null ? 'submit'.tr() : 'update'.tr(),
            ),
          ),
          SizedBox(width: 15),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10).copyWith(bottom: 80),
                  child: Column(
                    spacing: 10,
                    children: [
                      customerData(fieldConfig),
                      if (!isTablet) customerMembership(fieldConfig),
                      if (!isTablet) customerVehicle(fieldConfig),
                    ],
                  ),
                ),
              ),
              isTablet
                  ? SizedBox(
                      width:
                          ResponsiveBreakpoints.of(
                            context,
                          ).largerOrEqualTo(DESKTOP)
                          ? MediaQuery.of(context).size.width - 400
                          : MediaQuery.of(context).size.width * 0.5,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Column(
                          spacing: 10,
                          children: [
                            customerMembership(fieldConfig),
                            customerVehicle(fieldConfig),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
