import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/shared/utils/model_converter.dart';

part 'custom_field.freezed.dart';
part 'custom_field.g.dart';

@freezed
abstract class CustomField with _$CustomField {
  const CustomField._();

  const factory CustomField({
    required String id,
    required String label,
    required String field,
    @JsonKey(name: 'type_data') required TypeData typeData,
    @JsonKey(
      name: 'module',
      fromJson: ModelConverter.dynamicToString,
      toJson: ModelConverter.dynamicToString,
    )
    String? module,
    @JsonKey(name: 'input_type') FieldType? inputType,
    @JsonKey(
      name: 'is_required',
      fromJson: ModelConverter.dynamicToBool,
      toJson: ModelConverter.dynamicToBool,
    )
    @Default(false)
    bool isRequired,
    @JsonKey(
      name: 'position',
      fromJson: ModelConverter.dynamicToInt,
      toJson: ModelConverter.dynamicToInt,
    )
    @Default(0)
    int position,
    @JsonKey(
      name: 'value',
      fromJson: ModelConverter.dynamicToString,
      toJson: ModelConverter.dynamicToString,
    )
    String? value,
  }) = _CustomField;

  factory CustomField.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldFromJson(json);
}

enum TypeData {
  @JsonValue('string')
  string,
  @JsonValue('numeric')
  numeric,
  @JsonValue('boolean')
  boolean;

  String toJson() => name;

  @override
  String toString() => name;
}

enum FieldType {
  @JsonValue("TextBox")
  textBox,
  @JsonValue("TextArea")
  textArea,
  @JsonValue("Date")
  date,
  @JsonValue("RadioButton")
  radioButton;

  String toJson() => _$FieldTypeEnumMap[this] ?? name;

  @override
  String toString() => _$FieldTypeEnumMap[this] ?? name;
}

extension FieldInputType on FieldType {
  TextInputType get inputType {
    return switch (this) {
      FieldType.textBox => TextInputType.text,
      FieldType.textArea => TextInputType.multiline,
      FieldType.date => TextInputType.datetime,
      FieldType.radioButton => TextInputType.text,
    };
  }

  TextInputAction get textInputAction {
    return switch (this) {
      FieldType.textBox => TextInputAction.next,
      FieldType.textArea => TextInputAction.newline,
      FieldType.date => TextInputAction.done,
      FieldType.radioButton => TextInputAction.done,
    };
  }

  TextCapitalization get textCapitalization {
    return switch (this) {
      FieldType.textBox => TextCapitalization.sentences,
      FieldType.textArea => TextCapitalization.sentences,
      FieldType.date => TextCapitalization.none,
      FieldType.radioButton => TextCapitalization.none,
    };
  }
}
