import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'dart:developer';

import 'package:selleri/data/models/printer.dart';

part 'printer_provider.g.dart';

@Riverpod(keepAlive: true)
class PrinterNotifier extends _$PrinterNotifier {
  @override
  FutureOr<Printer?> build() async {
    const storage = FlutterSecureStorage();
    final currentPrinter = await storage.read(key: 'printer');
    if (currentPrinter != null) {
      final printerJson = json.decode(currentPrinter);
      Printer printer = Printer.fromJson(printerJson);
      await connectPrinter(
        BluetoothInfo(name: printer.name, macAdress: printer.macAddress),
        size: printer.size,
        print: false,
      );
      return printer;
    }
    return null;
  }

  Future<void> connectPrinter(BluetoothInfo device,
      {required PaperSize size, bool print = true}) async {
    state = const AsyncLoading();
    try {
      bool isConnected = await PrintBluetoothThermal.connectionStatus;
      if (!isConnected) {
        isConnected = await PrintBluetoothThermal.connect(
          macPrinterAddress: device.macAdress,
        );
      }
      log('CONNNECT STATUS: $isConnected');
      if (!isConnected) {
        throw Exception('Failed to Connect');
      }
      final printer = Printer(
        macAddress: device.macAdress,
        name: device.name,
        size: size,
      );

      const storage = FlutterSecureStorage();
      await storage.write(key: 'printer', value: printer.toString());
      state = AsyncData(printer);
      await printTest();
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      log('CONNECT PRINTER FAILED: ${e.toString()}');
    }
  }

  void disconnect() async {
    bool disconnect = await PrintBluetoothThermal.disconnect;
    if (disconnect) {
      state = const AsyncData(null);
    }
  }

  Future<void> printTest() async {
    final isConnected = await PrintBluetoothThermal.connectionStatus;
    if (!isConnected) {
      log('PRINTER NOT CONNECTED');
      return;
    }
    await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(size: 2, text: ''));
    await PrintBluetoothThermal.writeBytes(await generateTestTicket());
    log('TEST PRINT DONE');
  }

  Future<List<int>> generateTestTicket() async {
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

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

    // bytes += generator.feed(1);
    bytes += generator.cut();
    return bytes;
  }

  void stopScanDevices() {}
}
