import 'package:easy_localization/easy_localization.dart';
import 'package:selleri/data/models/shift_summary.dart';

class ShiftUtil {
  static List<SummaryItem> paymentList(ShiftSummary summary) {
    List<SummaryItem> summaries = [];

    double totalCash = (summary.startingCash +
        summary.cashSales +
        summary.income -
        summary.expense -
        summary.refunded);

    double totalDebit = 0;
    double totalCredit = 0;
    double totalCustom = 0;

    List<SummaryItem> cash = [
      SummaryItem(
        label: 'cash'.tr(),
        value: totalCash,
        isTotal: true,
      ),
      SummaryItem(label: 'starting_cash'.tr(), value: summary.startingCash),
      SummaryItem(label: 'cash_sales'.tr(), value: summary.cashSales),
      SummaryItem(label: 'expense'.tr(), value: summary.expense),
      SummaryItem(label: 'income'.tr(), value: summary.income),
      SummaryItem(label: 'refund'.tr(), value: summary.refunded),
    ];
    summaries.addAll(cash);

    if (summary.debitSales!.isNotEmpty) {
      totalDebit =
          summary.debitSales!.map((d) => d.value).reduce((a, b) => a + b);
      List<SummaryItem> debit = [
        SummaryItem(
          label: 'Debit',
          value: totalDebit,
          isTotal: true,
        ),
      ];
      debit.addAll(summary.debitSales!
          .map((d) => SummaryItem(label: d.paymentName, value: d.value))
          .toList());
      summaries.addAll(debit);
    }

    if (summary.creditSales!.isNotEmpty) {
      totalCredit =
          summary.creditSales!.map((d) => d.value).reduce((a, b) => a + b);
      List<SummaryItem> credit = [
        SummaryItem(
          label: 'Credit',
          value: totalCredit,
          isTotal: true,
        ),
      ];
      credit.addAll(summary.creditSales!
          .map((d) => SummaryItem(label: d.paymentName, value: d.value))
          .toList());
      summaries.addAll(credit);
    }

    if (summary.customSales!.isNotEmpty) {
      totalCustom =
          summary.customSales!.map((d) => d.value).reduce((a, b) => a + b);
      List<SummaryItem> custom = [
        SummaryItem(
          label: 'e-wallet',
          value: totalCustom,
          isTotal: true,
        ),
      ];
      custom.addAll(summary.customSales!
          .map((d) => SummaryItem(label: d.paymentName, value: d.value))
          .toList());
      summaries.addAll(custom);
    }

    List<SummaryItem> recap = [
      SummaryItem(
        label: 'summary'.tr(),
        isTotal: true,
      ),
      SummaryItem(
          label: 'total_transaction'.tr(args: ['']),
          value: summary.cashSales - summary.refunded),
      SummaryItem(label: 'expected_cash'.tr(), value: summary.expectedCashEnd),
    ];

    summaries.addAll(recap);
    return summaries;
  }
}
