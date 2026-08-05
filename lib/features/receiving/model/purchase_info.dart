import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/features/receiving/model/purchase_item.dart';

part 'purchase_info.freezed.dart';
part 'purchase_info.g.dart';

@freezed
abstract class PurchaseInfo with _$PurchaseInfo {
  const PurchaseInfo._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PurchaseInfo({
    required String refNumber,
    required String refFrom,
    required List<PurchaseItem> items,
  }) = _PurchaseInfo;

  factory PurchaseInfo.fromJson(Map<String, dynamic> json) =>
      _$PurchaseInfoFromJson(json);
}
