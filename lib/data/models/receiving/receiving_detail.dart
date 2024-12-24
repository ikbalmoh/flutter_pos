import 'package:selleri/data/models/receiving/receiving_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'receiving_detail.freezed.dart';
part 'receiving_detail.g.dart';

@freezed
class ReceivingDetail with _$ReceivingDetail {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ReceivingDetail({
    required String id,
    required String receiveNumber,
    required DateTime receiveDate,
    required String outletId,
    required int type,
    required String purchaseNumber,
    required String transferNumber,
    String? fromOutletId,
    String? descriptions,
    required int status,
    required DateTime createdAt,
    DateTime? canceledAt,
    String? createdBy,
    String? createdName,
    String? cancelBy,
    required String outletName,
    String? supplierName,
    String? fromOutletName,
    String? typeName,
    String? statusName,
    required List<ReceivingItem> items,
  }) = _ReceivingDetail;

  factory ReceivingDetail.fromJson(Map<String, dynamic> json) =>
      _$ReceivingDetailFromJson(json);
}
