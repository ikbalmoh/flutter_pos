import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/shared/utils/model_converter.dart';

part 'cart_voucher.freezed.dart';
part 'cart_voucher.g.dart';

@freezed
class CartVoucher with _$CartVoucher {
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: true)
  const factory CartVoucher({
    required String id,
    required String code,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) bool? isPercent,
    @JsonKey(fromJson: ModelConverter.dynamicToDouble) double? discountValue,
    required String voucherType,
    required double value,
  }) = _CartVoucher;

  factory CartVoucher.fromJson(Map<String, dynamic> json) =>
      _$CartVoucherFromJson(json);
}
