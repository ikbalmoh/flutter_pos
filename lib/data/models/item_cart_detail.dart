import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/converters/generic.dart';

part 'item_cart_detail.freezed.dart';
part 'item_cart_detail.g.dart';

@freezed
class ItemCartDetail with _$ItemCartDetail {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ItemCartDetail({
    required String itemId,
    required String name,
    required int? variantId,
    required int? quantity,
    @JsonKey(fromJson: Converters.dynamicToDouble) required double itemPrice,
  }) = _ItemCartDetail;

  factory ItemCartDetail.fromJson(Map<String, dynamic> json) =>
      _$ItemCartDetailFromJson(json);
}
