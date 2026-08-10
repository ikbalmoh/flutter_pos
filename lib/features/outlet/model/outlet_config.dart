import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/features/outlet/model/refund_reason.dart';
import 'package:selleri/shared/model/custom_fields.dart';
import 'package:selleri/shared/utils/model_converter.dart';

import '../../pos/model/payment_method.dart';

part 'outlet_config.freezed.dart';
part 'outlet_config.g.dart';

@freezed
abstract class OutletConfig with _$OutletConfig {
  const OutletConfig._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory OutletConfig({
    String? locale,
    String? serverTime,
    Subscriptions? subscriptions,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) bool? offlineTransaction,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) bool? syncBeforeCloseShift,
    int? maxOffline,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) bool? saleWithPic,
    @JsonKey(fromJson: ModelConverter.dynamicToBool)
    bool? customerTransMandatory,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) bool? stockMinus,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) bool? partialPayment,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) bool? taxable,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) bool? extraItem,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) bool? autoShift,
    int? decimalPlaces,
    int? defaultOpenAmount,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) bool? discountOverall,
    int? defaultPaper,
    @JsonKey(fromJson: ModelConverter.dynamicToBool)
    bool? attachmentShiftMandatory,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) bool? generateSku,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) bool? generateBarcode,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) bool? printIncludePpn,
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
    String? merchantCode,
    String? merchantId,
    @JsonKey(name: 'custom_fields') CustomFields? customFields,
    @JsonKey(name: 'show_work_duration') @Default(false) bool? showWorkDuration,
    @JsonKey(name: 'show_cash_account_balance')
    @Default(false)
    bool? showCashAccountBalance,
  }) = _OutletConfig;

  factory OutletConfig.fromJson(Map<String, dynamic> json) =>
      _$OutletConfigFromJson(json);
}

@freezed
abstract class Akun with _$Akun {
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
abstract class AttributeReceipts with _$AttributeReceipts {
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
abstract class CustomMandatory with _$CustomMandatory {
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
abstract class PersonInCharge with _$PersonInCharge {
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
abstract class PinSetting with _$PinSetting {
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

@freezed
abstract class Subscriptions with _$Subscriptions {
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
abstract class SubscriptionLimit with _$SubscriptionLimit {
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
abstract class Tax with _$Tax {
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
abstract class UserHasPin with _$UserHasPin {
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
