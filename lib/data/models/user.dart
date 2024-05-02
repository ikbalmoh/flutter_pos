import 'dart:convert';
import 'outlet.dart';
import 'company.dart';

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
  List<Outlet>? outlet;

  UserAccount({
    required this.idUser,
    required this.name,
    required this.username,
    required this.email,
    required this.roles,
    required this.company,
    this.outlet,
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
        'outlet': outlet?.map((o) => o.toJson()).toList()
      };

  @override
  String toString() {
    return "{id_user: $idUser, name: $name, email: $email, roles: $roles, company: $company, outlet: $outlet}";
  }
}
