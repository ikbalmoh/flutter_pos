import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:validators/validators.dart';

class CurrencyFormat {
  static String currency(
    dynamic number, {
    int decimalDigit = 0,
    bool symbol = true,
    bool minus = false,
  }) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: symbol ? 'Rp' : '',
      decimalDigits: decimalDigit,
    );
    if (number is num) {
      if (number <= 0) {
        number = 0;
      }
      return '${minus == true && number > 0 ? '-' : ''}${currencyFormatter.format(number)}';
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

  static CurrencyTextInputFormatter currencyInput() {
    return CurrencyTextInputFormatter.currency(
        locale: 'id', decimalDigits: 0, symbol: '');
  }
}

class DateTimeFormater {
  static String dateToString(DateTime value,
      {String? format = 'y-MM-dd HH:mm:ss'}) {
    return DateFormat(format).format(value);
  }

  static DateTime? stringToDateTime(String value) {
    if (isDate(value)) {
      return DateTime.parse(value);
    }
    return null;
  }

  static int stringToTimestamp(dynamic value) {
    if (value is int || value is num) {
      return value;
    }
    if (value is String) {
      if (isDate(value)) {
        return DateTime.parse(value).millisecondsSinceEpoch;
      }
    }
    return DateTime.now().millisecondsSinceEpoch;
  }

  static String msToString(int value, {String? format = 'y-MM-dd HH:mm:ss'}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(value);
    return dateToString(dateTime, format: format);
  }

  static int unixServer(dynamic value) {
    if (value is num) {
      return (value / 1000).floor();
    }
    return (DateTime.now().millisecondsSinceEpoch / 1000).floor();
  }
}
