
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_mandatory_config.freezed.dart';
part 'custom_mandatory_config.g.dart';

@freezed
abstract class CustomMandatoryConfig with _$CustomMandatoryConfig {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CustomMandatoryConfig({
    @Default({}) Map<String, bool> customers,
  }) = _CustomMandatoryConfig;

  factory CustomMandatoryConfig.fromJson(Map<String, dynamic> json) =>
      _$CustomMandatoryConfigFromJson(json);

  @override
  String toString() {
    final jsonData = toJson();
    return json.encode(jsonData);
  }
}