import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:selleri/features/item/api/item_api.dart';
import 'package:selleri/features/item/model/item_suggestion.dart';

part 'extra_item_suggestions.g.dart';

@riverpod
class ExtraItemSuggestions extends _$ExtraItemSuggestions {
  @override
  Future<List<ItemSuggestion>> build(String query) async {
    if (query.length < 3) {
      return [];
    }

    return await ref.read(itemApiProvider).extraItemSuggestions(query);
  }
}
