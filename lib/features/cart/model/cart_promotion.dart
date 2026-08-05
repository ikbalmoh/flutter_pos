import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/shared/utils/model_converter.dart';
import 'package:selleri/features/promotion/model/promotion.dart';

part 'cart_promotion.freezed.dart';
part 'cart_promotion.g.dart';

@freezed
abstract class CartPromotion with _$CartPromotion {
  const CartPromotion._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CartPromotion({
    required String promotionId,
    required String promotionName,
    bool? afterTransaction,
    int? assignCustomer,
    int? type,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) bool? needCode,
    @JsonKey(fromJson: ModelConverter.dynamicToBool)
    required bool discountIsPercent,
    required double discountNominal,
    required double discountValue,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) bool? policy,
    String? idItem,
    int? variantId,
    int? quantity,
    String? voucherCode,
    List<String>? requirementProductId,
    bool? kelipatan,
    int? requirementProductType,
    double? requirementQuantity,
    double? requirementMinimumOrder,
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
        requirementQuantity: data.requirementQuantity?.toDouble(),
        requirementProductId: data.requirementProductId,
        requirementProductType: data.requirementProductType,
        requirementMinimumOrder: data.requirementMinimumOrder,
        policy: data.policy,
        quantity: 0,
        kelipatan: data.kelipatan,
        voucherCode: data.promoCode,
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
