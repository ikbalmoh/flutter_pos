import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_field.freezed.dart';
part 'custom_field.g.dart';

@freezed
class CustomField with _$CustomField {
  const factory CustomField({
    required String id,
    required String label,
    required String field,
    @JsonKey(name: 'type_data') required TypeData typeData,
    String? module,
    @JsonKey(name: 'input_type')
    FieldType? inputType,
    @JsonKey(name: 'is_required') @Default(false) bool isRequired,
    @Default(0) int position,
  }) = _CustomField;

  factory CustomField.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldFromJson(json);
}

enum TypeData { string, numeric, boolean }

enum FieldType {
  @JsonValue("TextBox")
  textBox,
  @JsonValue("TextArea")
  textArea,
  @JsonValue("Date")
  date,
  @JsonValue("RadioButton")
  radioButton;
}
