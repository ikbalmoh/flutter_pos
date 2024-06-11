// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outlet_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OutletConfig _$OutletConfigFromJson(Map<String, dynamic> json) => OutletConfig(
      locale: json['locale'] as String?,
      serverTime: json['server_time'] as String?,
      subscriptions: json['subscriptions'] == null
          ? null
          : Subscriptions.fromJson(
              json['subscriptions'] as Map<String, dynamic>),
      offlineTransaction: json['offline_transaction'] as bool?,
      syncBeforeCloseShift: json['sync_before_close_shift'] as bool?,
      maxOffline: (json['max_offline'] as num?)?.toInt(),
      saleWithPic: json['sale_with_pic'] as bool?,
      customerTransMandatory: json['customer_trans_mandatory'] as bool?,
      stockMinus: json['stock_minus'] as bool?,
      partialPayment: json['partial_payment'] as bool?,
      taxable: json['taxable'] as bool?,
      extraItem: json['extra_item'] as bool?,
      autoShift: json['auto_shift'] as bool?,
      decimalPlaces: (json['decimal_places'] as num?)?.toInt(),
      defaultOpenAmount: (json['default_open_amount'] as num?)?.toInt(),
      discountOverall: json['discount_overall'] as bool?,
      defaultPaper: (json['default_paper'] as num?)?.toInt(),
      attachmentShiftMandatory: json['attachment_shift_mandatory'] as bool?,
      generateSku: json['generate_sku'] as bool?,
      generateBarcode: json['generate_barcode'] as bool?,
      tax: json['tax'] == null
          ? null
          : Tax.fromJson(json['tax'] as Map<String, dynamic>),
      pinSettings: (json['pin_settings'] as List<dynamic>?)
          ?.map((e) => PinSetting.fromJson(e as Map<String, dynamic>))
          .toList(),
      userHasPin: (json['user_has_pin'] as List<dynamic>?)
          ?.map((e) => UserHasPin.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentMethods: (json['payment_methods'] as List<dynamic>)
          .map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
      nominalCash: (json['nominal_cash'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      refundReasons: (json['refund_reasons'] as List<dynamic>?)
          ?.map((e) => RefundReason.fromJson(e as Map<String, dynamic>))
          .toList(),
      addOns:
          (json['add_ons'] as List<dynamic>?)?.map((e) => e as String).toList(),
      attributeReceipts: json['attribute_receipts'] == null
          ? null
          : AttributeReceipts.fromJson(
              json['attribute_receipts'] as Map<String, dynamic>),
      akunBiaya: (json['akun_biaya'] as List<dynamic>?)
          ?.map((e) => Akun.fromJson(e as Map<String, dynamic>))
          .toList(),
      akunPendapatan: (json['akun_pendapatan'] as List<dynamic>?)
          ?.map((e) => Akun.fromJson(e as Map<String, dynamic>))
          .toList(),
      akunSetoran: (json['akun_setoran'] as List<dynamic>?)
          ?.map((e) => Akun.fromJson(e as Map<String, dynamic>))
          .toList(),
      listUser: (json['list_user'] as List<dynamic>?)
          ?.map((e) => ListUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      saldoAkunKas: (json['saldo_akun_kas'] as num?)?.toInt(),
      customMandatory: json['custom_mandatory'] == null
          ? null
          : CustomMandatory.fromJson(
              json['custom_mandatory'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OutletConfigToJson(OutletConfig instance) =>
    <String, dynamic>{
      'locale': instance.locale,
      'server_time': instance.serverTime,
      'subscriptions': instance.subscriptions,
      'offline_transaction': instance.offlineTransaction,
      'sync_before_close_shift': instance.syncBeforeCloseShift,
      'max_offline': instance.maxOffline,
      'sale_with_pic': instance.saleWithPic,
      'customer_trans_mandatory': instance.customerTransMandatory,
      'stock_minus': instance.stockMinus,
      'partial_payment': instance.partialPayment,
      'taxable': instance.taxable,
      'extra_item': instance.extraItem,
      'auto_shift': instance.autoShift,
      'decimal_places': instance.decimalPlaces,
      'default_open_amount': instance.defaultOpenAmount,
      'discount_overall': instance.discountOverall,
      'default_paper': instance.defaultPaper,
      'attachment_shift_mandatory': instance.attachmentShiftMandatory,
      'generate_sku': instance.generateSku,
      'generate_barcode': instance.generateBarcode,
      'tax': instance.tax,
      'pin_settings': instance.pinSettings,
      'user_has_pin': instance.userHasPin,
      'payment_methods': instance.paymentMethods,
      'nominal_cash': instance.nominalCash,
      'refund_reasons': instance.refundReasons,
      'add_ons': instance.addOns,
      'attribute_receipts': instance.attributeReceipts,
      'akun_biaya': instance.akunBiaya,
      'akun_pendapatan': instance.akunPendapatan,
      'akun_setoran': instance.akunSetoran,
      'list_user': instance.listUser,
      'saldo_akun_kas': instance.saldoAkunKas,
      'custom_mandatory': instance.customMandatory,
    };

Akun _$AkunFromJson(Map<String, dynamic> json) => Akun(
      idAkun: (json['id_akun'] as num).toInt(),
      kodeAkun: json['kode_akun'] as String,
      namaAkun: json['nama_akun'] as String,
      keterangan: json['keterangan'] as String?,
    );

Map<String, dynamic> _$AkunToJson(Akun instance) => <String, dynamic>{
      'id_akun': instance.idAkun,
      'kode_akun': instance.kodeAkun,
      'nama_akun': instance.namaAkun,
      'keterangan': instance.keterangan,
    };

AttributeReceipts _$AttributeReceiptsFromJson(Map<String, dynamic> json) =>
    AttributeReceipts(
      headers: json['headers'] as String?,
      footers: json['footers'] as String?,
      imagePath: json['image_path'] as String?,
      imageBase64: json['image_base64'] as String?,
    );

Map<String, dynamic> _$AttributeReceiptsToJson(AttributeReceipts instance) =>
    <String, dynamic>{
      'headers': instance.headers,
      'footers': instance.footers,
      'image_path': instance.imagePath,
      'image_base64': instance.imageBase64,
    };

CustomMandatory _$CustomMandatoryFromJson(Map<String, dynamic> json) =>
    CustomMandatory(
      customers: (json['customers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CustomMandatoryToJson(CustomMandatory instance) =>
    <String, dynamic>{
      'customers': instance.customers,
    };

ListUser _$ListUserFromJson(Map<String, dynamic> json) => ListUser(
      id: json['id'] as String,
      username: json['username'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      rolesName: (json['roles_name'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ListUserToJson(ListUser instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'phone': instance.phone,
      'roles_name': instance.rolesName,
    };

PinSetting _$PinSettingFromJson(Map<String, dynamic> json) => PinSetting(
      name: json['name'] as String,
      locked: json['locked'] as bool,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$PinSettingToJson(PinSetting instance) =>
    <String, dynamic>{
      'name': instance.name,
      'locked': instance.locked,
      'description': instance.description,
    };

RefundReason _$RefundReasonFromJson(Map<String, dynamic> json) => RefundReason(
      id: json['id'] as String,
      reason: json['reason'] as String,
      needNotes: json['need_notes'] as bool,
    );

Map<String, dynamic> _$RefundReasonToJson(RefundReason instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reason': instance.reason,
      'need_notes': instance.needNotes,
    };

Subscriptions _$SubscriptionsFromJson(Map<String, dynamic> json) =>
    Subscriptions(
      transaction: SubscriptionLimit.fromJson(
          json['transaction'] as Map<String, dynamic>),
      customer:
          SubscriptionLimit.fromJson(json['customer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SubscriptionsToJson(Subscriptions instance) =>
    <String, dynamic>{
      'transaction': instance.transaction,
      'customer': instance.customer,
    };

SubscriptionLimit _$SubscriptionLimitFromJson(Map<String, dynamic> json) =>
    SubscriptionLimit(
      max: (json['max'] as num).toInt(),
      current: (json['current'] as num).toInt(),
    );

Map<String, dynamic> _$SubscriptionLimitToJson(SubscriptionLimit instance) =>
    <String, dynamic>{
      'max': instance.max,
      'current': instance.current,
    };

Tax _$TaxFromJson(Map<String, dynamic> json) => Tax(
      taxName: json['tax_name'] as String,
      percentage: (json['percentage'] as num).toDouble(),
      isInclude: json['is_include'] as bool,
    );

Map<String, dynamic> _$TaxToJson(Tax instance) => <String, dynamic>{
      'tax_name': instance.taxName,
      'percentage': instance.percentage,
      'is_include': instance.isInclude,
    };

UserHasPin _$UserHasPinFromJson(Map<String, dynamic> json) => UserHasPin(
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      userPin: json['user_pin'] as String,
      rolesName: (json['roles_name'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserHasPinToJson(UserHasPin instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'user_name': instance.userName,
      'user_pin': instance.userPin,
      'roles_name': instance.rolesName,
    };
