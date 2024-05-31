// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartImpl _$$CartImplFromJson(Map<String, dynamic> json) => _$CartImpl(
      transactionDate: DateTime.parse(json['transaction_date'] as String),
      transactionNo: json['transaction_no'] as String?,
      idOutlet: json['id_outlet'] as String?,
      outletName: json['outlet_name'] as String?,
      subtotal: (json['subtotal'] as num).toDouble(),
      discIsPercent: json['disc_is_percent'] as bool,
      discOverall: (json['disc_overall'] as num).toDouble(),
      discOverallTotal: (json['disc_overall_total'] as num).toDouble(),
      discPromotionsTotal: (json['disc_promotions_total'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      ppnIsInclude: json['ppn_is_include'] as bool?,
      ppn: (json['ppn'] as num?)?.toDouble(),
      taxName: json['tax_name'] as String?,
      ppnTotal: (json['ppn_total'] as num?)?.toDouble(),
      grandTotal: (json['grand_total'] as num).toDouble(),
      totalPayment: (json['total_payment'] as num).toDouble(),
      change: (json['change'] as num?)?.toDouble(),
      idCustomer: json['id_customer'] as String?,
      customerName: json['customer_name'] as String?,
      notes: json['notes'] as String?,
      personInCharge: json['person_in_charge'] as String?,
      holdAt: json['hold_at'] == null
          ? null
          : DateTime.parse(json['hold_at'] as String),
      createdBy: json['created_by'] as String?,
      createdName: json['created_name'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => ItemCart.fromJson(e as Map<String, dynamic>))
          .toList(),
      payments: (json['payments'] as List<dynamic>)
          .map((e) => CartPayment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CartImplToJson(_$CartImpl instance) =>
    <String, dynamic>{
      'transaction_date': instance.transactionDate.toIso8601String(),
      'transaction_no': instance.transactionNo,
      'id_outlet': instance.idOutlet,
      'outlet_name': instance.outletName,
      'subtotal': instance.subtotal,
      'disc_is_percent': instance.discIsPercent,
      'disc_overall': instance.discOverall,
      'disc_overall_total': instance.discOverallTotal,
      'disc_promotions_total': instance.discPromotionsTotal,
      'total': instance.total,
      'ppn_is_include': instance.ppnIsInclude,
      'ppn': instance.ppn,
      'tax_name': instance.taxName,
      'ppn_total': instance.ppnTotal,
      'grand_total': instance.grandTotal,
      'total_payment': instance.totalPayment,
      'change': instance.change,
      'id_customer': instance.idCustomer,
      'customer_name': instance.customerName,
      'notes': instance.notes,
      'person_in_charge': instance.personInCharge,
      'hold_at': instance.holdAt?.toIso8601String(),
      'created_by': instance.createdBy,
      'created_name': instance.createdName,
      'items': instance.items,
      'payments': instance.payments,
    };
