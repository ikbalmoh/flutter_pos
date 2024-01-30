import 'dart:convert';

class User {
  UserAccount user;
  Map<dynamic, dynamic> accountConfig;
  List<String> permissions;

  User({
    required this.user,
    required this.accountConfig,
    required this.permissions,
  });

  User.fromJson(Map<dynamic, dynamic> json)
      : user = UserAccount.fromJson(json['user']),
        accountConfig = json['account_config'],
        permissions = List<String>.from(json['permissions'].map((p) => p));

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'account_config': accountConfig,
        'permissions': permissions
      };

  @override
  String toString() {
    return "{user: $user, account_config: $accountConfig, permissions: $permissions}";
  }
}

class UserAccount {
  String idUser;
  String name;
  String username;
  String email;
  List<String> roles;
  Company company;
  List<Outlet> outlet;

  UserAccount({
    required this.idUser,
    required this.name,
    required this.username,
    required this.email,
    required this.roles,
    required this.company,
    required this.outlet,
  });

  UserAccount.fromJson(Map<dynamic, dynamic> json)
      : idUser = json['id_user'],
        name = json['name'],
        username = json['username'],
        email = json['email'],
        roles = List<String>.from(json['roles']?.map((x) => x)),
        company = Company.fromJson(json['company']),
        outlet =
            List<Outlet>.from(json['outlet'].map((x) => Outlet.fromJson(x)));

  Map<String, dynamic> toJson() => {
        'id_user': idUser,
        'name': name,
        'username': username,
        'email': email,
        'roles': jsonEncode(roles),
        'company': company.toJson(),
        'outlet': outlet.map((o) => o.toJson()).toList()
      };

  @override
  String toString() {
    return "{id_user: $idUser, name: $name, email: $email, roles: $roles, company: $company, outlet: $outlet}";
  }
}

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

  Company({
    required this.idCompany,
    required this.companyName,
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
        'country_code': countryCode,
        'country_name': countryName,
        'region_code': regionCode,
        'region_name': regionName,
        'city_code': cityCode,
        'city_name': cityName,
        'locale': locale,
        'status_configured': statusConfigured,
      };
}

class Outlet {
  String idOutlet;
  String outletName;
  String outletCode;
  String outletPhone;
  String outletAddress;

  Outlet({
    required this.idOutlet,
    required this.outletName,
    required this.outletCode,
    required this.outletPhone,
    required this.outletAddress,
  });

  Outlet.fromJson(Map<dynamic, dynamic> json)
      : idOutlet = json['id_outlet'],
        outletName = json['outlet_name'],
        outletCode = json['outlet_code'],
        outletPhone = json['outlet_phoe'] ?? '',
        outletAddress = json['outlet_address'];

  Map<dynamic, String> toJson() => {
        'id_outlet': idOutlet,
        'outlet_name': outletName,
        'outlet_code': outletCode,
        'outlet_phone': outletPhone,
        'outlet_address': outletAddress,
      };
}
