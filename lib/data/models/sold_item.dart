import 'package:freezed_annotation/freezed_annotation.dart';

part 'sold_item.freezed.dart';
part 'sold_item.g.dart';

@freezed
class SoldItem with _$SoldItem {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SoldItem({
    required String idItem,
    required String name,
    required int sold,
  }) = _SoldItem;

  factory SoldItem.fromJson(Map<String, dynamic> json) =>
      _$SoldItemFromJson(json);
}
