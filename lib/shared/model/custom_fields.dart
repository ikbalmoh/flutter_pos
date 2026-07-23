import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/shared/model/custom_field.dart';

part 'custom_fields.freezed.dart';
part 'custom_fields.g.dart';

@freezed
class CustomFields with _$CustomFields {
  const factory CustomFields({
    @JsonKey(name: 'modules', fromJson: _modulesFromJson)
    required CustomFieldsModules modules,
  }) = _CustomFields;

  factory CustomFields.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldsFromJson(json);
}

@freezed
class CustomFieldsModules with _$CustomFieldsModules {
  const factory CustomFieldsModules({
    @JsonKey(name: 'Transaction') @Default([]) List<CustomField>? transaction,
  }) = _CustomFieldsModules;

  factory CustomFieldsModules.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldsModulesFromJson(json);
}

CustomFieldsModules _modulesFromJson(dynamic value) {
  if (value is Map<String, dynamic>) {
    return CustomFieldsModules.fromJson(value);
  }
  return const CustomFieldsModules();
}
