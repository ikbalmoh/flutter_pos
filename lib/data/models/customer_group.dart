import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_group.freezed.dart';
part 'customer_group.g.dart';

@freezed
class CustomerGroup with _$CustomerGroup {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CustomerGroup({
    required int groupId,
    required String groupName,
  }) = _CustomerGroup;

  factory CustomerGroup.fromJson(Map<String, dynamic> json) =>
      _$CustomerGroupFromJson(json);
}
