import 'dart:convert';

class Company {
  String idCompany;
  String companyName;
  String countryCode;
  String? countryName;
  int regionCode;
  String? regionName;
  int cityCode;
  String? cityName;
  String locale;
  bool? statusConfigured;
  String? companyEmail;

  Company({
    required this.idCompany,
    required this.companyName,
    required this.companyEmail,
    required this.countryCode,
    this.countryName,
    required this.regionCode,
    this.regionName,
    required this.cityCode,
    this.cityName,
    required this.locale,
    this.statusConfigured,
  });

  Company.fromJson(Map<dynamic, dynamic> json)
      : idCompany = json['id_company'],
        companyName = json['company_name'],
        companyEmail = json['company_email'],
        countryCode = json['country_code'],
        countryName = json['country_name'],
        regionCode = json['region_code'],
        regionName = json['region_name'],
        cityCode = json['city_code'],
        cityName = json['city_name'],
        locale = json['locale'],
        statusConfigured = json['status_configured'] ?? false;

  Map<String, dynamic> toJson() => {
        'id_company': idCompany,
        'company_name': companyName,
        'company_email': companyEmail,
        'country_code': countryCode,
        'country_name': countryName,
        'region_code': regionCode,
        'region_name': regionName,
        'city_code': cityCode,
        'city_name': cityName,
        'locale': locale,
        'status_configured': statusConfigured,
      };

  @override
  String toString() {
    final jsonToken = toJson();
    return json.encode(jsonToken);
  }
}
