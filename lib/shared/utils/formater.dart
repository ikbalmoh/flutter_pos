import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:validators/validators.dart';
import 'package:easy_localization/easy_localization.dart';

class CurrencyFormat {
  static String currency(
    dynamic number, {
    int decimalDigit = 2,
    bool symbol = true,
    bool minus = false,
  }) {
    if (number is num) {
      if (number <= 0 && !minus) {
        number = 0;
      }
      if (number % 1 == 0 && decimalDigit != 0) {
        decimalDigit = 0;
      }
      NumberFormat currencyFormatter = NumberFormat.currency(
        locale: 'id',
        symbol: symbol ? 'Rp' : '',
        decimalDigits: decimalDigit,
      );
      return currencyFormatter.format(number);
    }

    return number;
  }

  static num reverse(String formated,
      {int decimalDigit = 0, bool symbol = false}) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: symbol ? 'Rp' : '',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.parse(formated);
  }

  static CurrencyTextInputFormatter currencyInput({int decimalDigit = 0}) {
    return CurrencyTextInputFormatter.currency(
        locale: 'id', decimalDigits: decimalDigit, symbol: '');
  }
}

class DateTimeFormater {
  static String dateToString(DateTime value,
      {String? format = 'y-MM-dd HH:mm:ss'}) {
    return DateFormat(format, 'id_ID').format(value);
  }

  static DateTime? stringToDateTime(String? value) {
    if (value != null) {
      if (isDate(value)) {
        return DateTime.parse(value);
      }
    }
    return null;
  }

  static String dateFromString(String? value, {String? format = 'y-MM-dd'}) {
    if (value == null) {
      return '-';
    }
    if (isDate(value)) {
      return dateToString(DateTime.parse(value), format: format);
    }
    return '-';
  }

  static int stringToTimestamp(dynamic value) {
    int result = DateTime.now().millisecondsSinceEpoch;
    if (value is int || value is num) {
      result = value;
    } else if (value is String) {
      if (isDate(value)) {
        result = DateTime.parse(value).millisecondsSinceEpoch;
      }
    } else if (value is DateTime) {
      result = value.millisecondsSinceEpoch;
    }
    if (result.toString().length < 13) {
      result = result * 1000;
    }
    return result;
  }

  static String msToString(int value, {String? format = 'y-MM-dd HH:mm:ss'}) {
    int ms = value;
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(ms);
    return DateFormat(format, 'id_ID').format(dateTime);
  }

  static int msTosecond(dynamic value) {
    if (value is num) {
      if (value.toString().length == 13) {
        return (value / 1000).floor();
      }
      return value.toInt();
    }
    return (DateTime.now().millisecondsSinceEpoch / 1000).floor();
  }

  static String formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24).toString().padLeft(1, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(1, '0');
    if (days > 0) {
      return '$days ${'day'.tr()} $hours ${'hour'.tr()} $minutes ${'minutes'.tr()}';
    }
    return '$hours ${'hour'.tr()} $minutes ${'minutes'.tr()}';
  }
}

class GeneralFormater {
  static String stripHtmlIfNeeded(String text) {
    // ignore: deprecated_member_use
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '\n');
  }
}
