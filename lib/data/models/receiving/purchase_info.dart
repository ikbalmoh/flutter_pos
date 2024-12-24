import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/receiving/purchase_item.dart';

part 'purchase_info.freezed.dart';
part 'purchase_info.g.dart';

@freezed
class PurchaseInfo with _$PurchaseInfo {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PurchaseInfo({
    required String refNumber,
    required String refFrom,
    required List<PurchaseItem> items,
  }) = _PurchaseInfo;

  factory PurchaseInfo.fromJson(Map<String, dynamic> json) =>
      _$PurchaseInfoFromJson(json);
}
