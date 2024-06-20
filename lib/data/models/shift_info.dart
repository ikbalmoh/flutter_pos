import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/shift_cashflows.dart';
import 'package:selleri/data/models/shift_summary.dart';
import 'sold_item.dart';

part 'shift_info.freezed.dart';
part 'shift_info.g.dart';

@freezed
class ShiftInfo with _$ShiftInfo {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ShiftInfo({
    required String codeShift,
    String? deviceName,
    required String outletId,
    String? outletName,
    required String openedBy,
    String? closedBy,
    required DateTime openShift,
    String? closeShift,
    required double saldoKas,
    required double selisih,
    required ShiftCashFlows cashFlows,
    required ShiftSummary summary,
    required List<SoldItem> soldItems,
    required List<dynamic> refundItems,
    required List<dynamic> attachments,
  }) = _ShiftInfo;

  factory ShiftInfo.fromJson(Map<String, dynamic> json) => _$ShiftInfoFromJson(json);
}

