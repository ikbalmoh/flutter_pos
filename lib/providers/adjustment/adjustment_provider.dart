import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/adjustment.dart' as model;
import 'package:selleri/data/models/adjustment_history.dart';
import 'package:selleri/data/models/item_adjustment.dart';
import 'package:selleri/data/models/item_variant_adjustment.dart';
import 'package:selleri/data/network/adjustment.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';

part 'adjustment_provider.g.dart';

@riverpod
class Adjustment extends _$Adjustment {
  @override
  model.Adjustment build() {
    return model.Adjustment(date: DateTime.now(), items: [], description: '');
  }

  void addToCart(ItemAdjustment item, {List<ItemVariantAdjustment>? variants}) {
    List<ItemAdjustment> items = List<ItemAdjustment>.from(state.items);
    if (variants != null && variants.isNotEmpty) {
      for (var i = 0; i < variants.length; i++) {
        ItemVariantAdjustment variant = variants[i];
        int itemIdx = items.indexWhere((adj) =>
            (adj.idItem == item.idItem && adj.variantId == variant.idVariant));
        ItemAdjustment itemVariant = item.copyWith(
          variantId: variant.idVariant,
          variantName: variant.variantName,
          qtyActual: variant.qtyActual,
          qtySystem: variant.qtySystem,
          qtyDiff: variant.qtyDiff,
        );
        if (itemIdx >= 0) {
          items[itemIdx] = itemVariant;
        } else {
          items = items..add(itemVariant);
        }
      }
    } else {
      int itemIdx = items.indexWhere((adj) =>
          (adj.idItem == item.idItem && adj.variantId == item.variantId));
      if (itemIdx >= 0) {
        items[itemIdx] = item;
      } else {
        items = items..add(item);
      }
    }
    state = state.copyWith(items: items);
  }

  void addItemsToCart(List<ItemAdjustment> items) {
    List<String> ids = state.items.map((item) => item.idItem).toList();
    List<ItemAdjustment> allItems = [];
    allItems.addAll(state.items);
    allItems.addAll(items.where((item) => !ids.contains(item.idItem)).toList());
    state = state.copyWith(items: allItems);
  }

  void setDate(DateTime date) {
    state = state.copyWith(date: date);
  }

  void removeItem(String id) async {
    List<ItemAdjustment> items =
        state.items.where((adj) => adj.idItem != id).toList();
    state = state.copyWith(items: items);
  }

  void resetForm() {
    state = state.copyWith(items: [], date: DateTime.now());
  }

  Future<String> submitAdjustment({String? description}) async {
    try {
      final outletState = ref.read(outletProvider).value as OutletSelected;
      final api = AdjustmentApi();
      final payload = state.copyWith(description: description ?? '');
      final res =
          await api.createAdjustment(outletState.outlet.idOutlet, payload);
      resetForm();
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> duplicateAdjustment(
      {required AdjustmentHistory adjustment}) async {
    try {
      final api = AdjustmentApi();
      state = model.Adjustment(
        date: DateTime.now(),
        description: adjustment.description ?? '',
        items: [],
      );
      List<ItemAdjustment> items = await api.adjustmentDetailItems(
          id: adjustment.idAdjustment, isCopy: true);
      state = state.copyWith(items: items);
    } catch (e) {
      rethrow;
    }
  }
}
