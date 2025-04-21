import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/converters/generic.dart';

part 'voucher.freezed.dart';
part 'voucher.g.dart';

@freezed
class Voucher with _$Voucher {
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: true)
  const factory Voucher({
    required String id,
    required String promoId,
    required String code,
    required int disposable,
    required int isUsed,
    required DateTime start,
    required DateTime end,
    required String voucherType,
    @JsonKey(fromJson: Converters.dynamicToBool) required bool isPercent,
    required double discountValue,
    required String description,
    required bool policy,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool allOutlet,
    required String promoName,
  }) = _Voucher;

  factory Voucher.fromJson(Map<String, dynamic> json) =>
      _$VoucherFromJson(json);
}
