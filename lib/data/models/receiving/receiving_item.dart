import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/receiving/purchase_item.dart';

part 'receiving_item.freezed.dart';
part 'receiving_item.g.dart';

@freezed
class ReceivingItem with _$ReceivingItem {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ReceivingItem({
    required String itemId,
    String? barcode,
    String? skuNumber,
    required String itemName,
    required int qtyRequest,
    required int qtyReceived,
    required int qtyReceive,
    required double price,
  }) = _ReceivingItem;

  factory ReceivingItem.fromJson(Map<String, dynamic> json) =>
      _$ReceivingItemFromJson(json);

  factory ReceivingItem.fromPurchaseItem(PurchaseItem item) {
    return ReceivingItem(
      itemId: item.itemId,
      skuNumber: item.skuNumber,
      itemName: item.itemName,
      qtyRequest: item.qtyRequest,
      qtyReceived: item.qtyReceived,
      qtyReceive: 0,
      price: item.price,
    );
  }
}
