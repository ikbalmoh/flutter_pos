import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/features/cart/model/cart_voucher.dart';
import 'package:selleri/shared/utils/model_converter.dart';

part 'voucher.freezed.dart';
part 'voucher.g.dart';

@freezed
abstract class Voucher with _$Voucher {
  const Voucher._();

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
    @JsonKey(fromJson: ModelConverter.dynamicToBool) required bool isPercent,
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

  CartVoucher toCartVoucher({required double value}) {
    return CartVoucher(
      id: id,
      code: code,
      isPercent: isPercent,
      discountValue: discountValue,
      voucherType: voucherType,
      value: value,
    );
  }
}
