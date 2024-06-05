import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';

part 'printer_provider.g.dart';

@Riverpod(keepAlive: true)
class PrinterNotifier extends _$PrinterNotifier {
  @override
  FutureOr<List<dynamic>> build() {
    final printerManager = PrinterBluetoothManager();
    printerManager.scanResults.listen((devices) async {
      print('SCAN PRINTER DEVICES RESULT: ${devices.length}');
      state = AsyncData(devices);
    });

    return [];
  }

  void startScanDevices() async {
    print('SCAN PRINTERS...');
    final printerManager = PrinterBluetoothManager();

    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();
    await Permission.locationWhenInUse.request();

    Permission.bluetooth.onGrantedCallback(() {
      printerManager.startScan(const Duration(seconds: 5));
    }).request();
  }

  void stopScanDevices() {
    final printerManager = PrinterBluetoothManager();

    printerManager.stopScan();
  }
}
