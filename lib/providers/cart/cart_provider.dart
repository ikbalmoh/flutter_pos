import 'package:flutter/foundation.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/cart_payment.dart';
import 'package:selleri/data/models/customer.dart';
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
      payments: [],
      totalPayment: 0,
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

    final int cartIndex =
        state.items.indexWhere((i) => i.identifier == identifier);

    if (cartIndex > -1) {
      final ItemCart existItem = state.items[cartIndex];
      return updateItem(existItem.copyWith(quantity: existItem.quantity + 1));
    }

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
    if (kDebugMode) {
      print('ADD TO CART: $itemCart');
    }
    var items = [...state.items];
    items.add(itemCart);
    state = state.copyWith(items: items);
    calculateCart();
  }

  void updateQty(String identifier, {bool increment = true}) {
    final index = state.items.indexWhere((i) => i.idItem == identifier);
    if (index > -1) {
      List<ItemCart> items = [...state.items];
      ItemCart item = items[index];
      int quantity = increment ? item.quantity + 1 : item.quantity - 1;
      double finalPrice = item.price - item.discountTotal;
      items[index] =
          item.copyWith(quantity: quantity, total: quantity * finalPrice);
      state = state.copyWith(items: items);
      calculateCart();
    }
  }

  void updateItem(ItemCart item) {
    final index =
        state.items.indexWhere((i) => i.identifier == item.identifier);
    if (index > -1) {
      List<ItemCart> items = [...state.items];
      double finalPrice = item.price - item.discountTotal;
      double total = item.quantity * finalPrice;
      items[index] = item.copyWith(total: total);
      state = state.copyWith(items: items);
      calculateCart();
    }
  }

  Future<bool> removeItem(String identifier) async {
    List<ItemCart> items = [...state.items];
    items.removeWhere((i) => i.identifier == identifier);
    state = state.copyWith(items: items);
    calculateCart();
    return true;
  }

  void calculateCart() {
    double? subtotal = state.items.isNotEmpty
        ? state.items
            .map((i) => i.total)
            .reduce((value, total) => value + total)
        : 0;
    double total = subtotal;
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

  void selectCustomer(Customer customer) {
    state = state.copyWith(
        customerName: customer.customerName, idCustomer: customer.idCustomer);
  }

  void unselectCustomer() {
    state = state.copyWith(customerName: '', idCustomer: null);
  }

  void addPayment(CartPayment payment) {
    List<CartPayment> payments = List<CartPayment>.from(state.payments);
    int paymentIdx = payments
        .indexWhere((cp) => cp.paymentMethodId == payment.paymentMethodId);
    if (paymentIdx >= 0) {
      // Update payment
      payments[paymentIdx] = payment;
    } else {
      // Add payment
      payments.add(payment);
    }
    double totalPayment = payments
        .map((payment) => payment.paymentValue)
        .reduce((payment, total) => payment + total);
    state = state.copyWith(payments: payments, totalPayment: totalPayment);
  }
}
