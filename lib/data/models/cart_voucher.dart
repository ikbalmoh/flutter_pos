import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/converters/generic.dart';

part 'cart_voucher.freezed.dart';
part 'cart_voucher.g.dart';

@freezed
class CartVoucher with _$CartVoucher {
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: true)
  const factory CartVoucher({
    required String id,
    required String code,
    @JsonKey(fromJson: Converters.dynamicToBool) bool? isPercent,
    @JsonKey(fromJson: Converters.dynamicToDouble) double? discountValue,
    required String voucherType,
    required double value,
  }) = _CartVoucher;

  factory CartVoucher.fromJson(Map<String, dynamic> json) =>
      _$CartVoucherFromJson(json);
}
