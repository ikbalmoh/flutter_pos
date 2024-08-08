import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/converters/generic.dart';
import 'package:selleri/data/models/promotion.dart';

part 'cart_promotion.freezed.dart';
part 'cart_promotion.g.dart';

@freezed
class CartPromotion with _$CartPromotion {
  const CartPromotion._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CartPromotion({
    required String promotionId,
    required String promotionName,
    bool? afterTransaction,
    int? assignCustomer,
    int? type,
    @JsonKey(fromJson: Converters.dynamicToBool) bool? needCode,
    @JsonKey(fromJson: Converters.dynamicToBool)
    required bool discountIsPercent,
    required double discountNominal,
    required double discountValue,
    @JsonKey(fromJson: Converters.dynamicToBool) bool? policy,
    String? idItem,
    int? variantId,
    int? quantity,
    String? voucherCode,
    List<String>? requirementProductId,
    bool? kelipatan,
    int? requirementProductType,
    int? requirementQuantity,
  }) = _CartPromotion;

  factory CartPromotion.fromJson(Map<String, dynamic> json) =>
      _$CartPromotionFromJson(json);

  factory CartPromotion.fromData(Promotion data) => CartPromotion(
        promotionId: data.idPromotion,
        promotionName: data.name,
        assignCustomer: data.assignCustomer,
        type: data.type,
        needCode: data.needCode,
        discountIsPercent: data.discountType == true ? true : false,
        discountNominal: data.rewardNominal,
        discountValue: data.rewardNominal,
        policy: data.policy,
        quantity: 0,
        kelipatan: data.kelipatan,
      );

  Map<String, dynamic> toTransactionPayload() => <String, dynamic>{
        "id_item": idItem,
        "variant_id": variantId,
        "quantity": quantity,
        "promotion_id": promotionId,
        "discount_value": discountValue,
        "discount_nominal": discountNominal,
        "discount_is_percent": discountIsPercent,
      };
}
