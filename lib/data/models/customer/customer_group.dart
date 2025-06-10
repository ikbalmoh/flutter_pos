import 'package:objectbox/objectbox.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_group.g.dart';

@Entity(realClass: CustomerGroup, uid: 6381855780669130651)
@JsonSerializable(fieldRename: FieldRename.snake)
class CustomerGroup {
  int id;

  @Index()
  final int groupId;
  final String groupName;

  CustomerGroup({
    required this.id,
    required this.groupId,
    required this.groupName,
  });

  factory CustomerGroup.fromJson(Map<String, dynamic> json) {
    CustomerGroup? existGroup = objectBox.getCustomerGroup(json['group_id']);
    json['id'] = existGroup?.id ?? 0;
    return _$CustomerGroupFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CustomerGroupToJson(this);
}
