import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/adjustment.dart' as model;
import 'package:selleri/data/models/item_adjustment.dart';

part 'adjustment_provider.g.dart';

@riverpod
class Adjustment extends _$Adjustment {
  @override
  model.Adjustment build() {
    return model.Adjustment(date: DateTime.now(), items: [], note: '');
  }

  void addToCart(ItemAdjustment item) {
    List<ItemAdjustment> items = List<ItemAdjustment>.from(state.items);
    int itemIdx = items.indexWhere((adj) =>
        (adj.idItem == item.idItem && adj.variantId == item.variantId));
    if (itemIdx >= 0) {
      // Update
      items[itemIdx] = item;
    } else {
      items = items..add(item);
    }
    state = state.copyWith(items: items);
  }

  void removeItem(String id) async {
    List<ItemAdjustment> items =
        state.items.where((adj) => adj.idItem != id).toList();
    state = state.copyWith(items: items);
  }
}
