
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_mandatory.freezed.dart';
part 'custom_mandatory.g.dart';

@freezed
abstract class CustomMandatory with _$CustomMandatory {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CustomMandatory({
    @Default([]) List<String> customers,
  }) = _CustomMandatory;

  factory CustomMandatory.fromJson(Map<String, dynamic> json) =>
      _$CustomMandatoryFromJson(json);

  @override
  String toString() {
    final jsonData = toJson();
    return json.encode(jsonData);
  }
}