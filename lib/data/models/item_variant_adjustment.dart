import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/item_variant_image.dart';
import 'package:selleri/utils/formater.dart';

part 'item_variant_adjustment.freezed.dart';
part 'item_variant_adjustment.g.dart';

@freezed
class ItemVariantAdjustment with _$ItemVariantAdjustment {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ItemVariantAdjustment({
    required int idVariant,
    required double itemPrice,
    required String skuNumber,
    required String barcodeNumber,
    ItemVariantImage? image,
    required String variantName,
    required double stockItem,
    required double qtyActual,
    required double qtySystem,
    required int qtyDiff,
    @JsonKey(
      fromJson: DateTimeFormater.stringToDateTime,
    )
    DateTime? lastAdjustment,
  }) = _ItemVariantAdjustment;

  factory ItemVariantAdjustment.fromJson(Map<String, dynamic> json) =>
      _$ItemVariantAdjustmentFromJson(json);
}
