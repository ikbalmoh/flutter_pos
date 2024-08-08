import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selleri/data/models/cart.dart' as model show Cart;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/cart_holded.dart';
import 'package:selleri/data/models/cart_payment.dart';
import 'package:selleri/data/models/cart_promotion.dart';
import 'package:selleri/data/models/customer.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:selleri/data/models/item_cart_detail.dart';
import 'package:selleri/data/models/item_package.dart';
import 'package:selleri/data/models/item_variant.dart';
import 'package:selleri/data/models/outlet_config.dart';
import 'package:selleri/data/network/transaction.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/providers/promotion/promotion_provider.dart';
import 'package:selleri/providers/settings/printer_provider.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/utils/app_alert.dart';
import 'dart:developer';
import 'package:selleri/utils/printer.dart' as util;

part 'cart_provider.g.dart';

@Riverpod(keepAlive: true)
class Cart extends _$Cart {
  @override
  model.Cart build() {
    return model.Cart.initial();
  }

  Future<void> initCart() async {
    try {
      if (ref.read(authNotifierProvider).value is! Authenticated) {
        return;
      }

      final outletState = ref.read(outletProvider).value as OutletSelected;

      final authState =
          await ref.read(authNotifierProvider.future) as Authenticated;

      final shift = ref.read(shiftProvider).value;

      if (shift == null) {
        log('Shift is not started');
        return;
      }

      String? transactionNo =
          '${outletState.outlet.outletCode}-${authState.user.user.idUser.substring(9, 13)}-${(DateTime.now().millisecondsSinceEpoch / 1000).floor()}';

      final tax = outletState.config.tax;
      final taxable = outletState.config.taxable ?? false;

      model.Cart cart = model.Cart.initial();

      state = cart.copyWith(
        idOutlet: outletState.outlet.idOutlet,
        outletName: outletState.outlet.outletName,
        createdBy: authState.user.user.idUser,
        createdName: authState.user.user.name,
        shiftId: shift.id,
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

  List<ItemPackage> getEmptyItemPackages(List<ItemPackage> packageItems) {
    List<ItemPackage> emptyItems = [];
    for (var pkg in packageItems) {
      Item? itemPackage = objectBox.getItem(pkg.idItem);
      log('package: ${itemPackage?.itemName} => ${itemPackage?.stockItem}');
      if (itemPackage == null || itemPackage.stockItem < 1) {
        emptyItems.add(pkg);
      }
    }

    return emptyItems;
  }

  void addToCart(Item item, {ItemVariant? variant}) async {
    if (state.idOutlet == '' || state.shiftId == '' || state.items.isEmpty) {
      await initCart();
    }
    String identifier = item.idItem;
    String itemName = item.itemName;
    double itemPrice = item.itemPrice;

    if (item.isPackage) {
      final emptyItems = getEmptyItemPackages(item.packageItems);
      if (emptyItems.isNotEmpty) {
        AppAlert.toast('x_stock_empty'.tr(args: [emptyItems.first.itemName]));
        return;
      }
      identifier += (DateTime.now().millisecondsSinceEpoch).toString();
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
      details: item.packageItems
          .map(
            (pkg) => ItemCartDetail(
              itemId: pkg.idItem,
              name: pkg.itemName,
              variantId: pkg.variantId,
              quantity: pkg.quantityItem,
              itemPrice: pkg.itemPrice,
            ),
          )
          .toList(),
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

    final promotionByOrder = state.promotions.where((p) => p.type == 2);

    double discPromotionsTotal = promotionByOrder.isNotEmpty
        ? promotionByOrder.map((p) => p.discountValue).reduce((a, b) => a + b)
        : 0;

    double total = subtotal - discOverallTotal - discPromotionsTotal;
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
      discPromotionsTotal: discPromotionsTotal,
      change: change,
      transactionDate: DateTime.now().millisecondsSinceEpoch,
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

  void addNote({String? notes, List<XFile>? images}) {
    state = state.copyWith(notes: notes, images: images);
  }

  void addPayment(CartPayment payment) {
    final auth = ref.read(authNotifierProvider).value as Authenticated;

    payment = payment.copyWith(
      createdBy: auth.user.user.idUser,
      payDate: (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
    );

    List<CartPayment> payments = List<CartPayment>.from(state.payments);
    int paymentIdx = payments.indexWhere((cp) =>
        cp.createdAt == null && cp.paymentMethodId == payment.paymentMethodId);

    if (payment.paymentValue <= 0) {
      payments.removeWhere((p) => p.paymentMethodId == payment.paymentMethodId);
    } else if (paymentIdx >= 0) {
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

  void removePayment(String paymentMethodId) {
    List<CartPayment> payments = List<CartPayment>.from(state.payments);
    payments.removeWhere(
        (p) => p.paymentMethodId == paymentMethodId && p.createdAt == null);
    double totalPayment = payments.isNotEmpty
        ? payments
            .map((payment) => payment.paymentValue)
            .reduce((payment, total) => payment + total)
        : 0;
    state = state.copyWith(payments: payments, totalPayment: totalPayment);
    calculateCart();
  }

  Future<void> storeTransaction() async {
    try {
      final api = TransactionApi();

      final shift = ref.read(shiftProvider).value;
      if (shift == null) {
        throw 'shift_not_opened'.tr();
      }

      final res = await api.storeTransaction(state.copyWith(
        shiftId: shift.id,
      ));

      log('TRANSACTIONS: $res');

      if (res.isEmpty) {
        throw 'transaction_error'.tr();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> printReceipt({int printCounter = 1}) async {
    try {
      final printer = ref.read(printerProvider).value;
      if (printer == null) {
        throw 'printer_not_connected'.tr();
      }
      final AttributeReceipts? attributeReceipts =
          (ref.read(outletProvider).value as OutletSelected)
              .config
              .attributeReceipts;
      final receipt = await util.Printer.buildReceiptBytes(
        state,
        attributes: attributeReceipts,
        size: printer.size,
        isCopy: printCounter > 1,
      );
      ref.read(printerProvider.notifier).print(receipt);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> holdCart({required String note, bool createNew = false}) async {
    model.Cart cart =
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
    model.Cart cart = holded.dataHold.copyWith(
      idTransaction: holded.transactionId,
      shiftId: ref.read(shiftProvider).value?.id ?? holded.shiftId,
    );
    if (cart.holdAt == null) {
      cart = cart.copyWith(holdAt: DateTime.now());
    }
    state = cart;
  }

  void reopen(model.Cart cart) {
    state = cart;
  }

  Future<void> checkPromotionByOrder() async {
    List<CartPromotion> currentPromotions =
        List<CartPromotion>.from(state.promotions)
            .where((promo) => promo.type != 2)
            .toList();

    state = state.copyWith(promotions: currentPromotions);

    final promotions = await ref
        .read(promotionStreamProvider.notifier)
        .getActivePromotions(
            type: 2, requirementMinimumOrder: state.grandTotal);
    log('${promotions.length} PROMOTION BY ORDER: $promotions');

    if (promotions.isNotEmpty) {
      final promotion = promotions.first;
      double discountValue = promotion.discountType == true
          ? state.grandTotal * (promotion.rewardNominal / 100)
          : promotion.rewardNominal;

      log('APPLY PROMOTION BY ORDER => $discountValue \n ${promotion.rewardMaximumAmount}');

      if (promotion.discountType == false &&
          discountValue > promotion.rewardMaximumAmount!) {
        discountValue = promotion.rewardMaximumAmount!;
      }

      final cartPromo = CartPromotion.fromData(promotion)
          .copyWith(discountValue: discountValue);
      currentPromotions.add(cartPromo);
      state = state.copyWith(promotions: currentPromotions);
    }

    calculateCart();
  }
}
