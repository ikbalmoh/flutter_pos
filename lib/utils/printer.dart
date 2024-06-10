import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:selleri/data/models/outlet_config.dart';
import 'package:selleri/utils/formater.dart';

class Printer {
  static String stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '\n');
  }

  static String divider({PaperSize size = PaperSize.mm58}) {
    String divider = '================================================';
    if (size == PaperSize.mm58) {
      divider = divider.substring(0, 32);
    }
    return divider;
  }

  static String subdivider({PaperSize size = PaperSize.mm58}) {
    String divider = '------------------------------------------------';
    if (size == PaperSize.mm58) {
      divider = divider.substring(0, 32);
    }
    return divider;
  }

  static Future<List<int>> buildReceiptBytes(
    Cart cart, {
    AttributeReceipts? attributes,
    PaperSize? size = PaperSize.mm58,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    late Image? img;
    String? headers;
    String? footers;

    if (attributes != null) {
      if (attributes.imageBase64 != null) {
        final Uint8List imgBytes =
            const Base64Decoder().convert(attributes.imageBase64!);
        img = decodeImage(imgBytes);
      }
      headers = Printer.stripHtmlIfNeeded(attributes.headers ?? '');
      footers = Printer.stripHtmlIfNeeded(attributes.footers ?? '');
    }

    if (img != null) {
      img = copyResize(img, height: 120);
      bytes += generator.imageRaster(img, align: PosAlign.center);
    } else {
      bytes += generator.text(cart.outletName,
          styles: const PosStyles(
            align: PosAlign.center,
            bold: true,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ));
    }

    if (headers != null) {
      bytes += generator.text(headers,
          linesAfter: 1, styles: const PosStyles(align: PosAlign.center));
    }

    // info
    bytes += generator.text('No: ${cart.transactionNo}');
    bytes += generator.text('Cashier: ${cart.createdName ?? '-'}');
    bytes += generator.text(
        'Date: ${DateTimeFormater.dateToString(cart.transactionDate, format: 'dd/MM/y HH:mm')}');
    bytes += generator.text('Customer: ${cart.customerName ?? '-'}');
    bytes += generator.text(Printer.divider());

    // items
    for (ItemCart item in cart.items) {
      bytes += generator.text(item.itemName);
      bytes += generator.row([
        PosColumn(
          text:
              '${item.quantity} x ${CurrencyFormat.currency(item.price, symbol: false)}',
          width: 9,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: CurrencyFormat.currency(item.total, symbol: false),
          width: 3,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      // TODO: item details
    }
    bytes += generator.text(Printer.subdivider());
    // subtotal
    bytes += generator.row([
      PosColumn(
        text: 'Subtotal',
        width: 9,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: CurrencyFormat.currency(cart.subtotal, symbol: false),
        width: 3,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'discount'.tr(),
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text:
            '-${CurrencyFormat.currency(cart.discOverallTotal, symbol: false)}',
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Total',
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: CurrencyFormat.currency(cart.total, symbol: false),
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    // Payments
    bytes += generator.text(Printer.subdivider());
    bytes += generator.text('payments'.tr());
    for (var payment in cart.payments) {
      bytes += generator.row([
        PosColumn(
          text: payment.paymentName,
          width: 7,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: CurrencyFormat.currency(payment.paymentValue, symbol: false),
          width: 5,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }
    // Change
    bytes += generator.text(Printer.subdivider());
    bytes += generator.row([
      PosColumn(
        text: 'change'.tr(),
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: CurrencyFormat.currency(cart.change, symbol: false),
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    // footer
    bytes += generator.text(Printer.divider(), linesAfter: 1);
    if (footers != null) {
      bytes += generator.text(footers,
          linesAfter: 2, styles: const PosStyles(align: PosAlign.center));
    }

    bytes += generator.cut();

    return bytes;
  }
}
