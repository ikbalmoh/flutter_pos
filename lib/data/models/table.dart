import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:selleri/data/models/converters/generic.dart';

part 'table.freezed.dart';
part 'table.g.dart';

@freezed
class Table with _$Table {
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: true)
  const factory Table({
    required String id,
    @JsonKey(fromJson: Converters.dynamicToInt) int? capacity,
    @JsonKey(fromJson: Converters.dynamicToInt) int? floor,
    required String name,
    String? usedBy,
    DateTime? usedFrom,
  }) = _Table;

  factory Table.fromJson(Map<String, dynamic> json) => _$TableFromJson(json);

  factory Table.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    var data = snapshot.data()!;
    data['id'] = snapshot.id;
    return Table.fromJson(data);
  }
}

@freezed
class TableData with _$TableData {
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: true)
  const factory TableData({
    required int totalFloor,
    required List<Table> tables,
  }) = _TableData;

  factory TableData.fromJson(Map<String, dynamic> json) =>
      _$TableDataFromJson(json);

  factory TableData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return TableData(
        totalFloor: data?['total_floor'] ?? 1,
        tables: data?['tables'] is Iterable
            ? List.from(data?['tables'])
                .map((json) => Table.fromJson(json))
                .toList()
            : []);
  }

  // Map<String, dynamic> toFirestore() {
  //   return {"total_floor": totalFloor, "tables": []};
  // }
}
