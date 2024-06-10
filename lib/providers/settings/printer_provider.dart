import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'dart:developer';
import 'package:selleri/data/models/printer.dart';
import 'package:image/image.dart';

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
        throw Exception(
          'connect_printer_failed'.tr(args: [device.name]),
        );
      }
      final printer = Printer(
        macAddress: device.macAdress,
        name: device.name,
        size: size,
      );

      const storage = FlutterSecureStorage();
      await storage.write(key: 'printer', value: printer.toString());
      state = AsyncData(printer);
      if (!kDebugMode) {
        await printTest();
      }
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
    final bytes = await generateTestTicket();
    await print(bytes);
  }

  Future<void> print(List<int> bytes) async {
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
  }

  Future<List<int>> generateTestTicket() async {
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    final ByteData data = await rootBundle.load('assets/images/icon-print.jpg');
    final Uint8List imgBytes = data.buffer.asUint8List();
    final Image? img = decodeImage(imgBytes);
    if (img != null) {
      bytes += generator.imageRaster(img, align: PosAlign.center);
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
