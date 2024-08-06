import 'package:freezed_annotation/freezed_annotation.dart';

part 'promotion_time.freezed.dart';
part 'promotion_time.g.dart';

@freezed
class PromotionTime with _$PromotionTime {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PromotionTime({
    required String startTime,
    required String endTime,
  }) = _PromotionTime;

  factory PromotionTime.fromJson(Map<String, dynamic> json) =>
      _$PromotionTimeFromJson(json);
}
