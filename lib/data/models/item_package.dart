import 'package:objectbox/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';
import 'converters/generic.dart';

part 'item_package.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
@Entity(uid: 182247591934260991)
class ItemPackage {
  int id;

  @Index()
  String idItem;
  
  String itemName;
  int variantId;
  int quantityItem;

  @JsonKey(fromJson: Converters.dynamicToDouble)
  double itemPrice;

  ItemPackage({
    required this.id,
    required this.idItem,
    required this.itemName,
    required this.variantId,
    required this.quantityItem,
    required this.itemPrice,
  });

  factory ItemPackage.fromJson(Map<String, dynamic> json) => _$ItemPackageFromJson(json);

  Map<String, dynamic> toJson() => _$ItemPackageToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
