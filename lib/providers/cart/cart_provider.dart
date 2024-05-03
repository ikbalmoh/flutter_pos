import 'package:get/get.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:selleri/data/models/item_variant.dart';

part 'cart_provider.g.dart';

@Riverpod(keepAlive: true)
class CartNotifer extends _$CartNotifer {
  @override
  Cart build() {
    return Cart(
      transactionDate: DateTime.now(),
      items: [],
      subtotal: 0,
      total: 0,
      grandTotal: 0,
      discIsPercent: true,
      discOverall: 0,
      discOverallTotal: 0,
      discPromotionsTotal: 0,
    );
  }

  void addToCart(Item item, {ItemVariant? variant}) async {
    String identifier = item.idItem;
    String itemName = item.itemName;
    if (item.isPackage) {
      identifier += (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    } else if (variant != null) {
      identifier += '-v${variant.idVariant.toString()}';
    }
    int idx = state.items.indexWhere((i) => i.identifier == identifier);

    if (idx > -1) return updateQty(identifier);

    ItemCart itemCart = ItemCart(
      identifier: identifier,
      idItem: item.idItem,
      itemName: itemName,
      price: item.itemPrice,
      isPackage: item.isPackage,
      manualDiscount: item.manualDiscount,
      isManualPrice: item.isManualPrice,
      quantity: 1,
      discount: 0,
      discountIsPercent: true,
      discountTotal: 0,
      note: '',
      total: item.itemPrice,
      addedAt: DateTime.now(),
      idVariant: variant?.idVariant,
      variantName: variant?.variantName ?? '',
    );
    var items = state.items;
    items.add(itemCart);
    state = state.copyWith(items: items);
  }

  void updateQty(String identifier, {bool increment = true}) {
    ItemCart? item =
        state.items.firstWhereOrNull((i) => i.identifier == identifier);
    if (item != null) {
      item = item.copyWith(
        quantity: increment ? item.quantity + 1 : item.quantity - 1,
      );
      state = state.copyWith(
          items: state.items
            ..map((it) => it.identifier == identifier ? item : it));
    }
  }

  void calculateCart() {
    double? subtotal = state.items.isNotEmpty
        ? state.items
            .map((i) => i.total)
            .reduce((value, total) => value + total)
        : 0;
    double total = 0;
    if (subtotal != 0 && state.discOverallTotal > 0) {
      total = subtotal - state.discOverallTotal;
    }
    double grandTotal = total;
    state = state.copyWith(
      subtotal: subtotal,
      total: total,
      grandTotal: grandTotal,
    );
  }

  int qtyOnCart(String idItem) {
    List<int> qtyItems = state.items
        .where((i) => i.idItem == idItem)
        .map((i) => i.quantity)
        .toList();
    return qtyItems.isNotEmpty
        ? qtyItems.reduce((qty, total) => qty + total)
        : 0;
  }
}
