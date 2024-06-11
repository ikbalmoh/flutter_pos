import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'payment_method.dart';

part 'outlet_config.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class OutletConfig {
  String? locale;
  String? serverTime;
  Subscriptions? subscriptions;
  bool? offlineTransaction;
  bool? syncBeforeCloseShift;
  int? maxOffline;
  bool? saleWithPic;
  bool? customerTransMandatory;
  bool? stockMinus;
  bool? partialPayment;
  bool? taxable;
  bool? extraItem;
  bool? autoShift;
  int? decimalPlaces;
  int? defaultOpenAmount;
  bool? discountOverall;
  int? defaultPaper;
  bool? attachmentShiftMandatory;
  bool? generateSku;
  bool? generateBarcode;
  Tax? tax;
  List<PinSetting>? pinSettings;
  List<UserHasPin>? userHasPin;
  List<PaymentMethod> paymentMethods;
  List<int>? nominalCash;
  List<RefundReason>? refundReasons;
  List<String>? addOns;
  AttributeReceipts? attributeReceipts;
  List<Akun>? akunBiaya;
  List<Akun>? akunPendapatan;
  List<Akun>? akunSetoran;
  List<ListUser>? listUser;
  int? saldoAkunKas;
  CustomMandatory? customMandatory;

  OutletConfig({
    this.locale,
    this.serverTime,
    this.subscriptions,
    this.offlineTransaction,
    this.syncBeforeCloseShift,
    this.maxOffline,
    this.saleWithPic,
    this.customerTransMandatory,
    this.stockMinus,
    this.partialPayment,
    this.taxable,
    this.extraItem,
    this.autoShift,
    this.decimalPlaces,
    this.defaultOpenAmount,
    this.discountOverall,
    this.defaultPaper,
    this.attachmentShiftMandatory,
    this.generateSku,
    this.generateBarcode,
    this.tax,
    this.pinSettings,
    this.userHasPin,
    required this.paymentMethods,
    this.nominalCash,
    this.refundReasons,
    this.addOns,
    this.attributeReceipts,
    this.akunBiaya,
    this.akunPendapatan,
    this.akunSetoran,
    this.listUser,
    this.saldoAkunKas,
    this.customMandatory,
  });

  factory OutletConfig.fromJson(Map<String, dynamic> json) =>
      _$OutletConfigFromJson(json);

  Map<String, dynamic> toJson() => _$OutletConfigToJson(this);

  @override
  String toString() {
    final jsonToken = toJson();
    return json.encode(jsonToken);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Akun {
  int idAkun;
  String kodeAkun;
  String namaAkun;
  String? keterangan;

  Akun({
    required this.idAkun,
    required this.kodeAkun,
    required this.namaAkun,
    this.keterangan,
  });

  factory Akun.fromJson(Map<String, dynamic> json) => _$AkunFromJson(json);

  Map<String, dynamic> toJson() => _$AkunToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AttributeReceipts {
  String? headers;
  String? footers;
  String? imagePath;
  String? imageBase64;

  AttributeReceipts({
    this.headers,
    this.footers,
    this.imagePath,
    this.imageBase64,
  });

  factory AttributeReceipts.fromJson(Map<String, dynamic> json) =>
      _$AttributeReceiptsFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeReceiptsToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CustomMandatory {
  List<String>? customers;

  CustomMandatory({
    this.customers,
  });

  factory CustomMandatory.fromJson(Map<String, dynamic> json) =>
      _$CustomMandatoryFromJson(json);

  Map<String, dynamic> toJson() => _$CustomMandatoryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ListUser {
  String id;
  String username;
  String name;
  String? phone;
  List<String>? rolesName;

  ListUser({
    required this.id,
    required this.username,
    required this.name,
    this.phone,
    this.rolesName,
  });

  factory ListUser.fromJson(Map<String, dynamic> json) =>
      _$ListUserFromJson(json);

  Map<String, dynamic> toJson() => _$ListUserToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PinSetting {
  String name;
  bool locked;
  String? description;

  PinSetting({
    required this.name,
    required this.locked,
    this.description,
  });

  factory PinSetting.fromJson(Map<String, dynamic> json) =>
      _$PinSettingFromJson(json);

  Map<String, dynamic> toJson() => _$PinSettingToJson(this);

  @override
  String toString() {
    return toJson().toString();
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
    return toJson().toString();
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Subscriptions {
  SubscriptionLimit transaction;
  SubscriptionLimit customer;

  Subscriptions({
    required this.transaction,
    required this.customer,
  });

  factory Subscriptions.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionsFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionsToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SubscriptionLimit {
  int max;
  int current;

  SubscriptionLimit({
    required this.max,
    required this.current,
  });

  factory SubscriptionLimit.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionLimitFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionLimitToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Tax {
  String taxName;
  double percentage;
  bool isInclude;

  Tax({
    required this.taxName,
    required this.percentage,
    required this.isInclude,
  });

  factory Tax.fromJson(Map<String, dynamic> json) => _$TaxFromJson(json);

  Map<String, dynamic> toJson() => _$TaxToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UserHasPin {
  String userId;
  String userName;
  String userPin;
  List<String>? rolesName;

  UserHasPin({
    required this.userId,
    required this.userName,
    required this.userPin,
    this.rolesName,
  });

  factory UserHasPin.fromJson(Map<String, dynamic> json) =>
      _$UserHasPinFromJson(json);

  Map<String, dynamic> toJson() => _$UserHasPinToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
