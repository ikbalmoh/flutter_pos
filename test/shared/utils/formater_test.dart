import 'package:flutter_test/flutter_test.dart';
import 'package:selleri/shared/utils/formater.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id', null);
  });

  group('CurrencyFormat', () {
    test('currency formats numbers correctly', () {
      expect(CurrencyFormat.currency(5000), 'Rp5.000');
      expect(CurrencyFormat.currency(5000, symbol: false), '5.000');
      expect(CurrencyFormat.currency(5000.50, decimalDigit: 2), 'Rp5.000,50');
      expect(CurrencyFormat.currency(-1000), 'Rp0');
      expect(CurrencyFormat.currency(-1000, minus: true), '-Rp1.000');
    });

    test('reverse parses formatted currency correctly', () {
      expect(CurrencyFormat.reverse('Rp5.000', symbol: true), 5000);
      expect(CurrencyFormat.reverse('5.000'), 5000);
      expect(CurrencyFormat.reverse('Rp5.000,50', decimalDigit: 2, symbol: true), 5000.5);
    });
  });
   group('DateTimeFormater', () {
    test('dateToString formats correctly', () {
      final date = DateTime(2024, 1, 1, 10, 30);
      expect(DateTimeFormater.dateToString(date, format: 'y-MM-dd'), '2024-01-01');
    });

    test('stringToDateTime parses correctly', () {
      expect(DateTimeFormater.stringToDateTime('2024-01-01 10:30:00'), isA<DateTime>());
      expect(DateTimeFormater.stringToDateTime('not-a-date'), null);
    });

    test('stringToTimestamp converts correctly', () {
      final now = DateTime.now();
      expect(DateTimeFormater.stringToTimestamp(now), now.millisecondsSinceEpoch);
      expect(DateTimeFormater.stringToTimestamp(now.millisecondsSinceEpoch), now.millisecondsSinceEpoch);
    });

    test('msTosecond converts correctly', () {
      expect(DateTimeFormater.msTosecond(1000000000000), 1000000000);
      expect(DateTimeFormater.msTosecond(1000), 1000);
    });
  });

  group('GeneralFormater', () {
    test('stripHtmlIfNeeded removes tags', () {
      expect(GeneralFormater.stripHtmlIfNeeded('<p>Hello</p>'), '\nHello\n');
      expect(GeneralFormater.stripHtmlIfNeeded('plain text'), 'plain text');
    });
  });
}
