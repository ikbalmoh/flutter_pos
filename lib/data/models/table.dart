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
    @JsonKey(fromJson: Converters.timeStampToDateTime) DateTime? usedFrom,
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
class TableConfig with _$TableConfig {
  @JsonSerializable(fieldRename: FieldRename.snake, createToJson: true)
  const factory TableConfig({
    required int totalFloor,
  }) = _TableConfig;

  factory TableConfig.fromJson(Map<String, dynamic> json) =>
      _$TableConfigFromJson(json);

  factory TableConfig.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return TableConfig(totalFloor: data?['total_floor'] ?? 1);
  }

  // Map<String, dynamic> toFirestore() {
  //   return {"total_floor": totalFloor, "tables": []};
  // }
}
