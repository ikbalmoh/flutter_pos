import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'token.g.dart';
part 'token.freezed.dart';

DateTime? _dateTimeFromJson(dynamic value) {
  if (value == null) return null;
  if (value is String) return DateTime.tryParse(value);
  return null;
}

String? _dateTimeToJson(DateTime? dt) => dt?.toIso8601String();

@freezed
abstract class Token with _$Token {
  const Token._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Token({
    required String accessToken,
    required String refreshToken,

    /// Seconds until expiry returned by the API (e.g. `expires_in: 3600`).
    /// May be null for tokens stored before this field was added.
    int? expiresIn,

    /// Absolute UTC DateTime computed at save time: `now + expiresIn`.
    /// Persisted as an ISO-8601 string so it survives app restarts.
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? expiresAt,
  }) = _Token;

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  /// Returns true if the token will expire within [thresholdSeconds] seconds.
  bool isExpiringSoon({int thresholdSeconds = 60}) {
    if (expiresAt == null) return false;
    final remaining = expiresAt!.difference(DateTime.now().toUtc()).inSeconds;
    return remaining <= thresholdSeconds;
  }

  @override
  String toString() => json.encode(toJson());
}
