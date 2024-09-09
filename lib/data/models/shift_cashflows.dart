import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/shift_cashflow.dart';

part 'shift_cashflows.freezed.dart';
part 'shift_cashflows.g.dart';

@freezed
class ShiftCashFlows with _$ShiftCashFlows {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ShiftCashFlows({
    required List<ShiftCashflow> data,
    required double total,
  }) = _ShiftCashFlows;

  factory ShiftCashFlows.fromJson(Map<String, dynamic> json) =>
      _$ShiftCashFlowsFromJson(json);
}
