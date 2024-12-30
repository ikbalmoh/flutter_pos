import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_item_variant.freezed.dart';
part 'purchase_item_variant.g.dart';

@freezed
class PurchaseItemVariant with _$PurchaseItemVariant {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PurchaseItemVariant({
    required String itemId,
    required int variantId,
    String? barcode,
    String? skuNumber,
    required String variantName,
    required int qtyReceived,
    required double price,
  }) = _PurchaseItemVariant;

  factory PurchaseItemVariant.fromJson(Map<String, dynamic> json) =>
      _$PurchaseItemVariantFromJson(json);
}
