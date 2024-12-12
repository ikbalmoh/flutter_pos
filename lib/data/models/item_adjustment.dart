import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/item_variant_adjustment.dart';
import 'package:selleri/utils/formater.dart';
import 'package:selleri/data/models/converters/generic.dart';

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
    String? idCategory,
    String? categoryName,
    String? note,
    bool? stockControl,
    int? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    @JsonKey(fromJson: Converters.dynamicToDouble) required double? stockItem,
    @JsonKey(fromJson: Converters.dynamicToDouble) required double? qtySystem,
    @JsonKey(fromJson: Converters.dynamicToDouble) required double? qtyActual,
    @JsonKey(fromJson: Converters.dynamicToInt) required int? qtyDiff,
    @JsonKey(
      fromJson: DateTimeFormater.stringToDateTime,
    )
    DateTime? lastAdjustment,
    List<ItemVariantAdjustment>? variants,
  }) = _ItemAdjustment;

  factory ItemAdjustment.fromJson(Map<String, dynamic> json) =>
      _$ItemAdjustmentFromJson(json);

  factory ItemAdjustment.fromDetail(Map<String, dynamic> json) {
    json['categpry_name'] = json['item_category'] ?? '';
    return _$ItemAdjustmentFromJson(json);
  }
}
