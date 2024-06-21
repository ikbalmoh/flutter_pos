import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/shift_payment.dart';
import 'sold_item.dart';

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
    DateTime? updatedAt,
    String? updatedName,
    String? closedBy,
    double? income,
    double? expense,
    double? cashSales,
    double? debitSalesAmount,
    double? creditSalesAmount,
    List<ShiftPayment>? debitSales,
    List<ShiftPayment>? creditSales,
    List<ShiftPayment>? customSales,
    int? expectedEnd,
    int? expectedCash,
    int? sold,
    List<SoldItem>? soldItems,
  }) = _Shift;

  factory Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);
}
