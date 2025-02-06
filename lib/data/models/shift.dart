import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift.freezed.dart';
part 'shift.g.dart';

@freezed
class Shift with _$Shift {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Shift({
    required String id,
    required String outletId,
    required String deviceId,
    required DateTime startShift,
    required double openAmount,
    required String createdBy,
    required DateTime createdAt,
    required String outletName,
    required String createdName,
    String? codeShift,
    DateTime? closeShift,
    int? customSalesAmount,
    String? updatedBy,
    double? closeAmount,
    double? diffAmount,
    double? refundAmount,
    double? expectedCashEnd,
    DateTime? updatedAt,
    String? updatedName,
    String? closedBy,
  }) = _Shift;

  factory Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);
}
