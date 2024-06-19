import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:selleri/data/models/outlet_config.dart';
import 'package:selleri/data/models/shift_info.dart';
import 'package:selleri/data/models/shift_summary.dart';
import 'package:selleri/utils/formater.dart';
import 'package:selleri/utils/transaction.dart';

class Printer {
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
    bool isCopy = false,
    bool isHold = false,
  }) async {
    try {
      log('BUILD RECEIPT: $cart\n$attributes');
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile);
      List<int> bytes = [];

      Image? img;
      String? headers;
      String? footers;

      if (attributes != null) {
        if (attributes.imageBase64 != null && attributes.imageBase64 != '') {
          try {
            final Uint8List imgBytes =
                const Base64Decoder().convert(attributes.imageBase64!);
            img = decodeImage(imgBytes);
          } catch (e) {
            log('Cannot decode header image: $e');
            log('${attributes.imageBase64}');
          }
        }
        headers = GeneralFormater.stripHtmlIfNeeded(attributes.headers ?? '');
        footers = GeneralFormater.stripHtmlIfNeeded(attributes.footers ?? '');
      }

      if (img != null) {
        img = copyResize(img, height: 120);
        bytes += generator.imageRaster(img, align: PosAlign.center);
      }

      bytes += generator.text(cart.outletName ?? '',
          styles: const PosStyles(align: PosAlign.center, bold: true),
          linesAfter: 1);

      if (headers != null) {
        bytes += generator.text(headers,
            linesAfter: 1, styles: const PosStyles(align: PosAlign.center));
      }

      // info
      bytes += generator.text('No: ${cart.transactionNo}');
      bytes += generator.text('Cashier: ${cart.createdName ?? '-'}');
      bytes += generator.text(
          'Date: ${cart.transactionDate > 0 ? DateTimeFormater.msToString(cart.transactionDate, format: 'dd/MM/y HH:mm') : ''}');
      bytes += generator.text('Customer: ${cart.customerName ?? '-'}');
      bytes += generator.text(Printer.divider(size: size ?? PaperSize.mm58));

      // items
      for (ItemCart item in cart.items) {
        bytes += generator.text(item.itemName);
        if (item.details.isNotEmpty) {
          for (var i = 0; i < item.details.length; i++) {
            final detail = item.details[i];
            bytes += generator.text(' - ${detail.quantity} x ${detail.name}');
          }
        }
        bytes += generator.row([
          PosColumn(
            text:
                '${item.quantity} x ${CurrencyFormat.currency(item.price, symbol: false)}',
            width: 9,
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: CurrencyFormat.currency(
              item.price * item.quantity,
              symbol: false,
            ),
            width: 3,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
        if (item.discountTotal > 0) {
          bytes += generator.row([
            PosColumn(
              text: 'discount'.tr(),
              width: 9,
              styles: const PosStyles(align: PosAlign.left),
            ),
            PosColumn(
              text:
                  '-${CurrencyFormat.currency(item.discountTotal, symbol: false)}',
              width: 3,
              styles: const PosStyles(align: PosAlign.right),
            ),
          ]);
        }
      }
      bytes += generator.text(Printer.subdivider(size: size ?? PaperSize.mm58));
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
      if (cart.discOverallTotal > 0) {
        bytes += generator.row([
          PosColumn(
            text:
                '${'discount'.tr()} ${cart.discIsPercent && cart.discOverall > 0 ? '(${CurrencyFormat.currency(cart.discOverall, symbol: false)}%)' : ''}',
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
      }
      if (cart.discPromotionsTotal > 0) {
        bytes += generator.row([
          PosColumn(
            text: 'promotions'.tr(),
            width: 8,
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text:
                '-${CurrencyFormat.currency(cart.discPromotionsTotal, symbol: false)}',
            width: 4,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }
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
      bytes += generator.text(Printer.subdivider(size: size ?? PaperSize.mm58));
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
      bytes += generator.text(Printer.subdivider(size: size ?? PaperSize.mm58));
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
      bytes += generator.text(Printer.divider(size: size ?? PaperSize.mm58),
          linesAfter: 1);
      if (footers != null) {
        bytes += generator.text(footers,
            linesAfter: 2, styles: const PosStyles(align: PosAlign.center));
      }

      if (isHold) {
        bytes += generator.text('holded_transactions'.tr(),
            linesAfter: 1,
            styles: const PosStyles(
              align: PosAlign.center,
              bold: true,
            ));
      }

      if (isCopy) {
        bytes += generator.text('receipt_copy'.tr(),
            styles: const PosStyles(
              align: PosAlign.center,
            ));
        bytes += generator.text(
            DateTimeFormater.dateToString(DateTime.now(),
                format: 'dd/MM/y HH:mm'),
            styles: const PosStyles(align: PosAlign.center));
      }

      bytes += generator.cut();

      return bytes;
    } catch (e, stackTrace) {
      log('BUILD RECEIPT ERROR: $e\n$stackTrace');
      rethrow;
    }
  }

  static Future<List<int>> buildShiftReportBytes(ShiftInfo shift,
      {AttributeReceipts? attributes,
      PaperSize? size = PaperSize.mm58,
      bool isCopy = false}) async {
    log('BUILD SHIFT RERORT: $shift');
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    Image? img;
    String? headers;

    if (attributes != null) {
      if (attributes.imageBase64 != null && attributes.imageBase64 != '') {
        final Uint8List imgBytes =
            const Base64Decoder().convert(attributes.imageBase64!);
        img = decodeImage(imgBytes);
      }
      headers = GeneralFormater.stripHtmlIfNeeded(attributes.headers ?? '');
    }

    if (img != null) {
      img = copyResize(img, height: 120);
      bytes += generator.imageRaster(img, align: PosAlign.center);
    }

    bytes += generator.text(shift.outletName ?? '',
        styles: const PosStyles(align: PosAlign.center, bold: true),
        linesAfter: 1);

    if (headers != null) {
      bytes += generator.text(headers,
          linesAfter: 1, styles: const PosStyles(align: PosAlign.center));
    }

    // info
    bytes +=
        generator.text('SHIFT REPORT', styles: const PosStyles(bold: true));
    bytes += generator.text('Code: ${shift.codeShift}');
    bytes += generator.text('${'cashier'.tr()}: ${shift.openedBy}');
    bytes += generator.text(
        'Open: ${DateTimeFormater.dateToString(shift.openShift, format: 'dd/MM/y HH:mm')}');
    bytes += generator.text(
        'Close: ${shift.closeShift != null ? DateTimeFormater.dateToString(shift.closeShift!, format: 'dd/MM/y HH:mm') : '-'}');
    bytes += generator.text(Printer.divider(size: size ?? PaperSize.mm58));

    final List<SummaryItem> summaries = ShiftUtil.paymentList(shift.summary);
    for (var summary in summaries) {
      if (summary.isTotal == true) {
        bytes +=
            generator.text(summary.label, styles: const PosStyles(bold: true));
      } else {
        bytes += generator.row([
          PosColumn(
            text: ' ${summary.label}',
            width: 8,
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: CurrencyFormat.currency(summary.value, symbol: false),
            width: 4,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }
    }

    bytes += generator.text(Printer.subdivider(size: size ?? PaperSize.mm58));
    bytes += generator.row([
      PosColumn(
        text: 'item_sold'.tr(),
        width: 8,
        styles: const PosStyles(bold: true),
      ),
      PosColumn(
        text: CurrencyFormat.currency(
            shift.soldItems.isNotEmpty
                ? shift.soldItems
                    .map((sold) => sold.sold)
                    .reduce((a, b) => a + b)
                : 0,
            symbol: false),
        width: 4,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);
    for (var i = 0; i < shift.soldItems.length; i++) {
      final item = shift.soldItems[i];
      bytes += generator.row([
        PosColumn(
          text: ' ${item.name}',
          width: 10,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: CurrencyFormat.currency(item.sold, symbol: false),
          width: 2,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }
    bytes += generator.text(Printer.divider(size: size ?? PaperSize.mm58));

    if (isCopy) {
      bytes += generator.text('receipt_copy'.tr(),
          linesAfter: 1);
    }

    bytes += generator.cut();

    return bytes;
  }
}
