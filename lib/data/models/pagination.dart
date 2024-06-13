import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination.freezed.dart';
part 'pagination.g.dart';

@Freezed(genericArgumentFactories: true)
class Pagination<T> with _$Pagination<T> {
  @JsonSerializable(
      fieldRename: FieldRename.snake, genericArgumentFactories: true)
  const factory Pagination({
    required int currentPage,
    required int lastPage,
    required int total,
    int? from,
    int? to,
    bool? loading,
    List<T>? data,
  }) = _Pagination<T>;

  factory Pagination.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$PaginationFromJson(json, fromJsonT);
}
