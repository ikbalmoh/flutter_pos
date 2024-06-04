import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_payment.freezed.dart';
part 'cart_payment.g.dart';

@freezed
class CartPayment with _$CartPayment {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CartPayment({
    int? payDate,
    required String paymentMethodId,
    required String paymentname,
    required double paymentValue,
    String? reference,
    String? createdBy,
  }) = _CartPayment;

  factory CartPayment.fromJson(Map<String, dynamic> json) =>
      _$CartPaymentFromJson(json);
}
