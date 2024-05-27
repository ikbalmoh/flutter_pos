// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CustomerGroup _$CustomerGroupFromJson(Map<String, dynamic> json) {
  return _CustomerGroup.fromJson(json);
}

/// @nodoc
mixin _$CustomerGroup {
  int get groupId => throw _privateConstructorUsedError;
  String get groupName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CustomerGroupCopyWith<CustomerGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerGroupCopyWith<$Res> {
  factory $CustomerGroupCopyWith(
          CustomerGroup value, $Res Function(CustomerGroup) then) =
      _$CustomerGroupCopyWithImpl<$Res, CustomerGroup>;
  @useResult
  $Res call({int groupId, String groupName});
}

/// @nodoc
class _$CustomerGroupCopyWithImpl<$Res, $Val extends CustomerGroup>
    implements $CustomerGroupCopyWith<$Res> {
  _$CustomerGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? groupName = null,
  }) {
    return _then(_value.copyWith(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      groupName: null == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomerGroupImplCopyWith<$Res>
    implements $CustomerGroupCopyWith<$Res> {
  factory _$$CustomerGroupImplCopyWith(
          _$CustomerGroupImpl value, $Res Function(_$CustomerGroupImpl) then) =
      __$$CustomerGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int groupId, String groupName});
}

/// @nodoc
class __$$CustomerGroupImplCopyWithImpl<$Res>
    extends _$CustomerGroupCopyWithImpl<$Res, _$CustomerGroupImpl>
    implements _$$CustomerGroupImplCopyWith<$Res> {
  __$$CustomerGroupImplCopyWithImpl(
      _$CustomerGroupImpl _value, $Res Function(_$CustomerGroupImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? groupName = null,
  }) {
    return _then(_$CustomerGroupImpl(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      groupName: null == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$CustomerGroupImpl implements _CustomerGroup {
  const _$CustomerGroupImpl({required this.groupId, required this.groupName});

  factory _$CustomerGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerGroupImplFromJson(json);

  @override
  final int groupId;
  @override
  final String groupName;

  @override
  String toString() {
    return 'CustomerGroup(groupId: $groupId, groupName: $groupName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerGroupImpl &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, groupId, groupName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerGroupImplCopyWith<_$CustomerGroupImpl> get copyWith =>
      __$$CustomerGroupImplCopyWithImpl<_$CustomerGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerGroupImplToJson(
      this,
    );
  }
}

abstract class _CustomerGroup implements CustomerGroup {
  const factory _CustomerGroup(
      {required final int groupId,
      required final String groupName}) = _$CustomerGroupImpl;

  factory _CustomerGroup.fromJson(Map<String, dynamic> json) =
      _$CustomerGroupImpl.fromJson;

  @override
  int get groupId;
  @override
  String get groupName;
  @override
  @JsonKey(ignore: true)
  _$$CustomerGroupImplCopyWith<_$CustomerGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
