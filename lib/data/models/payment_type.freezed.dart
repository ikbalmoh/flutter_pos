// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PaymentType {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  Icon get icon => throw _privateConstructorUsedError;
  bool? get isExpanded => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PaymentTypeCopyWith<PaymentType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentTypeCopyWith<$Res> {
  factory $PaymentTypeCopyWith(
          PaymentType value, $Res Function(PaymentType) then) =
      _$PaymentTypeCopyWithImpl<$Res, PaymentType>;
  @useResult
  $Res call({int id, String name, Icon icon, bool? isExpanded});
}

/// @nodoc
class _$PaymentTypeCopyWithImpl<$Res, $Val extends PaymentType>
    implements $PaymentTypeCopyWith<$Res> {
  _$PaymentTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = null,
    Object? isExpanded = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as Icon,
      isExpanded: freezed == isExpanded
          ? _value.isExpanded
          : isExpanded // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentTypeImplCopyWith<$Res>
    implements $PaymentTypeCopyWith<$Res> {
  factory _$$PaymentTypeImplCopyWith(
          _$PaymentTypeImpl value, $Res Function(_$PaymentTypeImpl) then) =
      __$$PaymentTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, Icon icon, bool? isExpanded});
}

/// @nodoc
class __$$PaymentTypeImplCopyWithImpl<$Res>
    extends _$PaymentTypeCopyWithImpl<$Res, _$PaymentTypeImpl>
    implements _$$PaymentTypeImplCopyWith<$Res> {
  __$$PaymentTypeImplCopyWithImpl(
      _$PaymentTypeImpl _value, $Res Function(_$PaymentTypeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = null,
    Object? isExpanded = freezed,
  }) {
    return _then(_$PaymentTypeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as Icon,
      isExpanded: freezed == isExpanded
          ? _value.isExpanded
          : isExpanded // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$PaymentTypeImpl implements _PaymentType {
  const _$PaymentTypeImpl(
      {required this.id,
      required this.name,
      required this.icon,
      this.isExpanded});

  @override
  final int id;
  @override
  final String name;
  @override
  final Icon icon;
  @override
  final bool? isExpanded;

  @override
  String toString() {
    return 'PaymentType(id: $id, name: $name, icon: $icon, isExpanded: $isExpanded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentTypeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.isExpanded, isExpanded) ||
                other.isExpanded == isExpanded));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, icon, isExpanded);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentTypeImplCopyWith<_$PaymentTypeImpl> get copyWith =>
      __$$PaymentTypeImplCopyWithImpl<_$PaymentTypeImpl>(this, _$identity);
}

abstract class _PaymentType implements PaymentType {
  const factory _PaymentType(
      {required final int id,
      required final String name,
      required final Icon icon,
      final bool? isExpanded}) = _$PaymentTypeImpl;

  @override
  int get id;
  @override
  String get name;
  @override
  Icon get icon;
  @override
  bool? get isExpanded;
  @override
  @JsonKey(ignore: true)
  _$$PaymentTypeImplCopyWith<_$PaymentTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
