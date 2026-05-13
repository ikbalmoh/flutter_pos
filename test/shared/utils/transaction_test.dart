import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:selleri/features/shift/model/shift_payment.dart';
import 'package:selleri/features/shift/model/shift_summary.dart';
import 'package:selleri/shared/utils/transaction.dart';

void main() {
  setUpAll(() {
    final file = File('assets/translations/en-US.json');
    final jsonString = file.readAsStringSync();
    final translationsMap = json.decode(jsonString);
    Localization.load(const Locale('en', 'US'), translations: Translations(translationsMap));
  });

  group('ShiftUtil', () {
    test('paymentList calculates and structures summary correctly', () {
      const summary = ShiftSummary(
        startingCash: 100000,
        cashSales: 500000,
        totalTransaction: 10,
        expense: 50000,
        income: 20000,
        refunded: 10000,
        debitSales: [
          ShiftPayment(paymentMethodId: '1', paymentName: 'BCA', value: 200000),
        ],
        creditSales: [
          ShiftPayment(paymentMethodId: '2', paymentName: 'Visa', value: 300000),
        ],
        customSales: [
          ShiftPayment(paymentMethodId: '3', paymentName: 'Gopay', value: 150000),
        ],
        expectedEnd: 1110000,
        expectedCashEnd: 560000,
        actualCash: 560000,
        different: 0,
      );

      final result = ShiftUtil.paymentList(summary);

      // Check if cash items are present
      expect(result.any((item) => item.label.toLowerCase().contains('cash')), isTrue);
      
      // Check total cash calculation: 100000 + 500000 + 20000 - 50000 - 10000 = 560000
      final totalCashItem = result.firstWhere((item) => item.isTotal == true && item.label.toLowerCase().contains('cash'));
      expect(totalCashItem.value, 560000);

      // Check debit
      expect(result.any((item) => item.label == 'Debit'), isTrue);
      expect(result.any((item) => item.label == 'BCA'), isTrue);

      // Check credit
      expect(result.any((item) => item.label == 'Credit'), isTrue);
      expect(result.any((item) => item.label == 'Visa'), isTrue);

      // Check custom (e-wallet)
      expect(result.any((item) => item.label == 'e-wallet'), isTrue);
      expect(result.any((item) => item.label == 'Gopay'), isTrue);

      // Check summary recap
      expect(result.any((item) => item.label.toLowerCase().contains('summary')), isTrue);
    });
  });
}
