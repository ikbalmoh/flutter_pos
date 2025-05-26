import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/customer/customer_vehicle.dart';

class VehicleForm extends StatefulWidget {
  const VehicleForm({super.key, this.vehicle});

  final CustomerVehicle? vehicle;

  @override
  State<VehicleForm> createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm> {
  final _formKey = GlobalKey<FormState>();

  CustomerVehicle vehicle = CustomerVehicle(
    idVehicle: 0,
    vehicleType: '',
    vehicleBrand: '',
    licensePlate: '',
  );

  void onSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    context.pop(vehicle);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      height: MediaQuery.of(context).size.height *
          (MediaQuery.of(context).viewInsets.bottom > 0 ? 0.9 : 0.6),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 3, left: 5, right: 5),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'new_x'.tr(args: ['vehicle'.tr()]),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.close))
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: vehicle.vehicleType,
                    decoration: InputDecoration(
                      labelText: 'vehicle_type'.tr(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'field_cannot_empty'
                            .tr(args: ['vehicle_type'.tr().toLowerCase()]);
                      }
                      return null;
                    },
                    onChanged: (value) {
                      vehicle = vehicle.copyWith(vehicleType: value);
                    },
                  ),
                  TextFormField(
                    initialValue: vehicle.vehicleBrand,
                    decoration: InputDecoration(
                      labelText: 'Brand',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'field_cannot_empty'.tr(args: ['brand']);
                      }
                      return null;
                    },
                    onChanged: (value) {
                      vehicle = vehicle.copyWith(vehicleBrand: value);
                    },
                  ),
                  TextFormField(
                    initialValue: vehicle.licensePlate,
                    decoration: InputDecoration(
                      labelText: 'vehicle_number'.tr(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'field_cannot_empty'
                            .tr(args: ['vehicle_number'.tr().toLowerCase()]);
                      }
                      return null;
                    },
                    onChanged: (value) {
                      vehicle = vehicle.copyWith(licensePlate: value);
                    },
                  ),
                ],
              ),
            )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onSubmit,
              child: Text('save'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
