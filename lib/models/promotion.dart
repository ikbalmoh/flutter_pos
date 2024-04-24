import 'package:json_annotation/json_annotation.dart';
import 'package:selleri/models/converters/generic.dart';
import 'package:objectbox/objectbox.dart';

part 'promotion.g.dart';

@Entity()
@JsonSerializable(fieldRename: FieldRename.snake)
class Promotion {
  @JsonKey(name: 'objectbox_id')
  int id;

  @Index()
  @JsonKey(name: 'id')
  String idPromotion;
  
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

  @PromotionTimeRelToManyConverter()
  final ToMany<PromotionTime> times;

  @GroupRelToManyConverter()
  final ToMany<AssignGroup> assignGroups;

  @RequirementRelToManyConverter()
  final ToMany<ItemRequirement> itemRequirements;

  Promotion({
    required this.id,
    required this.idPromotion,
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
    required this.times,
    required this.assignGroups,
    required this.itemRequirements,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) =>
      _$PromotionFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@Entity()
@JsonSerializable(fieldRename: FieldRename.snake)
class PromotionTime {
  @JsonKey(name: 'objectbox_id')
  int id;
  
  @Index()
  @JsonKey(name: 'id')
  String idTime;
  
  String startTime;
  String endTime;

  PromotionTime({
    required this.id,
    required this.idTime,
    required this.startTime,
    required this.endTime,
  });

  factory PromotionTime.fromJson(Map<String, dynamic> json) =>
      _$PromotionTimeFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionTimeToJson(this);
}

@Entity()
@JsonSerializable(fieldRename: FieldRename.snake)
class AssignGroup {
  @JsonKey(name: 'objectbox_id')
  int id;

  @Index()
  @JsonKey(name: 'id')
  String idAssignGroup;
  
  int groupId;
  String groupName;

  AssignGroup({
    required this.id,
    required this.idAssignGroup,
    required this.groupId,
    required this.groupName,
  });

  factory AssignGroup.fromJson(Map<String, dynamic> json) =>
      _$AssignGroupFromJson(json);

  Map<String, dynamic> toJson() => _$AssignGroupToJson(this);
}

@Entity()
@JsonSerializable(fieldRename: FieldRename.snake)
class ItemRequirement {
  @JsonKey(name: 'objectbox_id')
  int id;
  
  @Index()
  @JsonKey(name: 'id')
  String idItemRequirement;
  
  int requirementProductType;
  String? requirementProductId;
  int? requirementVariantId;
  String? requirementProductName;

  ItemRequirement({
    required this.id,
    required this.idItemRequirement,
    required this.requirementProductType,
    this.requirementProductId,
    this.requirementVariantId,
    this.requirementProductName,
  });

  factory ItemRequirement.fromJson(Map<String, dynamic> json) =>
      _$ItemRequirementFromJson(json);

  Map<String, dynamic> toJson() => _$ItemRequirementToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

class GroupRelToManyConverter
    implements JsonConverter<ToMany<AssignGroup>, List?> {
  const GroupRelToManyConverter();

  @override
  ToMany<AssignGroup> fromJson(List? json) => ToMany<AssignGroup>(
      items: json?.map((e) => AssignGroup.fromJson(e)).toList());

  @override
  List<Map<String, dynamic>>? toJson(ToMany<AssignGroup> rel) =>
      rel.map((AssignGroup obj) => obj.toJson()).toList();
}

class RequirementRelToManyConverter
    implements JsonConverter<ToMany<ItemRequirement>, List?> {
  const RequirementRelToManyConverter();

  @override
  ToMany<ItemRequirement> fromJson(List? json) => ToMany<ItemRequirement>(
      items: json?.map((e) => ItemRequirement.fromJson(e)).toList());

  @override
  List<Map<String, dynamic>>? toJson(ToMany<ItemRequirement> rel) =>
      rel.map((ItemRequirement obj) => obj.toJson()).toList();
}

class PromotionTimeRelToManyConverter
    implements JsonConverter<ToMany<PromotionTime>, List?> {
  const PromotionTimeRelToManyConverter();

  @override
  ToMany<PromotionTime> fromJson(List? json) => ToMany<PromotionTime>(
      items: json?.map((e) => PromotionTime.fromJson(e)).toList());

  @override
  List<Map<String, dynamic>>? toJson(ToMany<PromotionTime> rel) =>
      rel.map((PromotionTime obj) => obj.toJson()).toList();
}
