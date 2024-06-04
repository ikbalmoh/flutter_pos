import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_cart.freezed.dart';
part 'item_cart.g.dart';

@freezed
class ItemCart with _$ItemCart {
  const ItemCart._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ItemCart({
    required String identifier,
    required String idItem,
    required String itemName,
    required bool isPackage,
    required bool isManualPrice,
    required double price,
    required bool manualDiscount,
    required int quantity,
    required double discount,
    required bool discountIsPercent,
    required double discountTotal,
    required DateTime addedAt,
    required double total,
    required String note,
    num? idVariant,
    String? variantName,
  }) = _ItemCart;

  factory ItemCart.fromJson(Map<String, dynamic> json) =>
      _$ItemCartFromJson(json);

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
        "total": total,
        "note": note,
        "item_name": itemName,
        "details": []
      };
}
