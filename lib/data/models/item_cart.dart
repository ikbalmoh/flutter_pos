import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_cart.freezed.dart';
part 'item_cart.g.dart';

@freezed
class ItemCart with _$ItemCart {
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
}
