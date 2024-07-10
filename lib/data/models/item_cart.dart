import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/cart_promotion.dart';
import 'package:selleri/data/models/converters/generic.dart';
import 'package:selleri/data/models/item_cart_detail.dart';
import 'package:uuid/uuid.dart';
import 'package:selleri/data/models/item_package.dart';

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
    @JsonKey(fromJson: Converters.dynamicToBool) required bool isPackage,
    @JsonKey(fromJson: Converters.dynamicToBool) required bool isManualPrice,
    required double price,
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
  }) = _ItemCart;

  factory ItemCart.fromJson(Map<String, dynamic> json) =>
      _$ItemCartFromJson(json);

  @override
  String toString() {
    return json.encode(toJson());
  }

  Map<String, dynamic> toTransactionPayload() => <String, dynamic>{
        "id": uuid.v4(),
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
        "item_name": itemName,
        "pic_detail_id": picDetailId,
        "details": isPackage && details.isNotEmpty
            ? details.map((itemPackage) => itemPackage.toJson()).toList()
            : [],
      };
}
