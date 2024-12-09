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
    required String description,
    required DateTime createdAt,
    required String createdBy,
    required bool needApproval,
    required String approval,
    String? approvalNotes,
    required String createdName,
  }) = _AdjustmentHistory;

  factory AdjustmentHistory.fromJson(Map<String, dynamic> json) =>
      _$AdjustmentHistoryFromJson(json);
}
