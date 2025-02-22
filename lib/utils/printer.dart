import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:selleri/data/models/outlet.dart';
import 'package:selleri/data/models/outlet_config.dart';
import 'package:selleri/data/models/shift_info.dart';
import 'package:selleri/data/models/shift_summary.dart';
import 'package:selleri/utils/formater.dart';
import 'package:selleri/utils/transaction.dart';

class Printer {
  static Future<List<int>> buildReceiptBytes(
    Cart cart, {
    required Outlet outlet,
    AttributeReceipts? attributes,
    PaperSize? size = PaperSize.mm58,
    bool? cut = false,
    bool isCopy = false,
    bool isHold = false,
    bool withPrice = true,
  }) async {
    try {
      log('PRINTER SIZE: ${size?.value.toString()}');
      log('BUILD RECEIPT: $cart\n$outlet\n$attributes');
      final profile = await CapabilityProfile.load();
      final generator =
          Generator(size ?? PaperSize.mm58, profile, spaceBetweenRows: 1);
      List<int> bytes = [];

      Image? img;
      String? headers;
      String? footers;

      bytes += generator.drawer();

      if (attributes != null) {
        if (isValidBase64(attributes.imageBase64!)) {
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
        bytes += generator.image(img, align: PosAlign.center);
      }

      bytes += generator.text(cart.outletName ?? '',
          styles: const PosStyles(align: PosAlign.center, bold: true));
      if (outlet.outletAddress != null && outlet.outletAddress != '') {
        bytes += generator.text(outlet.outletAddress!,
            styles: const PosStyles(align: PosAlign.center, bold: false));
      }
      if (outlet.outletPhone != null && outlet.outletPhone != '') {
        bytes += generator.text(
          outlet.outletPhone!,
          styles: const PosStyles(align: PosAlign.center, bold: false),
        );
      }

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

      bytes += generator.hr();

      // items
      for (ItemCart item in cart.items) {
        bytes += generator.text(
            withPrice ? item.itemName : "${item.quantity} x ${item.itemName}");
        if (item.details.isNotEmpty) {
          for (var i = 0; i < item.details.length; i++) {
            final detail = item.details[i];
            bytes += generator.text(' - ${detail.quantity} x ${detail.name}');
          }
        }
        if (withPrice) {
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
      }

      if (withPrice) {
        bytes += generator.hr();

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
        bytes += generator.hr();
        bytes += generator.text('payments'.tr());
        for (var payment in cart.payments) {
          bytes += generator.row([
            PosColumn(
              text: payment.paymentName,
              width: 7,
              styles: const PosStyles(align: PosAlign.left),
            ),
            PosColumn(
              text:
                  CurrencyFormat.currency(payment.paymentValue, symbol: false),
              width: 5,
              styles: const PosStyles(align: PosAlign.right),
            ),
          ]);
        }
        // Change
        bytes += generator.hr();
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
      }

      bytes += generator.hr();

      if (isHold) {
        bytes += generator.text('holded_transactions'.tr(),
            styles: const PosStyles(
              align: PosAlign.center,
              bold: true,
            ));
      } else {
        // footer
        if (footers != null) {
          bytes += generator.text(footers,
              styles: const PosStyles(align: PosAlign.center));
        }
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

      if (cut == true) {
        bytes += generator.cut();
      } else {
        bytes += generator.feed(3);
      }

      return bytes;
    } catch (e, stackTrace) {
      log('BUILD RECEIPT ERROR: $e\n$stackTrace');
      rethrow;
    }
  }

  static Future<List<int>> buildShiftReportBytes(ShiftInfo shift,
      {AttributeReceipts? attributes,
      required Outlet outlet,
      PaperSize? size = PaperSize.mm58,
      bool? cut = false,
      bool isCopy = false}) async {
    log('BUILD SHIFT RERORT: $shift');
    log('OUTLET: $outlet');
    final profile = await CapabilityProfile.load();
    final generator =
        Generator(size ?? PaperSize.mm58, profile, spaceBetweenRows: 1);
    List<int> bytes = [];

    Image? img;
    String? headers;

    if (attributes != null) {
      if (isValidBase64(attributes.imageBase64)) {
        final Uint8List imgBytes =
            const Base64Decoder().convert(attributes.imageBase64!);
        img = decodeImage(imgBytes);
      }
      headers = GeneralFormater.stripHtmlIfNeeded(attributes.headers ?? '');
    }

    if (img != null) {
      img = copyResize(img, height: 120);
      bytes += generator.image(img, align: PosAlign.center);
    }

    bytes += generator.text(
      shift.outletName ?? '',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    if (outlet.outletAddress != null && outlet.outletAddress != '') {
      bytes += generator.text(outlet.outletAddress!,
          styles: const PosStyles(align: PosAlign.center, bold: false),
          linesAfter: 0);
    }
    if (outlet.outletPhone != null && outlet.outletPhone != '') {
      bytes += generator.text(outlet.outletPhone!,
          styles: const PosStyles(align: PosAlign.center, bold: false));
    }

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
    bytes += generator.hr();

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

    bytes += generator.hr();
    if (shift.soldItems.isNotEmpty) {
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
    }
    bytes += generator.hr();

    if (cut == true) {
      bytes += generator.cut();
    } else {
      bytes += generator.feed(3);
    }

    return bytes;
  }

  static bool isValidBase64(String? str) {
    if (str == null) {
      return false;
    }
    try {
      base64.decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }
}
