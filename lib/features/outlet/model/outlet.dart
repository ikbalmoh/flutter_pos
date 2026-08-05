import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/shared/utils/model_converter.dart';

part 'outlet.freezed.dart';
part 'outlet.g.dart';

@freezed
abstract class Outlet with _$Outlet {
  const Outlet._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  factory Outlet({
    required String idOutlet,
    required String outletName,
    required String outletCode,
    @JsonKey(fromJson: ModelConverter.dynamicToString) String? outletPhone,
    @JsonKey(fromJson: ModelConverter.dynamicToString) String? outletAddress,
    @JsonKey(fromJson: ModelConverter.dynamicToInt) int? idCity,
    @JsonKey(fromJson: ModelConverter.dynamicToString) String? cityName,
    @JsonKey(fromJson: ModelConverter.dynamicToInt) int? idRegion,
    @JsonKey(fromJson: ModelConverter.dynamicToString) String? regionName,
    @JsonKey(fromJson: ModelConverter.dynamicToString) String? zipCode,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) bool? isActive,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) bool? stockMinus,
    @JsonKey(fromJson: ModelConverter.dynamicToInt) int? akunKasKecilId,
    @JsonKey(fromJson: ModelConverter.dynamicToInt) int? akunKasBesarId,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) bool? isOnlineStore,
    @JsonKey(fromJson: ModelConverter.dynamicToString) String? integrationWith,
    @JsonKey(fromJson: ModelConverter.dynamicToString) String? morphName,
    @JsonKey(fromJson: ModelConverter.dynamicToString) String? akunKasKecil,
    @JsonKey(fromJson: ModelConverter.dynamicToString) String? akunKasBesar,
  }) = _Outlet;

  factory Outlet.fromJson(Map<String, dynamic> json) => _$OutletFromJson(json);

  @override
  String toString() {
    final jsonOutlet = toJson();
    return json.encode(jsonOutlet);
  }
}
