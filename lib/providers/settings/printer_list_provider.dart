import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:permission_handler/permission_handler.dart';

part 'printer_list_provider.g.dart';

@riverpod
class PrinterListNotifier extends _$PrinterListNotifier {
  @override
  FutureOr<List<BluetoothInfo>> build() async {
    startScanDevices();
    return [];
  }

  void startScanDevices() async {
    state = const AsyncLoading();
    try {
      log('START SCAN PRINTERS...');

      final bool isBluetoothEnabled =
          await PrintBluetoothThermal.bluetoothEnabled;
      log('BLUETOOTH ENABLED? $isBluetoothEnabled');
      if (!isBluetoothEnabled) {
        throw Exception('bluetooth disabled');
      }

      final scanPermission = await Permission.bluetoothScan.request();
      log('Scan permission : ${scanPermission.isGranted}');

      final bool isPermissionGranted =
          await PrintBluetoothThermal.isPermissionBluetoothGranted;
      if (!isPermissionGranted) {
        log('PERMISSION NOT GRANTED');
        throw Exception('Permission not granted');
      }

      final List<BluetoothInfo> devices =
          await PrintBluetoothThermal.pairedBluetooths;
      log('SCAN RESULTS: $devices');
      state = AsyncData(devices);
    } catch (e) {
      log('SCAN PRINTER ERROR: $e');
      state = AsyncError(e, StackTrace.current);
    }
  }
}
