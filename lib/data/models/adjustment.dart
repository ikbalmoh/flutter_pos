import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/item_adjustment.dart';

part 'adjustment.freezed.dart';
part 'adjustment.g.dart';

@freezed
class Adjustment with _$Adjustment {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Adjustment({
    required DateTime date,
    required String note,
    required List<ItemAdjustment> items,
  }) = _Adjustment;

  factory Adjustment.fromJson(Map<String, dynamic> json) => _$AdjustmentFromJson(json);
}
