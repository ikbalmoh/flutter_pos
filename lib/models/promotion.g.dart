// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Promotion _$PromotionFromJson(Map<String, dynamic> json) => Promotion(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as int,
      requirementQuantity: json['requirement_quantity'] as int?,
      requirementMinimumOrder: json['requirement_minimum_order'] as int?,
      rewardType: json['reward_type'] as int?,
      rewardProductType: json['reward_product_type'] as int?,
      rewardProductId: json['reward_product_id'] as String?,
      rewardVariantId: json['reward_variant_id'] as int?,
      rewardQty: json['reward_qty'] as int?,
      discountType: json['discount_type'] as int?,
      rewardNominal: json['reward_nominal'] as int?,
      rewardMaximumAmount: json['reward_maximum_amount'] as int?,
      status: Converters.dynamicToBool(json['status']),
      allOutlet: Converters.dynamicToBool(json['all_outlet']),
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      allTime: Converters.dynamicToBool(json['all_time']),
      availableDays: json['available_days'] as String?,
      hourly: json['hourly'] as bool,
      assignCustomer: Converters.dynamicToBool(json['assign_customer']),
      policy: json['policy'] as bool,
      needCode: json['need_code'] as bool,
      promoCode: json['promo_code'] as String?,
      kelipatan: json['kelipatan'] as bool,
      priority: json['priority'] as int?,
      requirementProductType: json['requirement_product_type'] as int?,
      requirementProductId: (json['requirement_product_id'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      requirementVariantId: (json['requirement_variant_id'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      typeName: json['type_name'] as String?,
      days: (json['days'] as List<dynamic>?)?.map((e) => e as String).toList(),
      description: json['description'] as String?,
      assignCustomerName: json['assign_customer_name'] as String?,
      numberOfDays: (json['number_of_days'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      rewardProductName: json['reward_product_name'] as String?,
      rewardItemPrice: json['reward_item_price'] as int?,
      times: json['times'] as List<dynamic>?,
      assignGroups: (json['assign_groups'] as List<dynamic>?)
          ?.map((e) => AssignGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemRequirements: (json['item_requirements'] as List<dynamic>?)
          ?.map((e) => ItemRequirement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PromotionToJson(Promotion instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'requirement_quantity': instance.requirementQuantity,
      'requirement_minimum_order': instance.requirementMinimumOrder,
      'reward_type': instance.rewardType,
      'reward_product_type': instance.rewardProductType,
      'reward_product_id': instance.rewardProductId,
      'reward_variant_id': instance.rewardVariantId,
      'reward_qty': instance.rewardQty,
      'discount_type': instance.discountType,
      'reward_nominal': instance.rewardNominal,
      'reward_maximum_amount': instance.rewardMaximumAmount,
      'status': instance.status,
      'all_outlet': instance.allOutlet,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'all_time': instance.allTime,
      'available_days': instance.availableDays,
      'hourly': instance.hourly,
      'assign_customer': instance.assignCustomer,
      'policy': instance.policy,
      'need_code': instance.needCode,
      'promo_code': instance.promoCode,
      'kelipatan': instance.kelipatan,
      'priority': instance.priority,
      'requirement_product_type': instance.requirementProductType,
      'requirement_product_id': instance.requirementProductId,
      'requirement_variant_id': instance.requirementVariantId,
      'type_name': instance.typeName,
      'days': instance.days,
      'description': instance.description,
      'assign_customer_name': instance.assignCustomerName,
      'number_of_days': instance.numberOfDays,
      'reward_product_name': instance.rewardProductName,
      'reward_item_price': instance.rewardItemPrice,
      'times': instance.times,
      'assign_groups': instance.assignGroups,
      'item_requirements': instance.itemRequirements,
    };

AssignGroup _$AssignGroupFromJson(Map<String, dynamic> json) => AssignGroup(
      id: json['id'] as String,
      promotionId: json['promotion_id'] as String,
      groupId: json['group_id'] as int,
      groupName: json['group_name'] as String,
    );

Map<String, dynamic> _$AssignGroupToJson(AssignGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'promotion_id': instance.promotionId,
      'group_id': instance.groupId,
      'group_name': instance.groupName,
    };

ItemRequirement _$ItemRequirementFromJson(Map<String, dynamic> json) =>
    ItemRequirement(
      id: json['id'] as String,
      promotionId: json['promotion_id'] as String,
      requirementProductType: json['requirement_product_type'] as int,
      requirementProductId: json['requirement_product_id'] as String?,
      requirementVariantId: json['requirement_variant_id'] as int?,
      requirementProductName: json['requirement_product_name'] as String?,
    );

Map<String, dynamic> _$ItemRequirementToJson(ItemRequirement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'promotion_id': instance.promotionId,
      'requirement_product_type': instance.requirementProductType,
      'requirement_product_id': instance.requirementProductId,
      'requirement_variant_id': instance.requirementVariantId,
      'requirement_product_name': instance.requirementProductName,
    };
