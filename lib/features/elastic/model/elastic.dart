import 'package:freezed_annotation/freezed_annotation.dart';

part 'elastic.freezed.dart';
part 'elastic.g.dart';


// ---------------------------------------------------------------------------
// ElasticResponse  — top-level response (non-generic)
// ---------------------------------------------------------------------------

@freezed
class ElasticResponse with _$ElasticResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ElasticResponse({
    required int took,
    required bool timedOut,
    @JsonKey(name: '_shards') ElasticShards? shards,
    required ElasticHits hits,
  }) = _ElasticResponse;

  factory ElasticResponse.fromJson(Map<String, dynamic> json) =>
      _$ElasticResponseFromJson(json);
}

// ---------------------------------------------------------------------------
// ElasticShards
// ---------------------------------------------------------------------------

@freezed
class ElasticShards with _$ElasticShards {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ElasticShards({
    required int total,
    required int successful,
    required int skipped,
    required int failed,
  }) = _ElasticShards;

  factory ElasticShards.fromJson(Map<String, dynamic> json) =>
      _$ElasticShardsFromJson(json);
}

// ---------------------------------------------------------------------------
// ElasticTotal
// ---------------------------------------------------------------------------

@freezed
class ElasticTotal with _$ElasticTotal {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ElasticTotal({
    required int value,
    required String relation,
  }) = _ElasticTotal;

  factory ElasticTotal.fromJson(Map<String, dynamic> json) =>
      _$ElasticTotalFromJson(json);
}

// ---------------------------------------------------------------------------
// ElasticHit  — a single hit; _source kept as raw map to avoid the
// json_serializable bug with List<GenericClass<T>> in generic classes.
// ---------------------------------------------------------------------------

@freezed
class ElasticHit with _$ElasticHit {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ElasticHit({
    @JsonKey(name: '_index') String? index,
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: '_score') double? score,
    /// Raw source document — use [ElasticHit.mapSource] to deserialize.
    @JsonKey(name: '_source') Map<String, dynamic>? source,
  }) = _ElasticHit;

  const ElasticHit._();

  /// Deserializes [source] into [T] using [fromJson].
  T? mapSource<T>(T Function(Map<String, dynamic>) fromJson) =>
      source != null ? fromJson(source!) : null;

  factory ElasticHit.fromJson(Map<String, dynamic> json) =>
      _$ElasticHitFromJson(json);
}

// ---------------------------------------------------------------------------
// ElasticHits  — the hits container (non-generic; generics live at call site)
// ---------------------------------------------------------------------------

@freezed
class ElasticHits with _$ElasticHits {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ElasticHits({
    required ElasticTotal total,
    double? maxScore,
    @Default([]) List<ElasticHit> hits,
  }) = _ElasticHits;

  const ElasticHits._();

  /// Deserializes every hit's source into a typed [List<T>].
  List<T> sources<T>(T Function(Map<String, dynamic>) fromJson) => hits
      .map((h) => h.mapSource(fromJson))
      .whereType<T>()
      .toList();

  factory ElasticHits.fromJson(Map<String, dynamic> json) =>
      _$ElasticHitsFromJson(json);
}
