import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'dart:developer';
import 'package:selleri/features/settings/model/printer.dart' as model;
import 'package:selleri/shared/utils/printer.dart' as util;

part 'printer_provider.g.dart';

@Riverpod(keepAlive: true)
class Printer extends _$Printer {
  @override
  FutureOr<model.Printer?> build() async {
    const storage = FlutterSecureStorage();
    bool isEnable = await PrintBluetoothThermal.bluetoothEnabled;
    if (!isEnable) {
      return null;
    }

    final currentPrinter = await storage.read(key: 'printer');
    if (currentPrinter != null) {
      final printerJson = json.decode(currentPrinter);
      model.Printer printer = model.Printer.fromJson(printerJson);
      try {
        bool isConnected = await PrintBluetoothThermal.connect(
          macPrinterAddress: printer.macAddress,
        );
        if (!isConnected) {
          await storage.delete(key: 'printer');
        }
        return isConnected ? printer : null;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> connectPrinter(
    BluetoothInfo device, {
    required PaperSize size,
    bool cut = false,
    bool print = true,
    bool printImage = false,
  }) async {
    state = const AsyncLoading();
    try {
      const storage = FlutterSecureStorage();

      bool isConnected = await PrintBluetoothThermal.connectionStatus;
      if (!isConnected) {
        isConnected = await PrintBluetoothThermal.connect(
          macPrinterAddress: device.macAdress,
        );
      }
      log('CONNNECT STATUS: $isConnected');
      if (!isConnected) {
        state = const AsyncData(null);
        await storage.delete(key: 'printer');
        throw Exception(
          'connect_printer_failed'.tr(args: [device.name]),
        );
      }
      final printer = model.Printer(
        macAddress: device.macAdress,
        name: device.name,
        size: size,
        cut: cut,
        printImage: printImage,
      );

      await storage.write(key: 'printer', value: printer.toString());
      state = AsyncData(printer);
      await printTest();
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      log('CONNECT PRINTER FAILED: ${e.toString()}');
    }
  }

  void updatePrinter(
    BluetoothInfo device, {
    required PaperSize size,
    bool cut = false,
    bool printImage = false,
  }) async {
    const storage = FlutterSecureStorage();

    final printer = model.Printer(
      macAddress: device.macAdress,
      name: device.name,
      size: size,
      cut: cut,
      printImage: printImage,
    );
    await storage.write(key: 'printer', value: printer.toString());
    state = AsyncData(printer);
  }

  void disconnect() async {
    const storage = FlutterSecureStorage();

    bool disconnect = await PrintBluetoothThermal.disconnect;

    if (disconnect) {
      await storage.delete(key: 'printer');
      state = const AsyncData(null);
    }
  }

  Future<void> printTest() async {
    try {
      log('Test Print');
      final printer = await ref.read(printerProvider.future);
      if (printer == null) {
        throw 'printer_not_connected'.tr();
      }
      List<int> bytes = [];
      if (printer.printImage) {
        bytes = await util.Printer().buildTestPrinterCaptureBytes(
          size: printer.size,
          cut: printer.cut,
        );
      } else {
        bytes = await util.Printer().buildTestTicketBytes(
          size: printer.size,
          cut: printer.cut,
        );
      }
      log('Print Bytes: $bytes');
      await print(bytes);
    } catch (e, stackTrace) {
      log('Print Test Failed: $e => $stackTrace');
    }
  }

  Future<void> print(List<int> bytes, {bool isCopy = false}) async {
    try {
      final isConnected = await PrintBluetoothThermal.connectionStatus;
      const storage = FlutterSecureStorage();

      if (!isConnected) {
        await storage.delete(key: 'printer');
        state = const AsyncData(null);
        throw Exception('printer_not_connected'.tr());
      }
      log('START PRINTING...');
      await PrintBluetoothThermal.writeString(
          printText: PrintTextSize(size: 2, text: ''));
      await PrintBluetoothThermal.writeBytes(bytes);
      log('PRINTING COMPLETE');
    } catch (e, stackTrace) {
      log('PRINT FAILED: $e => $stackTrace');
      rethrow;
    }
  }

  void stopScanDevices() {}
}
