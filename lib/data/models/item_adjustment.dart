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
    required String itemName,
    required String idCategory,
    required String categoryName,
    required String note,
    required bool stockControl,
    required int isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int stockItem,
    required String qtySystem,
    required String qtyActual,
    required int qtyDiff,
    @JsonKey(
      fromJson: DateTimeFormater.stringToDateTime,
    )
    DateTime? lastAdjustment,
    required List<ItemVariantAdjustment> variants,
  }) = _ItemAdjustment;

  factory ItemAdjustment.fromJson(Map<String, dynamic> json) => _$ItemAdjustmentFromJson(json);

}