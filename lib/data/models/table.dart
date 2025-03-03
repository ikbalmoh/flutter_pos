import 'package:freezed_annotation/freezed_annotation.dart';

part 'table.freezed.dart';
part 'table.g.dart';

@freezed
class Table with _$Table {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Table({
    required String id,
    required int capacity,
    required int floor,
    required String name,
    String? usedBy,
    DateTime? usedFrom,
  }) = _Table;

  factory Table.fromJson(Map<String, dynamic> json) => _$TableFromJson(json);
}

@freezed
class TableData with _$TableData {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TableData({
    required int totalFloor,
    required List<Table> tables,
  }) = _TableData;

  factory TableData.fromJson(Map<String, dynamic> json) =>
      _$TableDataFromJson(json);
}
