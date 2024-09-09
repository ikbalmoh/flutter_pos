import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'payment_method.dart';

part 'outlet_config.freezed.dart';
part 'outlet_config.g.dart';

@freezed
class OutletConfig with _$OutletConfig {
  const OutletConfig._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory OutletConfig({
    String? locale,
    String? serverTime,
    Subscriptions? subscriptions,
    bool? offlineTransaction,
    bool? syncBeforeCloseShift,
    int? maxOffline,
    bool? saleWithPic,
    bool? customerTransMandatory,
    bool? stockMinus,
    bool? partialPayment,
    bool? taxable,
    bool? extraItem,
    bool? autoShift,
    int? decimalPlaces,
    int? defaultOpenAmount,
    bool? discountOverall,
    int? defaultPaper,
    bool? attachmentShiftMandatory,
    bool? generateSku,
    bool? generateBarcode,
    Tax? tax,
    List<PinSetting>? pinSettings,
    List<UserHasPin>? userHasPin,
    List<PaymentMethod>? paymentMethods,
    List<int>? nominalCash,
    List<RefundReason>? refundReasons,
    List<String>? addOns,
    AttributeReceipts? attributeReceipts,
    List<Akun>? akunBiaya,
    List<Akun>? akunPendapatan,
    List<Akun>? akunSetoran,
    List<PersonInCharge>? listUser,
    int? saldoAkunKas,
    CustomMandatory? customMandatory,
  }) = _OutletConfig;

  factory OutletConfig.fromJson(Map<String, dynamic> json) =>
      _$OutletConfigFromJson(json);
}

@freezed
class Akun with _$Akun {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Akun({
    required int idAkun,
    required String kodeAkun,
    required String namaAkun,
    String? keterangan,
  }) = _Akun;

  factory Akun.fromJson(Map<String, dynamic> json) => _$AkunFromJson(json);

  @override
  String toString() {
    final jsonData = toJson();
    return json.encode(jsonData);
  }
}

@freezed
class AttributeReceipts with _$AttributeReceipts {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AttributeReceipts({
    String? headers,
    String? footers,
    String? imagePath,
    String? imageBase64,
  }) = _AttributeReceipts;

  factory AttributeReceipts.fromJson(Map<String, dynamic> json) =>
      _$AttributeReceiptsFromJson(json);

  @override
  String toString() {
    final jsonData = toJson();
    return json.encode(jsonData);
  }
}

@freezed
class CustomMandatory with _$CustomMandatory {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CustomMandatory({
    List<String>? customers,
  }) = _CustomMandatory;

  factory CustomMandatory.fromJson(Map<String, dynamic> json) =>
      _$CustomMandatoryFromJson(json);

  @override
  String toString() {
    final jsonData = toJson();
    return json.encode(jsonData);
  }
}

@freezed
class PersonInCharge with _$PersonInCharge {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PersonInCharge({
    required String id,
    required String username,
    required String name,
    String? phone,
    List<String>? rolesName,
  }) = _PersonInCharge;

  factory PersonInCharge.fromJson(Map<String, dynamic> json) =>
      _$PersonInChargeFromJson(json);

  @override
  String toString() {
    final jsonData = toJson();
    return json.encode(jsonData);
  }
}

@freezed
class PinSetting with _$PinSetting {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PinSetting({
    required String name,
    required bool locked,
    String? description,
  }) = _PinSetting;

  factory PinSetting.fromJson(Map<String, dynamic> json) =>
      _$PinSettingFromJson(json);

  @override
  String toString() {
    final jsonData = toJson();
    return json.encode(jsonData);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RefundReason {
  String id;
  String reason;
  bool needNotes;

  RefundReason({
    required this.id,
    required this.reason,
    required this.needNotes,
  });

  factory RefundReason.fromJson(Map<String, dynamic> json) =>
      _$RefundReasonFromJson(json);

  Map<String, dynamic> toJson() => _$RefundReasonToJson(this);

  @override
  String toString() {
    final jsonData = toJson();
    return json.encode(jsonData);
  }
}

@freezed
class Subscriptions with _$Subscriptions {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Subscriptions({
    required SubscriptionLimit transaction,
    required SubscriptionLimit customer,
  }) = _Subscriptions;

  factory Subscriptions.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionsFromJson(json);

  @override
  String toString() {
    final jsonData = toJson();
    return json.encode(jsonData);
  }
}

@freezed
class SubscriptionLimit with _$SubscriptionLimit {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SubscriptionLimit({
    required int max,
    required int current,
  }) = _SubscriptionLimit;

  factory SubscriptionLimit.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionLimitFromJson(json);

  @override
  String toString() {
    final jsonData = toJson();
    return json.encode(jsonData);
  }
}

@freezed
class Tax with _$Tax {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Tax({
    required String taxName,
    required double percentage,
    required bool isInclude,
  }) = _Tax;

  factory Tax.fromJson(Map<String, dynamic> json) => _$TaxFromJson(json);

  @override
  String toString() {
    final jsonData = toJson();
    return json.encode(jsonData);
  }
}

@freezed
class UserHasPin with _$UserHasPin {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserHasPin({
    required String userId,
    required String userName,
    required String userPin,
    List<String>? rolesName,
  }) = _UserHasPin;

  factory UserHasPin.fromJson(Map<String, dynamic> json) =>
      _$UserHasPinFromJson(json);

  @override
  String toString() {
    final jsonData = toJson();
    return json.encode(jsonData);
  }
}
