import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/cart_promotion.dart';
import 'package:selleri/data/models/converters/generic.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/models/item_cart_detail.dart';
import 'package:selleri/data/models/item_variant.dart';
import 'package:selleri/data/models/promotion.dart';
import 'package:selleri/utils/formater.dart';
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
    @JsonKey(fromJson: Converters.dynamicToBool) required bool isPackage,
    @JsonKey(fromJson: Converters.dynamicToBool) required bool isManualPrice,
    required double price,
    double? purchasePrice,
    @JsonKey(fromJson: Converters.dynamicToBool) required bool manualDiscount,
    required int quantity,
    required double discount,
    @JsonKey(fromJson: Converters.dynamicToBool)
    required bool discountIsPercent,
    required double discountTotal,
    DateTime? addedAt,
    required double total,
    String? note,
    @JsonKey(fromJson: Converters.dynamicToInt) int? idVariant,
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

  factory ItemCart.fromItem(
    Item item, {
    ItemVariant? variant,
    Promotion? promotion,
  }) {
    String identifier = item.idItem;
    String itemName = item.itemName;
    double itemPrice = item.itemPrice;
    int quantity = 1;
    bool discountIsPercent = true;
    double discount = 0;
    double discountTotal = 0;
    double total = itemPrice * quantity;

    CartPromotion? itemCartPromotion;

    if (item.isPackage) {
      identifier += (DateTime.now().millisecondsSinceEpoch).toString();
    } else if (variant != null) {
      identifier += '-v${variant.idVariant.toString()}';
      itemPrice = variant.itemPrice;
    }

    if (promotion != null) {
      identifier = 'reward-$identifier';
      quantity = promotion.rewardQty ?? 1;
      if (promotion.rewardType == 1) {
        itemPrice = 0;
      } else {
        discountIsPercent = promotion.rewardType == 2;
        discount = promotion.rewardNominal;
        discountTotal =
            discountIsPercent ? itemPrice * (discount / 100) : discount;
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
      total: total,
      addedAt: DateTime.now(),
      idVariant: variant?.idVariant,
      variantName: variant?.variantName ?? '',
      details: item.packageItems
          .map(
            (pkg) => ItemCartDetail(
              itemId: pkg.idItem,
              name: pkg.itemName,
              variantId: pkg.variantId,
              quantity: pkg.quantityItem,
              itemPrice: pkg.itemPrice,
            ),
          )
          .toList(),
      promotion: itemCartPromotion,
    );

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
        "discount_is_percent": discountIsPercent ? 1 : 0,
        "discount": discount,
        "discount_total": discountTotal,
        "promotion_id": promotion?.promotionId,
        "total": total,
        "note": note,
        "item_name":
            idVariant != null ? [itemName, variantName].join(' - ') : itemName,
        "pic_detail_id": picDetailId,
        "details": isPackage && details.isNotEmpty
            ? details.map((itemPackage) => itemPackage.toJson()).toList()
            : [],
        "added_at":
            addedAt != null ? DateTimeFormater.dateToString(addedAt!) : null,
        "is_reward": isReward,
      };
}
