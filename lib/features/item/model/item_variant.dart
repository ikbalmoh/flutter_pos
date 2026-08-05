import 'package:objectbox/objectbox.dart';
import '../../../shared/utils/model_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_variant.freezed.dart';
part 'item_variant.g.dart';

@Freezed(addImplicitFinal: false, makeCollectionsUnmodifiable: false)
abstract class ItemVariant with _$ItemVariant {
  const ItemVariant._();

  @Entity(uid: 4358767868100185192, realClass: ItemVariant)
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory ItemVariant({
    @Default(0) @Id() int id,
    @Index() required int idVariant,
    @JsonKey(fromJson: ModelConverter.dynamicToDouble)
    required double stockItem,
    required String idItem,
    @Default('') String variantName,
    @Default(0.0) double itemPrice,
    @Default('') String skuNumber,
    @Default('') String barcodeNumber,
    @Default([]) List<String> promotions,
  }) = _ItemVariant;

  factory ItemVariant.fromJson(Map<String, dynamic> json) =>
      _$ItemVariantFromJson(json);
}
