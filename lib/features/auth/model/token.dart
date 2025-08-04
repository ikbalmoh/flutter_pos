import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'token.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Token {
  final String accessToken;
  final String refreshToken;

  Token({required this.accessToken, required this.refreshToken});

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  Map<String, dynamic> toJson() => _$TokenToJson(this);

  @override
  String toString() {
    final jsonToken = toJson();
    return json.encode(jsonToken);
  }
}
