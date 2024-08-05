import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:permission_handler/permission_handler.dart';

part 'printer_list_provider.g.dart';

@riverpod
class PrinterList extends _$PrinterList {
  @override
  FutureOr<List<BluetoothInfo>> build() async {
    startScanDevices();
    return [];
  }

  void startScanDevices() async {
    state = const AsyncLoading();
    try {
      log('START SCAN PRINTERS...');

      if (Platform.isIOS) {
        bool scanPermission = false;
        [Permission.bluetooth].request().then((status) {
          if (status[Permission.bluetooth] == PermissionStatus.granted) {
            scanPermission = true;
          } else {
            scanPermission = false;
          }
          if (!scanPermission) {
            throw Exception('Permission not granted');
          }
        });
      } else {
        final scanPermission = await Permission.bluetoothScan.request();
        log('Scan permission : ${scanPermission.isGranted}');

        final bluetoothPermission = await Permission.bluetoothConnect.request();
        log('Connect permission : ${bluetoothPermission.isGranted}');

        if (!scanPermission.isGranted || !bluetoothPermission.isGranted) {
          throw Exception('Permission not granted');
        }
      }

      final List<BluetoothInfo> devices =
          await PrintBluetoothThermal.pairedBluetooths;
      log('SCAN RESULTS: $devices');
      if (devices.isNotEmpty) {
        state = AsyncData(devices);
      } else {
        throw 'no_device_found'.tr();
      }
    } catch (e) {
      log('SCAN PRINTER ERROR: $e');
      state = AsyncError(e, StackTrace.current);
    } finally {
      log('SCAN PRINTER DONE');
    }
  }
}
