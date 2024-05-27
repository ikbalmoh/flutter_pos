// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerGroupImpl _$$CustomerGroupImplFromJson(Map<String, dynamic> json) =>
    _$CustomerGroupImpl(
      groupId: (json['group_id'] as num).toInt(),
      groupName: json['group_name'] as String,
    );

Map<String, dynamic> _$$CustomerGroupImplToJson(_$CustomerGroupImpl instance) =>
    <String, dynamic>{
      'group_id': instance.groupId,
      'group_name': instance.groupName,
    };
