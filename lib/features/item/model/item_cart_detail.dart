import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/features/item/model/item.dart';
import 'package:selleri/shared/objectbox.dart';
import 'package:selleri/shared/utils/model_converter.dart';

part 'item_cart_detail.freezed.dart';
part 'item_cart_detail.g.dart';

@freezed
class ItemCartDetail with _$ItemCartDetail {
  const ItemCartDetail._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ItemCartDetail({
    required String itemId,
    required String name,
    required int? variantId,
    required int? quantity,
    @JsonKey(fromJson: ModelConverter.dynamicToDouble)
    required double itemPrice,
  }) = _ItemCartDetail;

  factory ItemCartDetail.fromJson(Map<String, dynamic> json) =>
      _$ItemCartDetailFromJson(json);

  Item? item() => objectBox.getItem(itemId);
}
