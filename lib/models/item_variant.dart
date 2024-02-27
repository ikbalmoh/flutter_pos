import 'package:objectbox/objectbox.dart';
import 'item_variant_image.dart';
import 'package:json_annotation/json_annotation.dart';
import 'converters/generic.dart';

part 'item_variant.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
@Entity()
class ItemVariant {
  int id;

  @Index()
  int idVariant;

  @JsonKey(fromJson: Converters.dynamicToDouble)
  final double stockItem;
  
  final String variantName;
  final double itemPrice;
  final String? skuNumber;
  final String? barcodeNumber;
  final List<String>? promotions;

  final ItemVariantImage? image;

  ItemVariant({
    required this.id,
    required this.idVariant,
    required this.itemPrice,
    this.skuNumber,
    this.barcodeNumber,
    required this.variantName,
    required this.stockItem,
    this.promotions,
    this.image
  });

  factory ItemVariant.fromJson(Map<String, dynamic> json) => _$ItemVariantFromJson(json);

  Map<String, dynamic> toJson() => _$ItemVariantToJson(this);

  @override
  String toString() {
    return '{id_variant: $idVariant, variant_name: $variantName}';
  }

}
