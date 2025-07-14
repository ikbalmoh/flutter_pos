import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_type.freezed.dart';

@freezed
class PaymentType with _$PaymentType {
  const factory PaymentType({
    required int id,
    required String name,
    required Icon icon,
    bool? isExpanded,
  }) = _PaymentType;
}
