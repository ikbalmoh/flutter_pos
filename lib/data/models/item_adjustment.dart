import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/item_variant_adjustment.dart';
import 'package:selleri/utils/formater.dart';

part 'item_adjustment.freezed.dart';
part 'item_adjustment.g.dart';

@freezed
class ItemAdjustment with _$ItemAdjustment {
  const ItemAdjustment._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ItemAdjustment({
    required String idItem,
    int? variantId,
    String? variantName,
    required String itemName,
    required String idCategory,
    required String categoryName,
    String? note,
    bool? stockControl,
    int? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    required double stockItem,
    required double qtySystem,
    required double qtyActual,
    required int qtyDiff,
    @JsonKey(
      fromJson: DateTimeFormater.stringToDateTime,
    )
    DateTime? lastAdjustment,
    required List<ItemVariantAdjustment> variants,
  }) = _ItemAdjustment;

  factory ItemAdjustment.fromJson(Map<String, dynamic> json) =>
      _$ItemAdjustmentFromJson(json);
}
