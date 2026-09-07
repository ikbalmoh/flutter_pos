import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_suggestion.freezed.dart';
part 'item_suggestion.g.dart';

@freezed
abstract class ItemSuggestion with _$ItemSuggestion {
  const ItemSuggestion._();

  const factory ItemSuggestion({
    @JsonKey(name: 'id_item') required String idItem,
    @JsonKey(name: 'item_name') required String itemName,
  }) = _ItemSuggestion;

  factory ItemSuggestion.fromJson(Map<String, dynamic> json) =>
      _$ItemSuggestionFromJson(json);
}
    
  