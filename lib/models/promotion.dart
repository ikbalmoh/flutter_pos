import 'package:json_annotation/json_annotation.dart';
import 'package:selleri/models/converters/generic.dart';

part 'promotion.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Promotion {
  String id;
  String name;
  int type;
  int? requirementQuantity;
  int? requirementMinimumOrder;
  int? rewardType;
  int? rewardProductType;
  String? rewardProductId;
  int? rewardVariantId;
  int? rewardQty;
  int? discountType;
  int? rewardNominal;
  int? rewardMaximumAmount;
  
  @JsonKey(fromJson: Converters.dynamicToBool)
  bool status;

  @JsonKey(fromJson: Converters.dynamicToBool)
  bool allOutlet;
  
  DateTime? startDate;
  DateTime? endDate;

  @JsonKey(fromJson: Converters.dynamicToBool)
  bool allTime;
  
  String? availableDays;
  
  bool hourly;

  @JsonKey(fromJson: Converters.dynamicToBool)
  bool assignCustomer;

  bool policy;
  bool needCode;
  String? promoCode;
  bool kelipatan;
  int? priority;
  int? requirementProductType;
  List<String>? requirementProductId;
  List<int>? requirementVariantId;
  String? typeName;
  List<String>? days;
  String? description;
  String? assignCustomerName;
  List<int>? numberOfDays;
  String? rewardProductName;
  int? rewardItemPrice;
  List<dynamic>? times;
  List<AssignGroup>? assignGroups;
  List<ItemRequirement>? itemRequirements;

  Promotion({
    required this.id,
    required this.name,
    required this.type,
    this.requirementQuantity,
    this.requirementMinimumOrder,
    this.rewardType,
    this.rewardProductType,
    this.rewardProductId,
    this.rewardVariantId,
    this.rewardQty,
    this.discountType,
    this.rewardNominal,
    this.rewardMaximumAmount,
    required this.status,
    required this.allOutlet,
    this.startDate,
    this.endDate,
    required this.allTime,
    this.availableDays,
    required this.hourly,
    required this.assignCustomer,
    required this.policy,
    required this.needCode,
    this.promoCode,
    required this.kelipatan,
    this.priority,
    this.requirementProductType,
    this.requirementProductId,
    this.requirementVariantId,
    this.typeName,
    this.days,
    this.description,
    this.assignCustomerName,
    this.numberOfDays,
    this.rewardProductName,
    this.rewardItemPrice,
    this.times,
    this.assignGroups,
    this.itemRequirements,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) => _$PromotionFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AssignGroup {
  String id;
  String promotionId;
  int groupId;
  String groupName;

  AssignGroup({
    required this.id,
    required this.promotionId,
    required this.groupId,
    required this.groupName,
  });

  factory AssignGroup.fromJson(Map<String, dynamic> json) => _$AssignGroupFromJson(json);

  Map<String, dynamic> toJson() => _$AssignGroupToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ItemRequirement {
  String id;
  String promotionId;
  int requirementProductType;
  String? requirementProductId;
  int? requirementVariantId;
  String? requirementProductName;

  ItemRequirement({
    required this.id,
    required this.promotionId,
    required this.requirementProductType,
    this.requirementProductId,
    this.requirementVariantId,
    this.requirementProductName,
  });

  factory ItemRequirement.fromJson(Map<String, dynamic> json) => _$ItemRequirementFromJson(json);

  Map<String, dynamic> toJson() => _$ItemRequirementToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
