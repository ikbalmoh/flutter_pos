import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/features/item/model/item.dart';
import 'package:selleri/shared/objectbox.dart';
import 'package:selleri/shared/utils/model_converter.dart';

part 'item_cart_detail.freezed.dart';
part 'item_cart_detail.g.dart';


@freezed
abstract class ItemCartDetail with _$ItemCartDetail {
  const ItemCartDetail._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ItemCartDetail({
    @JsonKey(name: 'id_item', readValue: _readIdItem) required String idItem,
    required String name,
    @JsonKey(name: 'variant_id') required int? variantId,
    required int? quantity,
    @JsonKey(name: 'item_price', fromJson: ModelConverter.dynamicToDouble)
    required double itemPrice,
  }) = _ItemCartDetail;

  factory ItemCartDetail.fromJson(Map<String, dynamic> json) =>
      _$ItemCartDetailFromJson(json);

  Item? item() => objectBox.getItem(idItem);
}

Object? _readIdItem(Map map, String key) => map['id_item'] ?? map['item_id'];
