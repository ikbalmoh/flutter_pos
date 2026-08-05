import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_type.freezed.dart';

@freezed
abstract class PaymentType with _$PaymentType {
  const PaymentType._();

  const factory PaymentType({
    required int id,
    required String name,
    required Icon icon,
    bool? isExpanded,
  }) = _PaymentType;
}
