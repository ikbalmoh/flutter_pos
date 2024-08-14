import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:selleri/data/models/converters/generic.dart';
import 'package:objectbox/objectbox.dart';
import 'package:selleri/data/models/customer_group.dart';
import 'package:selleri/data/objectbox.dart';

part 'promotion.g.dart';

@Entity(uid: 9072647444006103348)
@JsonSerializable(fieldRename: FieldRename.snake)
class Promotion {
  int id;

  @Index()
  final String idPromotion;

  final String name;
  int type;
  int? requirementQuantity;
  double? requirementMinimumOrder;
  int? rewardType;
  int? rewardProductType;
  String? rewardProductId;
  int? rewardVariantId;
  int? rewardQty;
  @JsonKey(fromJson: Converters.dynamicToBool)
  bool? discountType;
  double rewardNominal;
  double? rewardMaximumAmount;

  @JsonKey(fromJson: Converters.dynamicToBool)
  bool status;

  @JsonKey(fromJson: Converters.dynamicToBool)
  bool allOutlet;

  DateTime? startDate;
  DateTime? endDate;

  @JsonKey(fromJson: Converters.dynamicToBool)
  bool allTime;

  bool hourly;

  int assignCustomer;

  bool policy;
  bool needCode;
  String? promoCode;
  bool kelipatan;
  int? priority;
  int? requirementProductType;
  List<String> requirementProductId;
  List<String> requirementVariantId;
  String? typeName;
  List<String>? days;
  String? description;
  String? assignCustomerName;
  List<int>? numberOfDays;
  String? rewardProductName;
  int? rewardItemPrice;
  List<String>? times;

  @AssignGroupRelToManyConverter()
  final ToMany<CustomerGroup> assignGroups;

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
    required this.rewardNominal,
    this.rewardMaximumAmount,
    required this.status,
    required this.allOutlet,
    this.startDate,
    this.endDate,
    required this.allTime,
    required this.hourly,
    required this.assignCustomer, // 1 - all, 2 - member, 3 - non member, 4  - group
    required this.policy,
    required this.needCode,
    this.promoCode,
    required this.kelipatan,
    this.priority,
    this.requirementProductType, // 1 - item, 3 - category,
    required this.requirementProductId,
    required this.requirementVariantId,
    this.typeName,
    this.days,
    this.description,
    this.assignCustomerName,
    this.numberOfDays,
    this.rewardProductName,
    this.rewardItemPrice,
    this.times,
    required this.assignGroups,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    final String idPromotion = json['id'];
    Promotion? existPromotion = objectBox.getPromotion(idPromotion);
    json['id_promotion'] = idPromotion;
    json['id'] = existPromotion?.id ?? 0;
    json['requirement_variant_id'] = json['requirement_variant_id'] != null
        ? List.from(json['requirement_variant_id'])
            .map((id) => id.toString())
            .toList()
        : [];
    if (json['assign_groups'] == null) {
      json['assign_groups'] = [];
    }
    json['times'] = json['times'] == null
        ? []
        : List.from(json['times']).map((time) {
            return "${(time['start_time'] as String).substring(0, 5)}-${(time['end_time'] as String).substring(0, 5)}";
          }).toList();
    return _$PromotionFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PromotionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

  static Map<int, String> assignsType = {
    1: 'all_customer'.tr(),
    2: 'member'.tr(),
    3: 'non_member'.tr(),
    4: 'group'.tr()
  };
}

class AssignGroupRelToManyConverter
    implements JsonConverter<ToMany<CustomerGroup>, List?> {
  const AssignGroupRelToManyConverter();

  @override
  ToMany<CustomerGroup> fromJson(List? json) => ToMany<CustomerGroup>(
      items: json?.map((e) => CustomerGroup.fromJson(e)).toList());

  @override
  List<Map<String, dynamic>>? toJson(ToMany<CustomerGroup> rel) =>
      rel.map((CustomerGroup obj) => obj.toJson()).toList();
}

class PromotionType {
  final int id;
  final String name;

  const PromotionType({
    required this.id,
    required this.name,
  });

  static List<PromotionType> filter() => [
        PromotionType(id: 0, name: 'all_type'.tr()),
        PromotionType(id: 2, name: 'transaction'.tr()),
        PromotionType(id: 3, name: 'item'.tr()),
        // const PromotionType(id: 1, name: 'A get B'),
      ];
}

class PromotionType {
  final int id;
  final String name;

  const PromotionType({
    required this.id,
    required this.name,
  });

  static List<PromotionType> filter() => [
        PromotionType(id: 0, name: 'all_type'.tr()),
        PromotionType(id: 2, name: 'transaction'.tr()),
        PromotionType(id: 3, name: 'item'.tr()),
        const PromotionType(id: 1, name: 'A get B'),
      ];
}
