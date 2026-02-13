import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../outlet/model/outlet.dart';
import 'company.dart';

part 'user.g.dart';
part 'user.freezed.dart';

@freezed
class User with _$User {
  const User._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  factory User({
    required UserAccount user,
    required Map<dynamic, dynamic> accountConfig,
    required List<String> permissions,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  String toString() {
    final jsonToken = toJson();
    return json.encode(jsonToken);
  }
}

@freezed
class UserAccount with _$UserAccount {
  const UserAccount._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  factory UserAccount({
    required String idUser,
    required String name,
    required String username,
    required String email,
    required List<String> roles,
    required Company company,
    List<Outlet>? outlet,
  }) = _UserAccount;

  factory UserAccount.fromJson(Map<String, dynamic> json) =>
      _$UserAccountFromJson(json);

  @override
  String toString() {
    final jsonToken = toJson();
    return json.encode(jsonToken);
  }
}
