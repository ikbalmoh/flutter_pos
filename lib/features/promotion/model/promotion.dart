import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/features/item/model/item_cart.dart';
import 'package:selleri/shared/utils/model_converter.dart';
import 'package:objectbox/objectbox.dart';
import 'package:selleri/features/customer/model/customer_group.dart';
import 'package:selleri/shared/objectbox.dart';

part 'promotion.freezed.dart';
part 'promotion.g.dart';

@Freezed(addImplicitFinal: false)
class Promotion with _$Promotion {
  @Entity(uid: 9072647444006103348, realClass: Promotion)
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory Promotion({
    @Default(0) @Id() int id,
    @Index() required String idPromotion,
    required String name,
    required int type,
    int? requirementQuantity,
    double? requirementMinimumOrder,
    int? rewardType,
    int? rewardProductType,
    String? rewardProductId,
    int? rewardVariantId,
    int? rewardQty,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) bool? discountType,
    required double rewardNominal,
    double? rewardMaximumAmount,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) required bool status,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) required bool allOutlet,
    @Property(type: PropertyType.date) DateTime? startDate,
    @Property(type: PropertyType.date) DateTime? endDate,
    @JsonKey(fromJson: ModelConverter.dynamicToBool) required bool allTime,
    required bool hourly,
    required int assignCustomer, // 1 - all, 2 - member, 3 - non member, 4 - group
    required bool policy,
    required bool needCode,
    String? promoCode,
    required bool kelipatan,
    int? priority,
    int? requirementProductType, // 1 - item, 3 - category
    required List<String> requirementProductId,
    required List<String> requirementVariantId,
    String? typeName,
    List<String>? days,
    String? description,
    String? assignCustomerName,
    List<int>? numberOfDays,
    String? rewardProductName,
    int? rewardItemPrice,
    List<String>? times,
    @AssignGroupRelToManyConverter() required ToMany<CustomerGroup> assignGroups,
    @Default([]) List<ItemCart> eligibleItems,
  }) = _Promotion;

  const Promotion._();

  factory Promotion.fromJson(Map<String, dynamic> json) =>
      _$PromotionFromJson(json);

  factory Promotion.fromJsonData(Map<String, dynamic> json) {
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
    if (json['days'] != null && (json['days'] as List).isEmpty) {
      json['days'] = null;
    }
    json['times'] = json['times'] == null
        ? []
        : List.from(json['times']).map((time) {
            return "${(time['start_time'] as String).substring(0, 5)}-${(time['end_time'] as String).substring(0, 5)}";
          }).toList();
    return _$PromotionFromJson(json);
  }
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
        const PromotionType(id: 1, name: 'A get B'),
      ];
}
