import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/features/shift/model/shift_cashflow.dart';

part 'shift_cashflows.freezed.dart';
part 'shift_cashflows.g.dart';

@freezed
abstract class ShiftCashFlows with _$ShiftCashFlows {
  const ShiftCashFlows._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ShiftCashFlows({
    required List<ShiftCashflow> data,
    required double total,
  }) = _ShiftCashFlows;

  factory ShiftCashFlows.fromJson(Map<String, dynamic> json) =>
      _$ShiftCashFlowsFromJson(json);
}
