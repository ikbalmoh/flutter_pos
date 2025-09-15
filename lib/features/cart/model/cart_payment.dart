import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/shared/utils/formater.dart';

part 'cart_payment.freezed.dart';
part 'cart_payment.g.dart';

@freezed
class CartPayment with _$CartPayment {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CartPayment({
    DateTime? createdAt,
    @JsonKey(
      fromJson: DateTimeFormater.stringToTimestamp,
      toJson: DateTimeFormater.msTosecond,
    )
    int? payDate,
    String? id,
    required String paymentMethodId,
    required String paymentName,
    required double paymentValue,
    String? shiftId,
    String? reference,
    String? createdBy,
  }) = _CartPayment;

  factory CartPayment.fromJson(Map<String, dynamic> json) =>
      _$CartPaymentFromJson(json);
}
