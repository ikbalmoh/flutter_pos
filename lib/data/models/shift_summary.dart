import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/shift_payment.dart';

part 'shift_summary.freezed.dart';
part 'shift_summary.g.dart';

@freezed
class ShiftSummary with _$ShiftSummary {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ShiftSummary({
    required double startingCash,
    required double cashSales,
    @JsonKey(name: 'Expense') required double expense,
    @JsonKey(name: 'Income') required double income,
    @JsonKey(name: 'Refunded') required double refunded,
    required List<ShiftPayment>? debitSales,
    required List<ShiftPayment>? creditSales,
    required List<ShiftPayment>? customSales,
    required double expectedEnd,
    required double expectedCashEnd,
    required double actualCash,
    required double different,
  }) = _ShiftSummary;

  factory ShiftSummary.fromJson(Map<String, dynamic> json) =>
      _$ShiftSummaryFromJson(json);
}

class SummaryItem {
  final String label;
  final double? value;
  final bool? isTotal;
  final bool? isStartingCash;

  const SummaryItem({
    required this.label,
    this.value,
    this.isTotal,
    this.isStartingCash,
  });
}
