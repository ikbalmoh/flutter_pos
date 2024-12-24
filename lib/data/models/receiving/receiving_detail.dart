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
    String? supplierId,
    required String fromOutletId,
    String? descriptions,
    required int status,
    required DateTime createdAt,
    required DateTime canceledAt,
    required String createdBy,
    required String cancelBy,
    required String outletName,
    String? supplierName,
    required String fromOutletName,
    required String typeName,
    required String statusName,
    required List<ReceivingItem> items,
  }) = _ReceivingDetail;

  factory ReceivingDetail.fromJson(Map<String, dynamic> json) =>
      _$ReceivingDetailFromJson(json);
}
