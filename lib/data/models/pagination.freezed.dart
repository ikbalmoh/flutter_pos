// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Pagination<T> _$PaginationFromJson<T>(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) {
  return _Pagination<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$Pagination<T> {
  int get currentPage => throw _privateConstructorUsedError;
  int get lastPage => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get from => throw _privateConstructorUsedError;
  int get to => throw _privateConstructorUsedError;
  bool? get loading => throw _privateConstructorUsedError;
  List<T>? get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaginationCopyWith<T, Pagination<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationCopyWith<T, $Res> {
  factory $PaginationCopyWith(
          Pagination<T> value, $Res Function(Pagination<T>) then) =
      _$PaginationCopyWithImpl<T, $Res, Pagination<T>>;
  @useResult
  $Res call(
      {int currentPage,
      int lastPage,
      int total,
      int from,
      int to,
      bool? loading,
      List<T>? data});
}

/// @nodoc
class _$PaginationCopyWithImpl<T, $Res, $Val extends Pagination<T>>
    implements $PaginationCopyWith<T, $Res> {
  _$PaginationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? lastPage = null,
    Object? total = null,
    Object? from = null,
    Object? to = null,
    Object? loading = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      lastPage: null == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as int,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as int,
      loading: freezed == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<T>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationImplCopyWith<T, $Res>
    implements $PaginationCopyWith<T, $Res> {
  factory _$$PaginationImplCopyWith(
          _$PaginationImpl<T> value, $Res Function(_$PaginationImpl<T>) then) =
      __$$PaginationImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {int currentPage,
      int lastPage,
      int total,
      int from,
      int to,
      bool? loading,
      List<T>? data});
}

/// @nodoc
class __$$PaginationImplCopyWithImpl<T, $Res>
    extends _$PaginationCopyWithImpl<T, $Res, _$PaginationImpl<T>>
    implements _$$PaginationImplCopyWith<T, $Res> {
  __$$PaginationImplCopyWithImpl(
      _$PaginationImpl<T> _value, $Res Function(_$PaginationImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? lastPage = null,
    Object? total = null,
    Object? from = null,
    Object? to = null,
    Object? loading = freezed,
    Object? data = freezed,
  }) {
    return _then(_$PaginationImpl<T>(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      lastPage: null == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as int,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as int,
      loading: freezed == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool?,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<T>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    fieldRename: FieldRename.snake, genericArgumentFactories: true)
class _$PaginationImpl<T> implements _Pagination<T> {
  const _$PaginationImpl(
      {required this.currentPage,
      required this.lastPage,
      required this.total,
      required this.from,
      required this.to,
      this.loading,
      final List<T>? data})
      : _data = data;

  factory _$PaginationImpl.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$PaginationImplFromJson(json, fromJsonT);

  @override
  final int currentPage;
  @override
  final int lastPage;
  @override
  final int total;
  @override
  final int from;
  @override
  final int to;
  @override
  final bool? loading;
  final List<T>? _data;
  @override
  List<T>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Pagination<$T>(currentPage: $currentPage, lastPage: $lastPage, total: $total, from: $from, to: $to, loading: $loading, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationImpl<T> &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.lastPage, lastPage) ||
                other.lastPage == lastPage) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, currentPage, lastPage, total,
      from, to, loading, const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationImplCopyWith<T, _$PaginationImpl<T>> get copyWith =>
      __$$PaginationImplCopyWithImpl<T, _$PaginationImpl<T>>(this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$PaginationImplToJson<T>(this, toJsonT);
  }
}

abstract class _Pagination<T> implements Pagination<T> {
  const factory _Pagination(
      {required final int currentPage,
      required final int lastPage,
      required final int total,
      required final int from,
      required final int to,
      final bool? loading,
      final List<T>? data}) = _$PaginationImpl<T>;

  factory _Pagination.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$PaginationImpl<T>.fromJson;

  @override
  int get currentPage;
  @override
  int get lastPage;
  @override
  int get total;
  @override
  int get from;
  @override
  int get to;
  @override
  bool? get loading;
  @override
  List<T>? get data;
  @override
  @JsonKey(ignore: true)
  _$$PaginationImplCopyWith<T, _$PaginationImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
