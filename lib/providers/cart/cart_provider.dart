import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/cart_holded.dart';
import 'package:selleri/data/models/cart_payment.dart';
import 'package:selleri/data/models/customer.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:selleri/data/models/item_variant.dart';
import 'package:selleri/data/models/outlet_config.dart';
import 'package:selleri/data/network/transaction.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/providers/settings/printer_provider.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'dart:developer';

import 'package:selleri/utils/printer.dart';

part 'cart_provider.g.dart';

@Riverpod(keepAlive: true)
class CartNotifer extends _$CartNotifer {
  @override
  Cart build() {
    return emptyCart();
  }

  Cart emptyCart() {
    return Cart(
      transactionNo: '',
      transactionDate: (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
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
      ppnIsInclude: true,
      ppn: 0,
      ppnTotal: 0,
      change: 0,
      idOutlet: '', // define on initCart
      outletName: '', // define on initCart
      shiftId: '', // define on initCart
      createdBy: '', // define on initCart
      isApp: true,
    );
  }

  Future<void> initCart() async {
    try {
      if (ref.read(authNotifierProvider).value is! Authenticated) {
        return;
      }

      final outletState =
          ref.read(outletNotifierProvider).value as OutletSelected;

      final authState =
          await ref.read(authNotifierProvider.future) as Authenticated;

      final shift = ref.read(shiftNotifierProvider).value;

      String? transactionNo =
          '${outletState.outlet.outletCode}-${authState.user.user.idUser.substring(9, 13)}-${DateTime.now().millisecondsSinceEpoch}';

      final tax = outletState.config.tax;
      final taxable = outletState.config.taxable ?? false;

      Cart cart = emptyCart();

      state = cart.copyWith(
        idOutlet: outletState.outlet.idOutlet,
        outletName: outletState.outlet.outletName,
        createdBy: authState.user.user.idUser,
        createdName: authState.user.user.name,
        shiftId: shift!.id,
        transactionNo: transactionNo,
        ppn: tax?.percentage ?? 0,
        ppnIsInclude: tax?.isInclude ?? true,
        taxName: taxable ? tax?.taxName : '',
      );

      log('Cart Initialized: ${state.toString()}');
    } on Exception catch (e) {
      log('Init Cart Failed: ${e.toString()}');
    }
  }

  void addToCart(Item item, {ItemVariant? variant}) async {
    if (state.idOutlet == '') {
      await initCart();
    }
    String identifier = item.idItem;
    String itemName = item.itemName;
    double itemPrice = item.itemPrice;

    if (item.isPackage) {
      identifier += (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    } else if (variant != null) {
      identifier += '-v${variant.idVariant.toString()}';
      itemPrice = variant.itemPrice;
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
      price: itemPrice,
      isPackage: item.isPackage,
      manualDiscount: item.manualDiscount,
      isManualPrice: item.isManualPrice,
      quantity: 1,
      discount: 0,
      discountIsPercent: true,
      discountTotal: 0,
      note: '',
      total: itemPrice,
      addedAt: DateTime.now(),
      idVariant: variant?.idVariant,
      variantName: variant?.variantName ?? '',
    );

    if (kDebugMode) {
      log('ADD TO CART: $itemCart');
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
    double discOverallTotal = 0;
    if (subtotal != 0 && state.discOverall > 0) {
      discOverallTotal = state.discIsPercent
          ? subtotal * (state.discOverall / 100)
          : state.discOverall;
    }
    double total = subtotal - discOverallTotal;
    double grandTotal = total;
    double ppn = state.ppn;

    double ppnTotal = 0;
    if (state.ppn > 0) {
      if (state.ppnIsInclude) {
        double dpp = grandTotal / ((100 + ppn) / 100);
        ppnTotal = dpp * (ppn / 100);
      } else {
        ppnTotal = grandTotal * (ppn / 100);
        grandTotal += ppnTotal;
      }
    }

    double change =
        state.totalPayment > grandTotal ? state.totalPayment - grandTotal : 0;

    state = state.copyWith(
      subtotal: subtotal,
      ppnTotal: ppnTotal,
      total: total,
      grandTotal: grandTotal,
      discOverallTotal: discOverallTotal,
      change: change,
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

  void setDiscountTransaction(
      {required double discount, required bool discIsPercent}) {
    double discOverallTotal =
        discIsPercent ? state.subtotal * (discount / 100) : discount;
    state = state.copyWith(
      discIsPercent: discIsPercent,
      discOverall: discount,
      discOverallTotal: discOverallTotal,
    );
    calculateCart();
  }

  void addPayment(CartPayment payment) {
    final auth = ref.read(authNotifierProvider).value as Authenticated;

    payment = payment.copyWith(
      createdBy: auth.user.user.idUser,
      payDate: (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
    );

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
    calculateCart();
  }

  Future<void> storeTransaction() async {
    try {
      final api = TransactionApi();

      final res = await api.storeTransaction(state);

      log('TRANSACTIONS: $res');

      if (res.isEmpty) {
        throw Exception('transaction_error'.tr());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> printReceipt({int printCounter = 1}) async {
    try {
      final printer = ref.read(printerNotifierProvider).value;
      if (printer == null) {
        throw Exception('printer_not_connected'.tr());
      }
      final AttributeReceipts? attributeReceipts =
          (ref.read(outletNotifierProvider).value as OutletSelected)
              .config
              .attributeReceipts;
      final receipt = await Printer.buildReceiptBytes(
        state,
        attributes: attributeReceipts,
        size: printer.size,
        isCopy: printCounter > 1,
      );
      ref.read(printerNotifierProvider.notifier).print(receipt);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> holdCart({required String note, bool createNew = false}) async {
    Cart cart =
        state.copyWith(holdAt: DateTime.now(), description: note, isApp: true);
    final api = TransactionApi();
    if (cart.idTransaction != null) {
      await api.updateHoldTransaction(cart.idTransaction!, cart);
    } else {
      await api.holdTransaction(cart);
    }
    if (createNew) {
      initCart();
    } else {
      state = cart;
    }
  }

  void openHoldedCart(CartHolded holded) {
    Cart cart = holded.dataHold.copyWith(idTransaction: holded.transactionId);
    if (cart.holdAt == null) {
      cart = cart.copyWith(holdAt: DateTime.now());
    }
    state = cart;
  }
}
