import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:selleri/features/item/model/item.dart';
import 'package:selleri/shared/objectbox.dart';
import '../../../shared/utils/model_converter.dart';

part 'item_package.freezed.dart';
part 'item_package.g.dart';

@Freezed(addImplicitFinal: false)
class ItemPackage with _$ItemPackage {
  const ItemPackage._();

  @Entity(uid: 182247591934260991, realClass: ItemPackage)
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory ItemPackage({
    @Default(0) @Id() int id,
    @Index() required String idItemPackage,
    required String idItem,
    required String itemName,
    required int variantId,
    required int quantityItem,
    @JsonKey(fromJson: ModelConverter.dynamicToDouble)
    required double itemPrice,
  }) = _ItemPackage;

  factory ItemPackage.fromJson(Map<String, dynamic> json) =>
      _$ItemPackageFromJson(json);

  Item? item() => objectBox.getItem(idItem);

  DateTime? expiredDate() => item()?.expiredDate;
  bool isExpired() => item() != null ? item()!.isExpired() : false;
}
