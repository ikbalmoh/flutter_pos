import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/cart.dart';

part 'cart_holded.freezed.dart';
part 'cart_holded.g.dart';

@freezed
class CartHolded with _$CartHolded {
  const CartHolded._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CartHolded({
    required String transactionId,
    required String idOutlet,
    required String shiftId,
    required String transactionDate,
    required String transactionNo,
    String? idCustomer,
    String? customerName,
    required DateTime createdAt,
    String? createdName,
    String? description,
    @JsonKey(fromJson: Cart.fromDataHold) required Cart dataHold,
  }) = _CartHolded;

  factory CartHolded.fromJson(Map<String, dynamic> json) =>
      _$CartHoldedFromJson(json);
}
