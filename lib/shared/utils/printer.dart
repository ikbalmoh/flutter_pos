import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:screenshot/screenshot.dart';
import 'package:selleri/features/cart/model/cart.dart';
import 'package:selleri/features/cart/model/cart_voucher.dart';
import 'package:selleri/features/cart/widget/components/order_summary/order_summary.dart';
import 'package:selleri/features/item/model/item_cart.dart';
import 'package:selleri/features/outlet/model/outlet.dart';
import 'package:selleri/features/outlet/model/outlet_config.dart';
import 'package:selleri/features/outlet/provider/outlet_state.dart';
import 'package:selleri/features/settings/widget/printer/test_printer_preview.dart';
import 'package:selleri/features/shift/model/shift_info.dart';
import 'package:selleri/features/shift/model/shift_summary.dart';
import 'package:selleri/features/shift/widget/components/shift_summary_receipt.dart';
import 'package:selleri/shared/utils/formater.dart';
import 'package:selleri/shared/utils/transaction.dart';

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
    bool printIncludePpn = false,
  }) async {
    try {
      log('BUILD RECEIPT: $cart\n$outlet\n$attributes');
      final profile = await CapabilityProfile.load();
      final generator =
          Generator(size ?? PaperSize.mm58, profile, spaceBetweenRows: 1);
      List<int> bytes = [];

      CartVoucher? voucher =
          cart.vouchers.isNotEmpty ? cart.vouchers.first : null;

      Image? img;
      String? headers;
      String? footers;

      if (!isCopy) {
        bytes += generator.drawer();
      }

      if (attributes != null) {
        if (isValidBase64(attributes.imageBase64!)) {
          try {
            final Uint8List imgBytes =
                const Base64Decoder().convert(attributes.imageBase64!);
            img = decodeImage(imgBytes);
          } catch (e) {
            // Cannot decode header image
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

      final String transactionNo = isHold
          ? cart.transactionNo
          : cart.transactionNo.replaceFirst('BILL-', '').trim();

      // info
      bytes += generator.text('No: $transactionNo');
      bytes += generator.text('${'cashier'.tr()}: ${cart.createdName ?? '-'}');
      bytes += generator.text(
          '${'date'.tr()}: ${cart.transactionDate > 0 ? DateTimeFormater.msToString(cart.transactionDate, format: 'dd/MM/y HH:mm') : ''}');
      bytes += generator.text('${'customer'.tr()}: ${cart.idCustomer != null ? [
          cart.customerName,
          cart.vehicle?.licensePlate
        ].whereType<String>().join(' - ') : 'walk_in'.tr()}');
      if (cart.tables != null && cart.tables!.isNotEmpty) {
        bytes += generator
            .text('${'table'.tr()}: ${cart.tables?.join(', ') ?? '-'}');
      }

      bytes += generator.hr();

      // items
      for (ItemCart item in cart.items) {
        String itemName = item.itemName;
        if (item.variantName != '' && item.variantName != null) {
          itemName += ' - ${item.variantName}';
        }
        bytes += generator.text(withPrice
            ? itemName
            : "${CurrencyFormat.currency(item.quantity, symbol: false)} x $itemName");
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
                  '${CurrencyFormat.currency(item.quantity, symbol: false)} x ${CurrencyFormat.currency(item.price, symbol: true)}',
              width: 8,
              styles: const PosStyles(align: PosAlign.left),
            ),
            PosColumn(
              text: CurrencyFormat.currency(
                item.price * item.quantity,
                symbol: false,
              ),
              width: 4,
              styles: const PosStyles(align: PosAlign.right),
            ),
          ]);
          if (item.discountTotal > 0) {
            bytes += generator.row([
              PosColumn(
                text: 'discount'.tr(),
                width: 5,
                styles: const PosStyles(align: PosAlign.left),
              ),
              PosColumn(
                text:
                    '-${CurrencyFormat.currency(item.discountTotal, symbol: false)}',
                width: 7,
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
            width: 5,
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: CurrencyFormat.currency(cart.subtotal, symbol: false),
            width: 7,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
        if (voucher != null && voucher.voucherType == 'discount') {
          bytes += generator.row([
            PosColumn(
              text: '${'voucher'.tr()} (${voucher.code})',
              width: 7,
              styles: const PosStyles(align: PosAlign.left),
            ),
            PosColumn(
              text: '-${CurrencyFormat.currency(voucher.value, symbol: false)}',
              width: 5,
              styles: const PosStyles(align: PosAlign.right),
            ),
          ]);
        } else if (cart.discOverallTotal > 0) {
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
        if (printIncludePpn || cart.ppnIsInclude == false) {
          // subtotal
          bytes += generator.row([
            PosColumn(
              text: 'tax'.tr(),
              width: 5,
              styles: const PosStyles(align: PosAlign.left),
            ),
            PosColumn(
              text: CurrencyFormat.currency(cart.ppnTotal, symbol: false),
              width: 7,
              styles: const PosStyles(align: PosAlign.right),
            ),
          ]);
        }
        bytes += generator.row([
          PosColumn(
            text: 'Total',
            width: 5,
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: CurrencyFormat.currency(cart.total, symbol: false),
            width: 7,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
        // Payments
        bytes += generator.hr();
        bytes += generator.text('payments'.tr());
        if (voucher != null && voucher.voucherType == 'payment') {
          bytes += generator.row([
            PosColumn(
              text: '${'voucher'.tr()} (${voucher.code})',
              width: 7,
              styles: const PosStyles(align: PosAlign.left),
            ),
            PosColumn(
              text: CurrencyFormat.currency(voucher.value, symbol: false),
              width: 5,
              styles: const PosStyles(align: PosAlign.right),
            ),
          ]);
        }
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
        // insufficient_payment
        if (cart.totalPayment < cart.grandTotal) {
          bytes += generator.row([
            PosColumn(
              text: 'insufficient_payment'.tr(),
              width: 7,
              styles: const PosStyles(align: PosAlign.left),
            ),
            PosColumn(
              text: CurrencyFormat.currency(cart.grandTotal - cart.totalPayment,
                  symbol: false),
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
            width: 5,
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: CurrencyFormat.currency(cart.change, symbol: false),
            width: 7,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }

      bytes += generator.hr();

      if (cart.notes != null && cart.notes!.isNotEmpty) {
        bytes += generator.text(cart.notes!,
            styles: const PosStyles(align: PosAlign.left));
        if (cut != true) {
          bytes += generator.feed(1);
        }
      }

      if (isHold) {
        bytes += generator.text('holded_transactions'.tr(),
            styles: const PosStyles(
              align: PosAlign.center,
              bold: true,
            ));
      } else if (footers != null) {
        bytes += generator.text(footers,
            styles: const PosStyles(align: PosAlign.center));
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
        bytes += generator.feed(2);
      }

      return bytes;
    } catch (e, stackTrace) {
      log('BUILD RECEIPT ERROR: $e\n$stackTrace');
      rethrow;
    }
  }

  static Future<List<int>> buildKitchenReceiptBytes(
    Cart cart, {
    required Outlet outlet,
    AttributeReceipts? attributes,
    PaperSize? size = PaperSize.mm58,
    bool? cut = false,
  }) async {
    try {
      log('BUILD KITCHEN RECEIPT: $cart\n$outlet\n$attributes');
      final profile = await CapabilityProfile.load();
      final generator =
          Generator(size ?? PaperSize.mm58, profile, spaceBetweenRows: 1);
      List<int> bytes = [];

      bytes += generator.text(cart.outletName ?? '',
          styles: const PosStyles(align: PosAlign.center, bold: true));

      bytes += generator.emptyLines(1);

      // info
      bytes += generator.text('No: ${cart.transactionNo}');
      bytes += generator.text(
          'Date: ${cart.transactionDate > 0 ? DateTimeFormater.msToString(cart.transactionDate, format: 'dd/MM/y HH:mm') : ''}');
      bytes += generator.text('Table: ${cart.tables?.join(', ') ?? '-'}');

      bytes += generator.hr();

      // items
      for (ItemCart item in cart.items) {
        String itemName = item.itemName;
        if (item.variantName != '' && item.variantName != null) {
          itemName += ' - ${item.variantName}';
        }
        bytes += generator.row([
          PosColumn(
            text: itemName,
            width: 10,
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: '${item.quantity}',
            width: 2,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
        if (item.details.isNotEmpty) {
          for (var i = 0; i < item.details.length; i++) {
            final detail = item.details[i];
            bytes += generator.row([
              PosColumn(
                text: ' ${detail.quantity}',
                width: 2,
                styles: const PosStyles(align: PosAlign.left),
              ),
              PosColumn(
                text: detail.name,
                width: 10,
                styles: const PosStyles(align: PosAlign.right),
              ),
            ]);
          }
        }
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
    bytes += generator.text('SHIFT REPORT',
        styles: const PosStyles(bold: true, align: PosAlign.center));
    bytes += generator.hr();
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
        bytes += generator.text(summary.label,
            styles: const PosStyles(bold: true, align: PosAlign.left));
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
      bytes += generator.feed(2);
    }

    return bytes;
  }

  static Future<List<int>> buildShiftReportReceiptCaptureBytes(ShiftInfo shift,
      {AttributeReceipts? attributes,
      required Outlet outlet,
      PaperSize? size = PaperSize.mm58,
      bool? cut = false,
      bool isCopy = false}) async {
    final effectiveSize = size ?? PaperSize.mm58;
    final controller = ScreenshotController();
    final Uint8List captured = await controller.captureFromWidget(
      MediaQuery(
        data: const MediaQueryData(),
        child: Directionality(
          textDirection: ui.TextDirection.ltr,
          child: Theme(
            data: ThemeData.light(),
            child: Material(
              color: Colors.white,
              child: ShiftSummaryReceipt(
                shift: shift,
                outlet: outlet,
                asReceipt: true,
                attributeReceipts: attributes,
                withAttribute: true,
              ),
            ),
          ),
        ),
      ),
      targetSize: Size(effectiveSize.width.toDouble(), 4000),
      pixelRatio: 1.0,
    );
    final profile = await CapabilityProfile.load();
    final generator = Generator(effectiveSize, profile, spaceBetweenRows: 0);
    List<int> bytes = [];
    Image? receiptImage = decodeImage(captured);
    if (receiptImage != null) {
      receiptImage = copyResize(receiptImage, width: effectiveSize.width);
      bytes += generator.image(receiptImage, align: PosAlign.center);
    }
    if (cut == true) {
      bytes += generator.cut();
    } else {
      bytes += generator.feed(2);
    }
    return bytes;
  }

  static Future<List<int>> buildReceiptCaptureBytes(
    Cart cart, {
    required OutletSelected outlet,
    PaperSize? size = PaperSize.mm58,
    bool? cut = false,
    bool withPrice = true,
    bool printIncludePpn = false,
  }) async {
    final effectiveSize = size ?? PaperSize.mm58;
    final controller = ScreenshotController();
    final Uint8List captured = await controller.captureFromWidget(
      MediaQuery(
        data: const MediaQueryData(),
        child: Directionality(
          textDirection: ui.TextDirection.ltr,
          child: Theme(
            data: ThemeData.light(),
            child: Material(
              color: Colors.white,
              child: OrderSummary(
                cart: cart,
                outletState: outlet,
                taxable: outlet.config.taxable ?? false,
                withAttribute: true,
                asReceipt: true,
              ),
            ),
          ),
        ),
      ),
      targetSize: Size(effectiveSize.width.toDouble(), 4000),
      pixelRatio: 1.0,
    );
    final profile = await CapabilityProfile.load();
    final generator = Generator(effectiveSize, profile, spaceBetweenRows: 0);
    List<int> bytes = [];
    Image? receiptImage = decodeImage(captured);
    if (receiptImage != null) {
      receiptImage = copyResize(receiptImage, width: effectiveSize.width);
      bytes += generator.image(receiptImage, align: PosAlign.center);
    }
    if (cut == true) {
      bytes += generator.cut();
    } else {
      bytes += generator.feed(2);
    }
    return bytes;
  }

  Future<List<int>> buildTestTicketBytes(
      {required PaperSize size, bool? cut = false}) async {
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(size, profile, spaceBetweenRows: 2);
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

    if (cut == true) {
      bytes += generator.cut();
    } else {
      bytes += generator.feed(2);
    }
    return bytes;
  }

  Future<List<int>> buildTestPrinterCaptureBytes({
    PaperSize? size = PaperSize.mm58,
    bool? cut = false,
  }) async {
    final effectiveSize = size ?? PaperSize.mm58;
    final controller = ScreenshotController();
    final Uint8List captured = await controller.captureFromWidget(
      MediaQuery(
        data: const MediaQueryData(),
        child: Directionality(
          textDirection: ui.TextDirection.ltr,
          child: Theme(
            data: ThemeData.light(),
            child: Material(
              color: Colors.white,
              child: TestPrinterPreview(),
            ),
          ),
        ),
      ),
      targetSize: Size(effectiveSize.width.toDouble(), 4000),
      pixelRatio: 1.0,
    );
    final profile = await CapabilityProfile.load();
    final generator = Generator(effectiveSize, profile, spaceBetweenRows: 0);
    List<int> bytes = [];
    Image? receiptImage = decodeImage(captured);
    if (receiptImage != null) {
      receiptImage = copyResize(receiptImage, width: effectiveSize.width);
      bytes += generator.image(receiptImage, align: PosAlign.center);
    }
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
