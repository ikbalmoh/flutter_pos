import 'package:freezed_annotation/freezed_annotation.dart';

part 'adjustment_history.freezed.dart';
part 'adjustment_history.g.dart';

@freezed
class AdjustmentHistory with _$AdjustmentHistory {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AdjustmentHistory({
    required String idAdjustment,
    required String adjustmentNo,
    required DateTime adjustmentDate,
    required DateTime createdAt,
    required String createdBy,
    required bool needApproval,
    String? approval,
    String? createdName,
    String? approvalNotes,
    String? description,
  }) = _AdjustmentHistory;

  factory AdjustmentHistory.fromJson(Map<String, dynamic> json) =>
      _$AdjustmentHistoryFromJson(json);
}
