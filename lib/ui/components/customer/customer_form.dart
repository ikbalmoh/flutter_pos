// ignore_for_file: unused_import

import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/shift_cashflow.dart';
import 'package:selleri/data/models/shift_cashflow_image.dart';
import 'package:selleri/data/models/shift_info.dart';
import 'package:selleri/providers/customer/customer_list_provider.dart';
import 'package:selleri/providers/shift/current_shift_info_provider.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/ui/components/generic/button_selection.dart';
import 'package:selleri/ui/components/generic/loading_placeholder.dart';
import 'package:selleri/ui/components/picked_image.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/formater.dart';
import 'package:image_picker/image_picker.dart';

class CustomerForm extends ConsumerStatefulWidget {
  const CustomerForm({required this.query, super.key});

  final String query;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomerFormState();
}

class _CustomerFormState extends ConsumerState<CustomerForm> {
  final _formKey = GlobalKey<FormState>();

  String customerName = '';
  DateTime dob = DateTime.now();
  String email = '';
  String barcode = '';
  String phoneNumber = '';
  String address = '';

  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      customerName = widget.query;
    });
    super.initState();
  }

  void pickDob() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
      initialDate: dob,
    );
    if (pickedDate != null) {
      setState(() {
        dob = pickedDate;
      });
    }
  }

  void submitCloseShift({bool? isDelete}) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      Map<String, dynamic> data = {
        'customer_name': customerName,
        'dob': DateTimeFormater.dateToString(dob, format: 'y-MM-dd'),
        'email': email,
        'barcode': barcode,
        'phoneNumber': phoneNumber,
        'address': address,
      };
      await ref
          .read(customerListNotifierProvider.notifier)
          .submitNewCustomer(data);
      // ignore: use_build_context_synchronously
      context.pop();
      AppAlert.toast('saved'.tr());
    } on Exception catch (e, stackTrace) {
      log('submit cashflow error: $e => $stackTrace');
      AppAlert.toast(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? labelStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Colors.blueGrey.shade600);

    return PopScope(
      canPop: !isLoading,
      child: isLoading
          ? const LoadingPlaceholder()
          : SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 15,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: 20, left: 15, right: 15, bottom: 15),
                      decoration: BoxDecoration(
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
                            'add'.tr(args: ['customer'.tr()]),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: const Icon(
                              Icons.close,
                              color: Colors.grey,
                              size: 18,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        initialValue: customerName,
                        onChanged: (value) {
                          setState(() {
                            customerName = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'field_required'
                                .tr(args: ['customer_name'.tr().toLowerCase()]);
                          }
                          return null;
                        },
                        textAlign: TextAlign.right,
                        autofocus: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              left: 0, bottom: 15, right: 0),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          label: Text(
                            'customer_name'.tr(),
                            style: labelStyle,
                          ),
                          prefix: Text(
                            'customer_name'.tr(),
                            style: labelStyle,
                          ),
                          alignLabelWithHint: true,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 0.5,
                              color: Colors.blueGrey.shade100,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 0.5,
                              color: Colors.teal,
                            ),
                          ),
                          errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 0.5,
                              color: Colors.red,
                            ),
                          ),
                          focusedErrorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 0.5,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: Colors.blueGrey.shade100,
                        ),
                      )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'dob'.tr(),
                            style: labelStyle,
                          ),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.blue.shade600),
                            icon: const Icon(
                              Icons.calendar_month,
                              size: 18,
                            ),
                            onPressed: pickDob,
                            label: Text(DateTimeFormater.dateToString(dob,
                                format: 'd MMM y')),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        initialValue: email,
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              left: 0, bottom: 15, right: 0),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          label: Text(
                            'Email',
                            style: labelStyle,
                          ),
                          prefix: Text(
                            'Email',
                            style: labelStyle,
                          ),
                          alignLabelWithHint: true,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 0.5,
                              color: Colors.blueGrey.shade100,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 0.5,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        initialValue: barcode,
                        onChanged: (value) {
                          setState(() {
                            barcode = value;
                          });
                        },
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              left: 0, bottom: 15, right: 0),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          label: Text(
                            'Barcode',
                            style: labelStyle,
                          ),
                          prefix: Text(
                            'Barcode',
                            style: labelStyle,
                          ),
                          alignLabelWithHint: true,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 0.5,
                              color: Colors.blueGrey.shade100,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 0.5,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        initialValue: phoneNumber,
                        onChanged: (value) {
                          setState(() {
                            phoneNumber = value;
                          });
                        },
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              left: 0, bottom: 15, right: 0),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          label: Text(
                            'phone'.tr(),
                            style: labelStyle,
                          ),
                          prefix: Text(
                            'phone'.tr(),
                            style: labelStyle,
                          ),
                          alignLabelWithHint: true,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 0.5,
                              color: Colors.blueGrey.shade100,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 0.5,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        initialValue: address,
                        onChanged: (value) => setState(() {
                          address = value;
                        }),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              left: 0, top: 10, right: 0, bottom: 15),
                          label: Text(
                            'address'.tr(),
                            style: labelStyle,
                          ),
                          hintText: 'add'.tr(args: ['address'.tr()]),
                          alignLabelWithHint: true,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 0.5,
                              color: Colors.blueGrey.shade100,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 0.5,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                        ),
                        onPressed: isLoading ? null : submitCloseShift,
                        child: Text(
                          'submit'.tr(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
