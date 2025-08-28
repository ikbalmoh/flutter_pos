import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'outlet.freezed.dart';
part 'outlet.g.dart';

@freezed
class Outlet with _$Outlet {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory Outlet({
    required String idOutlet,
    required String outletName,
    required String outletCode,
    String? outletPhone,
    String? outletAddress,
    int? idCity,
    String? cityName,
    int? idRegion,
    String? regionName,
    String? zipCode,
    bool? isActive,
    bool? stockMinus,
    int? akunKasKecilId,
    int? akunKasBesarId,
    bool? isOnlineStore,
    String? integrationWith,
    String? morphName,
    String? akunKasKecil,
    String? akunKasBesar,
  }) = _Outlet;

  factory Outlet.fromJson(Map<String, dynamic> json) => _$OutletFromJson(json);

  @override
  String toString() {
    final jsonToken = toJson();
    return json.encode(jsonToken);
  }
}
