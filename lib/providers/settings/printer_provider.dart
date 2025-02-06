import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'dart:developer';
import 'package:selleri/data/models/printer.dart' as model;
import 'package:image/image.dart';

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

  Future<void> connectPrinter(BluetoothInfo device,
      {required PaperSize size, bool print = true}) async {
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
      );

      await storage.write(key: 'printer', value: printer.toString());
      state = AsyncData(printer);
      await printTest();
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      log('CONNECT PRINTER FAILED: ${e.toString()}');
    }
  }

  void updatePrinter(BluetoothInfo device, {required PaperSize size}) {
    final printer = model.Printer(
      macAddress: device.macAdress,
      name: device.name,
      size: size,
    );
    state = AsyncData(printer);
  }

  void disconnect() async {
    bool disconnect = await PrintBluetoothThermal.disconnect;
    if (disconnect) {
      state = const AsyncData(null);
    }
  }

  Future<void> printTest() async {
    try {
      log('Test Print');
      final bytes = await generateTestTicket();
      log('Print Bytes: $bytes');
      await print(bytes);
    } catch (e, stackTrace) {
      log('Print Test Failed: $e => $stackTrace');
    }
  }

  Future<void> print(List<int> bytes, {bool isCopy = false}) async {
    try {
      final isConnected = await PrintBluetoothThermal.connectionStatus;
      if (!isConnected) {
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
    }
  }

  Future<List<int>> generateTestTicket() async {
    final printer = ref.read(printerProvider).value;
    if (printer == null) {
      throw 'printer_not_connected'.tr();
    }
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(printer.size, profile, spaceBetweenRows: 2);
    List<int> bytes = [];

    final ByteData data = await rootBundle.load('assets/images/icon-print.jpg');
    final Uint8List imgBytes = data.buffer.asUint8List();
    final Image? img = decodeImage(imgBytes);
    if (img != null) {
      log('Print Image  $img');
      bytes += generator.image(img, align: PosAlign.center);
    }
    bytes += generator.text(
      'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ',
      styles: const PosStyles(
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    );

    bytes += generator.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: const PosStyles(codeTable: 'CP1252'));
    bytes += generator.text('Special 2: blåbærgrød',
        styles: const PosStyles(codeTable: 'CP1252'));

    bytes += generator.text('Bold text', styles: const PosStyles(bold: true));
    bytes +=
        generator.text('Reverse text', styles: const PosStyles(reverse: true));
    bytes += generator.text('Underlined text',
        styles: const PosStyles(underline: true), linesAfter: 1);
    bytes += generator.text('Align left',
        styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('Align center',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Align right',
        styles: const PosStyles(align: PosAlign.right), linesAfter: 1);

    bytes += generator.row([
      PosColumn(
        text: 'col3',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col6',
        width: 6,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col3',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);

    bytes += generator.text('Text size 200%',
        styles: const PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    bytes += generator.qrcode('selleri.co.id');

    // bytes += generator.feed(1);
    bytes += generator.cut();
    return bytes;
  }

  void stopScanDevices() {}
}
