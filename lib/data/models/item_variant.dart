import 'package:objectbox/objectbox.dart';
import 'converters/generic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_variant.freezed.dart';
part 'item_variant.g.dart';

@Freezed(addImplicitFinal: false)
class ItemVariant with _$ItemVariant {
  const ItemVariant._();

  @Entity(uid: 4358767868100185192, realClass: ItemVariant)
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory ItemVariant({
    @Default(0) @Id() int id,
    @Index() required int idVariant,
    @JsonKey(fromJson: Converters.dynamicToDouble) required double stockItem,
    required String idItem,
    required String variantName,
    required double itemPrice,
    String? skuNumber,
    String? barcodeNumber,
    List<String>? promotions,
  }) = _ItemVariant;

  factory ItemVariant.fromJson(Map<String, dynamic> json) =>
      _$ItemVariantFromJson(json);
}
