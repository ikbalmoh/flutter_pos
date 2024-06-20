import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift_summary.freezed.dart';
part 'shift_summary.g.dart';

@freezed
class ShiftSummary with _$ShiftSummary {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ShiftSummary({
    required double startingCash,
    required double cashSales,
    @JsonKey(name: 'Expense')
    required double expense,
    @JsonKey(name: 'Income')
    required double income,
    @JsonKey(name: 'Refunded')
    required double refunded,
    required List<dynamic> debitSales,
    required List<dynamic> creditSales,
    required List<dynamic> customSales,
    required double expectedEnd,
    required double expectedCashEnd,
    required double actualCash,
    required double different,
  }) = _ShiftSummary;

  factory ShiftSummary.fromJson(Map<String, dynamic> json) => _$ShiftSummaryFromJson(json);
}
