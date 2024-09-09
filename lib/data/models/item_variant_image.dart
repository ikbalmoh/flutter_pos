import 'package:json_annotation/json_annotation.dart';
import 'package:selleri/data/models/converters/generic.dart';

part 'item_variant_image.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ItemVariantImage {
  String idItem;
  int variantId;
  String imagePath;

  @JsonKey(fromJson: Converters.dynamicToBool)
  bool? isPrimary;

  ItemVariantImage({
    required this.idItem,
    required this.variantId,
    required this.imagePath,
    this.isPrimary,
  });

  factory ItemVariantImage.fromJson(Map<String, dynamic> json) => _$ItemVariantImageFromJson(json);

  Map<String, dynamic> toJson() => _$ItemVariantImageToJson(this);
}
