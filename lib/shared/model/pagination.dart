import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination.freezed.dart';
part 'pagination.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class Pagination<T> with _$Pagination<T> {
  @JsonSerializable(
      fieldRename: FieldRename.snake, genericArgumentFactories: true)
  const factory Pagination({
    @Default(0) int currentPage,
    @Default(0) int lastPage,
    @Default(0) int total,
    @Default(0) int? from,
    @Default(0) int? to,
    @Default(false) bool? loading,
    List<T>? data,
  }) = _Pagination<T>;

  factory Pagination.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$PaginationFromJson(json, fromJsonT);

  factory Pagination.empty() => Pagination(
        currentPage: 0,
        lastPage: 0,
        total: 0,
        data: [],
      );
}
