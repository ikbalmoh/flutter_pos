import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/shared/utils/formater.dart';
import 'package:selleri/shared/utils/model_converter.dart';

part 'cart_payment.freezed.dart';
part 'cart_payment.g.dart';

@freezed
abstract class CartPayment with _$CartPayment {
  const CartPayment._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CartPayment({
    DateTime? createdAt,
    @JsonKey(
      fromJson: DateTimeFormater.stringToTimestamp,
      toJson: DateTimeFormater.msTosecond,
    )
    @JsonKey(fromJson: ModelConverter.dynamicToInt)
    int? payDate,
    @JsonKey(fromJson: ModelConverter.dynamicToString) String? id,
    required String paymentMethodId,
    @JsonKey(fromJson: ModelConverter.nullableToString)
    required String paymentName,
    required double paymentValue,
    String? shiftId,
    @JsonKey(fromJson: ModelConverter.dynamicToString) String? reference,
    @JsonKey(fromJson: ModelConverter.dynamicToString) String? createdBy,
  }) = _CartPayment;

  factory CartPayment.fromJson(Map<String, dynamic> json) =>
      _$CartPaymentFromJson(json);
}
