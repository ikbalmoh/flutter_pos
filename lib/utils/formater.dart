import 'package:intl/intl.dart';

class CurrencyFormat {
  static String currency(dynamic number,
      {int decimalDigit = 0, bool symbol = true}) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: symbol ? 'Rp' : '',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
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
}

class DateTimeFormater {
  static String dateToString(DateTime value, {String? format = 'y-MM-dd HH:mm:ss'}) {
    return DateFormat(format).format(value);
  }
}

