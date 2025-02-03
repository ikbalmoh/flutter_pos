// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'package:collection/collection.dart';
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
import 'package:selleri/data/models/item_package.dart';
import 'package:selleri/data/models/item_variant.dart';
import 'package:selleri/data/models/outlet_config.dart';
import 'package:selleri/data/models/promotion.dart';
import 'package:selleri/data/network/transaction.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/providers/promotion/promotions_provider.dart';
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
      if (ref.read(authProvider).value is! Authenticated) {
        return;
      }

      final outletState = ref.read(outletProvider).value as OutletSelected;

      final authState = await ref.read(authProvider.future) as Authenticated;

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

    ItemCart itemCart = ItemCart.fromItem(item, variant: variant);

    if (item.isPackage) {
      final emptyItems = getEmptyItemPackages(item.packageItems);
      if (emptyItems.isNotEmpty) {
        AppAlert.toast('x_stock_empty'.tr(args: [emptyItems.first.itemName]));
        return;
      }
    }

    final int cartIndex =
        state.items.indexWhere((i) => i.identifier == itemCart.identifier);

    if (cartIndex > -1) {
      final ItemCart existItem = state.items[cartIndex];
      return updateItem(existItem.copyWith(quantity: existItem.quantity + 1));
    }

    if (kDebugMode) {
      log('ADD TO CART: $itemCart');
    }
    List<ItemCart> items = List<ItemCart>.from(state.items)
        .where((item) => item.isReward != true)
        .toList();
    items.add(itemCart);
    state = state.copyWith(items: items);
    calculateCart();
  }

  void addItemCart(ItemCart item) {
    List<ItemCart> items = List<ItemCart>.from(state.items);
    items.add(item);
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
      double discount = item.discount;
      double discountTotal = item.discountTotal;
      if (item.promotion != null) {
        discount = 0;
        discountTotal = 0;
      }
      double finalPrice = item.price - discountTotal;
      double total = item.quantity * finalPrice;
      items[index] = item.copyWith(
        total: total,
        discount: discount,
        discountTotal: discountTotal,
        promotion: null,
      );
      state = state.copyWith(items: items);
      calculateCart();
    }
  }

  Future<bool> removeItem(String identifier) async {
    List<ItemCart> items = [...state.items];
    List<CartPromotion> promotions = [...state.promotions];
    ItemCart item = items.firstWhere((item) => item.identifier == identifier);
    items.removeWhere((i) =>
        i.identifier == item.identifier ||
        (i.isReward == true &&
            i.promotion?.promotionId == item.promotion?.promotionId));
    promotions.removeWhere(
      (p) => p.idItem == item.idItem && p.variantId == item.idVariant,
    );
    state = state.copyWith(items: items, promotions: promotions);
    calculateCart();
    return true;
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
      customerName: customer.customerName,
      idCustomer: customer.idCustomer,
      customerGroup: customer.groups,
    );
    applyPromotions([]);
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

  Future<void> setPic(PersonInCharge? pic) {
    state = state.copyWith(personInCharge: pic?.id);
    return Future.delayed(const Duration(milliseconds: 200));
  }

  void addPayment(CartPayment payment) {
    final auth = ref.read(authProvider).value as Authenticated;

    payment = payment.copyWith(
      createdBy: auth.user.user.idUser,
      payDate: (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
    );

    List<CartPayment> payments = List<CartPayment>.from(state.payments);
    int paymentIdx = payments.indexWhere((cp) =>
        cp.createdAt == null && cp.paymentMethodId == payment.paymentMethodId);

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
      final api = ref.watch(transactionApiProvider);

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
    final api = ref.watch(transactionApiProvider);
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
    log('OPEN HOLDED CART $holded');
    final outletState = ref.read(outletProvider).value as OutletSelected;

    final tax = outletState.config.tax;
    final taxable = outletState.config.taxable ?? false;

    model.Cart cart = holded.dataHold.copyWith(
      idTransaction: holded.transactionId,
      ppn: tax?.percentage ?? 0,
      ppnIsInclude: tax?.isInclude ?? true,
      taxName: taxable ? tax?.taxName : '',
      shiftId: ref.read(shiftProvider).value?.id ?? holded.shiftId,
      holdAt: holded.dataHold.holdAt ?? DateTime.now(),
      promotions: [],
      items: [],
    );

    List<ItemCart> items = [];
    for (ItemCart item in holded.dataHold.items) {
      if (item.promotion != null) {
        item = item.copyWith(
          discountTotal: 0,
          discount: 0,
          discountIsPercent: true,
          total: item.price * item.quantity,
        );
      }
      items.add(item);
    }

    state = cart.copyWith(items: items);

    List<Promotion> promotions = objectBox.getPromotions(
            holded.dataHold.promotions.map((p) => p.promotionId).toList()) ??
        [];
    if (promotions.isNotEmpty) {
      applyPromotions(promotions);
    } else {
      calculateCart();
    }
  }

  void removeHoldedCart() async {
    final api = ref.watch(transactionApiProvider);
    String idTransaction = state.idTransaction!;
    initCart();
    await api.deleteHoldedTransaction(idTransaction);
  }

  void reopen(model.Cart cart) {
    state = cart;
  }

  Future<void> checkPromotionByOrder() async {
    if (state.promotions.isNotEmpty) {
      return;
    }

    final promotion = await ref
        .read(promotionsProvider.notifier)
        .getPromotionByOrder(requirementMinimumOrder: state.grandTotal);

    if (promotion != null) {
      bool isPromotionAdded = state.promotions
          .where((p) => p.promotionId == promotion.idPromotion)
          .isNotEmpty;

      if (isPromotionAdded) {
        return;
      }

      List<CartPromotion> currentPromotions =
          List<CartPromotion>.from(state.promotions)
              .where((promo) => promo.type != 2)
              .toList();

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
      state = state.copyWith(
        promotions: currentPromotions,
        discOverall: 0,
        discOverallTotal: 0,
      );
    }

    calculateCart();
  }

  void applyPromotions(List<Promotion> selectedPromotions) {
    log('APPLY PROMOTIONS: $selectedPromotions');

    List<Promotion> promotions = [];
    for (Promotion promo in selectedPromotions) {
      bool isEligible =
          ref.read(promotionsProvider.notifier).isPromotionEligible(promo);
      if (isEligible) {
        promotions.add(promo);
      }
    }

    List<ItemCart> items = List<ItemCart>.from(state.items)
        .where((item) => item.isReward != true)
        .map((item) => item.promotion == null
            ? item
            : item.copyWith(
                promotion: null,
                discountTotal: 0,
                discount: 0,
                total: item.price * item.quantity,
              ))
        .toList();

    List<Promotion> freeGiftpromotions =
        promotions.where((promo) => promo.type == 1).toList();

    Promotion? promotionByOrder =
        promotions.firstWhereOrNull((promo) => promo.type == 2);

    List<Promotion> promotionByProducts =
        promotions.where((promo) => promo.type == 3).toList();

    log('ELIGIBLE PROMOTIONS\n1 => FREE GIFT\n$freeGiftpromotions\n2 => BY ORDER\n$promotionByOrder\n3 => BY PRODUCTS\n$promotionByProducts');

    List<CartPromotion> cartPromotions = [];

    // PROMO BY PRODUCT
    for (var i = 0; i < promotionByProducts.length; i++) {
      Promotion promo = promotionByProducts[i];

      CartPromotion cartPromo = CartPromotion.fromData(promo);

      List<ItemCart> eligibleItems =
          ref.read(promotionsProvider.notifier).eligibleItems(promo, items);

      if (eligibleItems.isEmpty) {
        continue;
      }

      for (ItemCart itemCart in eligibleItems) {
        int itemIdx = items.indexWhere(
          (item) => item.identifier == itemCart.identifier,
        );
        itemCart = ItemCart.copyWithPromotion(itemCart, promotion: promo);

        log('ITEM GET PROMO: $itemCart');

        cartPromotions.add(cartPromo);
        items[itemIdx] = itemCart;
      }
    }

    double subtotal = items.isNotEmpty
        ? items.map((i) => i.total).reduce((value, total) => value + total)
        : 0;

    // PROMO BY ORDER
    if (promotionByOrder != null) {
      CartPromotion cartPromo = CartPromotion.fromData(promotionByOrder);
      // PROMO BY TRANSACTION
      double discountValue = cartPromo.discountIsPercent
          ? subtotal * (promotionByOrder.rewardNominal / 100)
          : promotionByOrder.rewardNominal;

      if (promotionByOrder.rewardMaximumAmount != null &&
          promotionByOrder.rewardMaximumAmount! > 0 &&
          discountValue > promotionByOrder.rewardMaximumAmount!) {
        discountValue = promotionByOrder.rewardMaximumAmount!;
      }

      cartPromotions.add(cartPromo.copyWith(discountValue: discountValue));
    }

    // PROMO A GET B
    for (var i = 0; i < freeGiftpromotions.length; i++) {
      List<ItemCart> eligibleItems = ref
          .read(promotionsProvider.notifier)
          .eligibleItems(freeGiftpromotions[i], items);
      log('A GET B eligible items: $eligibleItems');
      if (eligibleItems.isEmpty) {
        continue;
      }
      // Apply Rewards
      Promotion promo = freeGiftpromotions[i];
      ScanItemResult? reward = objectBox.getPromotionReward(promotion: promo);
      log('REWARD\n ITEM=>${reward.item.toString()}\n Variant=>${reward.variant.toString()}');
      if (reward.item != null) {
        for (ItemCart itemCart in eligibleItems) {
          int itemIdx = items.indexWhere(
            (item) => item.identifier == itemCart.identifier,
          );
          itemCart = ItemCart.copyWithPromotion(itemCart, promotion: promo);

          log('ITEM GET PROMO AB: $itemCart');

          items[itemIdx] = itemCart;
        }
        items.add(ItemCart.fromItem(
          reward.item!,
          variant: reward.variant,
          promotion: promo,
          isReward: true,
        ));
        cartPromotions.add(CartPromotion.fromData(promo));
      }
    }

    // PROMO BY CODE
    Promotion? promoByCode = promotions.firstWhereOrNull((p) => p.needCode);

    state = state.copyWith(
      items: items,
      promotions: cartPromotions,
      subtotal: subtotal,
      promoCode: promoByCode?.promoCode,
    );

    calculateCart();
  }

  List<CartPromotion> activePromotion() {
    List<CartPromotion> promotions = [];
    for (var promo in state.promotions) {
      int index =
          promotions.indexWhere((p) => p.promotionId == promo.promotionId);
      if (index < 0) {
        promotions.add(promo);
      } else {
        promotions[index] = promotions[index].copyWith(
            discountValue:
                promotions[index].discountValue + promo.discountValue);
      }
    }
    return promotions;
  }

  void setPromotionCode(String code) {
    state = state.copyWith(promoCode: code);
  }

  void calculateCart() {
    List<String> activePromoByProductIds = state.items
        .where((item) => item.promotion != null)
        .map((item) => item.promotion!.promotionId)
        .toList();

    double? subtotal = state.items.isNotEmpty
        ? state.items
            .map((i) => i.total)
            .reduce((value, total) => value + total)
        : 0;

    List<CartPromotion> promotions = List<CartPromotion>.from(state.promotions)
        .where((p) =>
            p.type == 2 && p.requirementMinimumOrder! <= subtotal ||
            activePromoByProductIds.contains(p.promotionId))
        .toList();

    double discOverallTotal = 0;
    double discPromotionsTotal = 0;

    int promoByOrderIndex = promotions.indexWhere((p) => p.type == 2);
    if (promoByOrderIndex >= 0) {
      CartPromotion promoByOrder = promotions[promoByOrderIndex];
      discPromotionsTotal = promoByOrder.discountIsPercent
          ? subtotal * (promoByOrder.discountNominal / 100)
          : promoByOrder.discountNominal;
      promotions[promoByOrderIndex] =
          promoByOrder.copyWith(discountValue: discPromotionsTotal);
    } else if (state.discOverall > 0) {
      discOverallTotal = state.discIsPercent
          ? subtotal * (state.discOverall / 100)
          : state.discOverall;
    }

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
      promotions: promotions,
    );
  }
}
