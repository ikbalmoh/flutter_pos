import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift_payment.freezed.dart';
part 'shift_payment.g.dart';

@freezed
class ShiftPayment with _$ShiftPayment {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ShiftPayment({
    required String paymentMethodId,
    required String paymentName,
    required double value,
  }) = _ShiftPayment;

  factory ShiftPayment.fromJson(Map<String, dynamic> json) =>
      _$ShiftPaymentFromJson(json);
}
