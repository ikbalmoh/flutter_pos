import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'company.freezed.dart';
part 'company.g.dart';

@freezed
class Company with _$Company {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory Company({
    required String idCompany,
    required String companyName,
    required String companyEmail,
    required String countryCode,
    String? countryName,
    required int regionCode,
    String? regionName,
    required int cityCode,
    String? cityName,
    required String locale,
    bool? statusConfigured,
  }) = _Company;

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);

  @override
  String toString() {
    final jsonToken = toJson();
    return json.encode(jsonToken);
  }
}
