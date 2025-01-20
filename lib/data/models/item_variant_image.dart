import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/converters/generic.dart';

part 'item_variant_image.freezed.dart';
part 'item_variant_image.g.dart';

@freezed
class ItemVariantImage with _$ItemVariantImage {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory ItemVariantImage({
    required String idItem,
    required int variantId,
    required String imagePath,
    @JsonKey(fromJson: Converters.dynamicToBool) bool? isPrimary,
  }) = _ItemVariantImage;

  factory ItemVariantImage.fromJson(Map<String, dynamic> json) =>
      _$ItemVariantImageFromJson(json);
}
