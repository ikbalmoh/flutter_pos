import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'refund_reason.freezed.dart';
part 'refund_reason.g.dart';

@freezed
abstract class RefundReason with _$RefundReason {
  const RefundReason._();

  factory RefundReason({
    required String id,
    required String reason,
    @Default(false) bool needNotes,
  }) = _RefundReason;

  factory RefundReason.fromJson(Map<String, dynamic> json) =>
      _$RefundReasonFromJson(json);

  factory RefundReason.fromOption(Map<String, dynamic> option) {
    return RefundReason(
      id: option['id'],
      reason: option['text'],
      needNotes: option['need_notes'] ?? false,
    );
  }

  @override
  String toString() {
    final jsonData = toJson();
    return json.encode(jsonData);
  }
}
