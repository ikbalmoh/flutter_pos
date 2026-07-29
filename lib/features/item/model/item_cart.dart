import 'dart:convert';
import 'dart:developer';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/features/cart/model/cart_promotion.dart';
import 'package:selleri/shared/utils/model_converter.dart';
import 'package:selleri/features/item/model/item.dart';
import 'package:selleri/features/item/model/item_cart_detail.dart';
import 'package:selleri/features/item/model/item_variant.dart';
import 'package:selleri/features/promotion/model/promotion.dart';
import 'package:selleri/shared/utils/formater.dart';
import 'package:uuid/uuid.dart';

part 'item_cart.freezed.dart';
part 'item_cart.g.dart';

var uuid = const Uuid();

@freezed
class ItemCart with _$ItemCart {
  const ItemCart._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ItemCart({
    String? identifier,
    required String idItem,
    required String? idCategory,
    required String itemName,
    bool? isExtraItem,
    String? extraName,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) required bool isPackage,
    @JsonKey(fromJson: ModelConverter.dynamicToBool)
    required bool isManualPrice,
    required double price,
    double? purchasePrice,
    @JsonKey(fromJson: ModelConverter.dynamicToBool)
    required bool manualDiscount,
    required double quantity,
    required double discount,
    @JsonKey(fromJson: ModelConverter.dynamicToBool)
    required bool discountIsPercent,
    required double discountTotal,
    DateTime? addedAt,
    required double total,
    String? note,
    @JsonKey(fromJson: ModelConverter.dynamicToInt) int? idVariant,
    String? variantName,
    required List<ItemCartDetail> details,
    String? picDetailId,
    String? picName,
    CartPromotion? promotion,
    bool? isReward,
    int? rewardType,
  }) = _ItemCart;

  factory ItemCart.fromJson(Map<String, dynamic> json) =>
      _$ItemCartFromJson(json);

  factory ItemCart.copyWithPromotion(ItemCart itemCart,
      {Promotion? promotion, bool isReward = false}) {
    String identifier = itemCart.idItem;
    bool discountIsPercent = true;
    double discount = 0;
    double discountTotal = 0;
    double quantity = itemCart.quantity;
    double itemPrice = itemCart.price;
    double total = itemPrice * quantity;

    if (promotion != null) {
      if (isReward) {
        log('REWARD PROMOTION: ${promotion.name}');
        identifier = 'reward-${promotion.idPromotion}';
      } else {
        log('ITEM PROMOTION: ${promotion.name}');
      }
      if (!isReward && promotion.type != 1) {
        discountIsPercent = promotion.discountType == true;
        discount = promotion.rewardNominal;
        double requirementQty = promotion.requirementQuantity?.toDouble() ?? 1;
        double rewardQuantity = 1;
        discountTotal = discount;
        if (discountIsPercent) {
          discountTotal = itemPrice * (discount / 100);
          rewardQuantity = requirementQty * (quantity ~/ requirementQty);
        } else {
          if (quantity > requirementQty) {
            rewardQuantity = (quantity ~/ requirementQty).toDouble();
          }
        }
        discountTotal *= rewardQuantity;
        if (promotion.rewardMaximumAmount != null &&
            promotion.rewardMaximumAmount! > 0 &&
            discountTotal > promotion.rewardMaximumAmount!) {
          discountTotal = promotion.rewardMaximumAmount!;
        }

        log('PROMOTION DISCOUNT: $discount => $discountTotal');
      }
    }

    return itemCart.copyWith(
      identifier: identifier,
      price: itemPrice,
      quantity: quantity,
      discount: discount,
      discountIsPercent: discountIsPercent,
      discountTotal: discountTotal,
      total: total - discountTotal,
      promotion: promotion != null
          ? CartPromotion.fromData(promotion)
              .copyWith(discountValue: discountTotal)
          : null,
      isReward: isReward,
    );
  }

  factory ItemCart.asReward(
    Item item, {
    ItemVariant? variant,
    Promotion? promotion,
    double quantity = 1,
  }) {
    String identifier = item.idItem;
    String itemName = item.itemName;
    double itemPrice = item.itemPrice;
    bool discountIsPercent = true;
    double discount = 0;
    double discountTotal = 0;
    double total = itemPrice * quantity;

    CartPromotion? itemCartPromotion =
        promotion != null ? CartPromotion.fromData(promotion) : null;

    if (item.isPackage) {
      identifier += (DateTime.now().millisecondsSinceEpoch).toString();
    } else if (variant != null) {
      identifier += '-v${variant.idVariant.toString()}';
      itemPrice = variant.itemPrice;
    }

    if (promotion != null) {
      log('ITEM CART PROMOTION: ${promotion.name}');
      identifier = 'reward-${promotion.idPromotion}';
      if (promotion.rewardType == 1) {
        itemPrice = 0;
      } else {
        discountIsPercent = promotion.discountType == true;
        discount = promotion.rewardNominal;
        discountTotal =
            discountIsPercent ? itemPrice * (discount / 100) : discount;
      }
      if (promotion.rewardMaximumAmount != null &&
          promotion.rewardMaximumAmount! > 0 &&
          discountTotal > promotion.rewardMaximumAmount!) {
        discountTotal = promotion.rewardMaximumAmount!;
      }
      total = itemPrice * quantity;
    }

    ItemCart itemCart = ItemCart(
      identifier: identifier,
      idItem: item.idItem,
      idCategory: item.idCategory,
      itemName: itemName,
      price: itemPrice,
      isPackage: item.isPackage,
      manualDiscount: item.manualDiscount,
      isManualPrice: item.isManualPrice,
      quantity: quantity,
      discount: discount,
      discountIsPercent: discountIsPercent,
      discountTotal: discountTotal,
      note: '',
      total: total - discountTotal,
      addedAt: DateTime.now(),
      idVariant: variant?.idVariant,
      variantName: variant?.variantName ?? '',
      details: item.packageItems
          .map(
            (pkg) => ItemCartDetail(
              idItem: pkg.idItem,
              name: pkg.itemName,
              variantId: pkg.variantId,
              quantity: pkg.quantityItem,
              itemPrice: pkg.itemPrice,
            ),
          )
          .toList(),
      promotion: itemCartPromotion,
      isReward: true,
    );

    log('ITEM CART FROM ITEM: ${itemCart.itemName}');

    return itemCart;
  }

  @override
  String toString() {
    return json.encode(toJson());
  }

  Map<String, dynamic> toTransactionPayload() => <String, dynamic>{
        "id": identifier,
        "id_item": idItem,
        "variant_id": idVariant,
        "quantity": quantity,
        "price": price,
        "purchase_price": purchasePrice,
        "discount_is_percent": discountIsPercent ? 1 : 0,
        "discount": discount,
        "discount_total": discountTotal,
        "promotion_id": promotion?.promotionId,
        "total": total,
        "note": note,
        "item_name": idVariant != null
            ? [itemName.trim(), variantName?.trim()]
                .where((name) => name != null && name.isNotEmpty)
                .join(' - ')
            : itemName,
        "pic_detail_id": picDetailId,
        "details": isPackage && details.isNotEmpty
            ? details.map((itemPackage) => itemPackage.toJson()).toList()
            : [],
        "added_at":
            addedAt != null ? DateTimeFormater.dateToString(addedAt!) : null,
        "is_reward": isReward,
      };
}
