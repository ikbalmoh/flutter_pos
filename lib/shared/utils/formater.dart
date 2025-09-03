import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:validators/validators.dart';

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
    return DateFormat(format).format(value);
  }

  static DateTime? stringToDateTime(String? value) {
    if (value != null) {
      if (isDate(value)) {
        return DateTime.parse(value);
      }
    }
    return null;
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
    return result;
  }

  static String msToString(int value, {String? format = 'y-MM-dd HH:mm:ss'}) {
    int msValue;

    if (value < 10000000000) {
      // It's in seconds → convert to milliseconds
      msValue = value * 1000;
    } else if (value < 10000000000000) {
      // It's already milliseconds
      msValue = value;
    } else {
      // It's in microseconds → convert to milliseconds
      msValue = (value / 1000).round();
    }

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(msValue * 1000);
    return dateToString(dateTime, format: format);
  }

  static int unixServer(dynamic value) {
    if (value is num) {
      return (value / 1000).floor();
    }
    return (DateTime.now().millisecondsSinceEpoch / 1000).floor();
  }
}

class GeneralFormater {
  static String stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '\n');
  }
}
