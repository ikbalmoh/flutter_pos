import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/receiving/purchase_item_variant.dart';
import 'package:selleri/data/models/receiving/receiving_item.dart';

part 'purchase_item.freezed.dart';
part 'purchase_item.g.dart';

@freezed
class PurchaseItem with _$PurchaseItem {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PurchaseItem({
    required String itemId,
    int? variantId,
    String? skuNumber,
    required String itemName,
    required int qtyRequest,
    required int qtyReceived,
    int? qtyReceive,
    required int qtyResidual,
    required double price,
    List<PurchaseItemVariant>? variants,
  }) = _PurchaseItem;

  factory PurchaseItem.fromJson(Map<String, dynamic> json) =>
      _$PurchaseItemFromJson(json);

  factory PurchaseItem.fromReceivingItem(ReceivingItem item) => PurchaseItem(
        itemId: item.itemId,
        variantId: item.variantId,
        skuNumber: item.skuNumber,
        itemName: item.itemName,
        qtyRequest: item.qtyRequest,
        qtyReceived: item.qtyReceived,
        qtyReceive: item.qtyReceive,
        qtyResidual: item.qtyRequest - item.qtyReceived,
        price: item.price,
      );
}
