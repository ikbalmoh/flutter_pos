import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/shift_cashflow_image.dart';

part 'shift_cashflow.freezed.dart';
part 'shift_cashflow.g.dart';

@freezed
class ShiftCashflow with _$ShiftCashflow {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ShiftCashflow({
    required String id,
    required String codeCf,
    required DateTime transDate,
    required String shiftId,
    required String outletId,
    required int status,
    required double amount,
    required int idAkun,
    required List<ShiftCashflowImage> images,
    String? descriptions,
  }) = _ShiftCashflow;

  factory ShiftCashflow.fromJson(Map<String, dynamic> json) =>
      _$ShiftCashflowFromJson(json);
}
