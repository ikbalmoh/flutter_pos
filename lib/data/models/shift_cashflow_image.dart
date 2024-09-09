import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift_cashflow_image.freezed.dart';
part 'shift_cashflow_image.g.dart';

@freezed
class ShiftCashflowImage with _$ShiftCashflowImage {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ShiftCashflowImage({
    required int id,
    required String uri,
    required String name,
  }) = _ShiftCashflowImage;

  factory ShiftCashflowImage.fromJson(Map<String, dynamic> json) =>
      _$ShiftCashflowImageFromJson(json);
}
