import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/utils/formater.dart';

part 'cart_payment.freezed.dart';
part 'cart_payment.g.dart';

@freezed
class CartPayment with _$CartPayment {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CartPayment({
    @JsonKey(fromJson: DateTimeFormater.stringToTimestamp) int? payDate,
    required String paymentMethodId,
    required String paymentName,
    required double paymentValue,
    String? reference,
    String? createdBy,
    DateTime? createdAt,
  }) = _CartPayment;

  factory CartPayment.fromJson(Map<String, dynamic> json) =>
      _$CartPaymentFromJson(json);
}
