import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/features/item/model/item_adjustment.dart';

part 'adjustment.freezed.dart';
part 'adjustment.g.dart';

@freezed
abstract class Adjustment with _$Adjustment {
  const Adjustment._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Adjustment({
    required DateTime date,
    required String description,
    required List<ItemAdjustment> items,
    required bool isLoading,
  }) = _Adjustment;

  factory Adjustment.fromJson(Map<String, dynamic> json) =>
      _$AdjustmentFromJson(json);
}
