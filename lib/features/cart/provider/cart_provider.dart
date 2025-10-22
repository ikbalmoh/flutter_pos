// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selleri/features/cart/model/cart.dart' as model show Cart;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/cart/model/cart_holded.dart';
import 'package:selleri/features/cart/model/cart_payment.dart';
import 'package:selleri/features/cart/model/cart_promotion.dart';
import 'package:selleri/features/cart/model/cart_voucher.dart';
import 'package:selleri/features/customer/model/customer.dart';
import 'package:selleri/features/customer/model/customer_group.dart';
import 'package:selleri/features/item/model/item.dart';
import 'package:selleri/features/item/model/item_cart.dart';
import 'package:selleri/features/item/model/item_cart_detail.dart';
import 'package:selleri/features/item/model/item_package.dart';
import 'package:selleri/features/item/model/item_variant.dart';
import 'package:selleri/features/outlet/model/outlet_config.dart';
import 'package:selleri/features/promotion/model/promotion.dart';
import 'package:selleri/features/table/model/table.dart';
import 'package:selleri/features/promotion/model/voucher.dart';
import 'package:selleri/features/transaction/api/transaction_api.dart';
import 'package:selleri/shared/objectbox.dart';
import 'package:selleri/features/auth/provider/auth_provider.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/promotion/provider/promotions_provider.dart';
import 'package:selleri/features/settings/provider/printer_provider.dart';
import 'package:selleri/features/shift/provider/shift_provider.dart';
import 'package:selleri/features/table/provider/tables_provider.dart';
import 'package:selleri/shared/utils/authorization_helper.dart';
import 'package:selleri/shared/utils/formater.dart';
import 'dart:developer';
import 'package:selleri/shared/utils/printer.dart' as util;

part 'cart_provider.g.dart';

@Riverpod(keepAlive: true)
class Cart extends _$Cart {
  @override
  model.Cart build() {
    return model.Cart.initial();
  }

  Future<void> initCart({
    String? customerName,
    String? idCustomer,
    List<CustomerGroup>? customerGroup,
  }) async {
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
        customerGroup: customerGroup,
        customerName: customerName,
        idCustomer: idCustomer,
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

  Future<void> addToCart(Item item, {ItemVariant? variant}) async {
    if (state.idTransaction == null &&
        (state.idOutlet == '' || state.shiftId == '' || state.items.isEmpty)) {
      await initCart(
        customerGroup: state.customerGroup,
        customerName: state.customerName,
        idCustomer: state.idCustomer,
      );
    }
    double itemStock = variant?.stockItem ?? item.stockItem;
    double onCartQty = qtyOnCart(item.idItem, idVariant: variant?.idVariant);
    if (onCartQty > 0) {
      return updateQty(item.idItem, idVariant: variant?.idVariant);
    }
    if (itemStock < 1 && item.stockControl) {
      throw 'out_of_stock'.tr();
    }
    String identifier =
        '${item.idItem}-${DateTime.now().millisecondsSinceEpoch}';
    String itemName = item.itemName;
    double itemPrice = variant?.itemPrice ?? item.itemPrice;

    if (item.isPackage) {
      final emptyItems = getEmptyItemPackages(item.packageItems);
      if (emptyItems.isNotEmpty) {
        throw 'x_stock_empty'.tr(args: [emptyItems.first.itemName]);
      }
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
      idCategory: item.idCategory,
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
    List<ItemCart> items = List<ItemCart>.from(state.items);
    items.add(itemCart);
    state = state.copyWith(items: items);
    calculateCart();
  }

  void addExtraItemCart(ItemCart item) async {
    if (state.idOutlet == '' || state.shiftId == '' || state.items.isEmpty) {
      await initCart(
        customerGroup: state.customerGroup,
        customerName: state.customerName,
        idCustomer: state.idCustomer,
      );
    }
    List<ItemCart> items = List<ItemCart>.from(state.items);
    items.add(item);
    state = state.copyWith(items: items, roundingValue: 0);
    calculateCart();
  }

  Future<void> removePromotion(String promotionId) async {
    CartPromotion? promotion =
        state.promotions.firstWhereOrNull((p) => p.promotionId == promotionId);

    if (promotion != null) {
      List<ItemCart> items = List<ItemCart>.from(state.items)
          .map((item) => item.isReward != true &&
                  item.promotion?.promotionId == promotionId
              ? item.copyWith(promotion: null)
              : item)
          .toList();

      // Remove item reward
      items.removeWhere((item) =>
          item.isReward == true && item.promotion?.promotionId == promotionId);

      List<CartPromotion> promotions = List.from(state.promotions);

      promotions.removeWhere((p) => p.promotionId == promotionId);
      state = state.copyWith(promotions: promotions, items: items);
    }
    calculateCart();
  }

  Future<void> updateQty(String idItem,
      {int? idVariant, bool increment = true}) async {
    final index = state.items
        .indexWhere((i) => i.idItem == idItem && i.idVariant == idVariant);

    if (index > -1) {
      final outlet = ref.read(outletProvider).value as OutletSelected;

      List<ItemCart> items = [...state.items];
      ItemCart itemCart = items[index];

      Item? item = objectBox.getItem(idItem);

      if (item == null) {
        throw 'x_not_found'.tr(args: ['item'.tr()]);
      }

      List<CartPromotion> promotions = List.from(state.promotions);
      if (itemCart.promotion != null) {
        itemCart = itemCart.copyWith(
          discount: 0,
          discountTotal: 0,
        );
      }

      ItemVariant? itemVariant = idVariant == null
          ? null
          : objectBox.getItemVariant(idItem: idItem, variantId: idVariant);

      double itemStock = itemVariant?.stockItem ?? item.stockItem;

      if (item.stockControl &&
          outlet.config.stockMinus == false &&
          itemCart.quantity + 1 > itemStock) {
        throw 'max_qty_x'.tr(args: [
          CurrencyFormat.currency(itemStock, decimalDigit: 2, symbol: false)
        ]);
      }

      double quantity =
          increment ? itemCart.quantity + 1 : itemCart.quantity - 1;
      double finalPrice = itemCart.price - itemCart.discountTotal;
      items[index] =
          itemCart.copyWith(quantity: quantity, total: quantity * finalPrice);
      state = state.copyWith(
          items: items, roundingValue: 0, promotions: promotions);
      if (itemCart.promotion != null) {
        removePromotion(itemCart.promotion!.promotionId);
      } else {
        calculateCart();
      }
    }
  }

  Future<void> updateItem(ItemCart itemCart) async {
    final outlet = ref.read(outletProvider).value as OutletSelected;

    final index =
        state.items.indexWhere((i) => i.identifier == itemCart.identifier);
    if (index > -1) {
      List<ItemCart> items = [...state.items];

      Item? item = objectBox.getItem(itemCart.idItem);

      if (item == null) {
        throw 'x_not_found'.tr(args: ['item'.tr()]);
      }

      ItemVariant? itemVariant = itemCart.idVariant == null
          ? null
          : objectBox.getItemVariant(
              idItem: itemCart.idItem, variantId: itemCart.idVariant!);

      double itemStock = itemVariant?.stockItem ?? item.stockItem;

      if (item.stockControl &&
          outlet.config.stockMinus == false &&
          itemCart.quantity > itemStock) {
        throw 'max_qty_x'.tr(args: [
          CurrencyFormat.currency(itemStock, decimalDigit: 2, symbol: false)
        ]);
      }

      double discount = itemCart.discount;
      double discountTotal = itemCart.discountTotal;
      if (itemCart.promotion != null) {
        discount = 0;
        discountTotal = 0;
      }
      double finalPrice = itemCart.price - discountTotal;
      double total = itemCart.quantity * finalPrice;
      items[index] = itemCart.copyWith(
        total: total,
        discount: discount,
        discountTotal: discountTotal,
      );
      state = state.copyWith(
        items: items,
        roundingValue: 0,
      );
      if (itemCart.promotion != null) {
        removePromotion(itemCart.promotion!.promotionId);
      } else {
        calculateCart();
      }
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
    state =
        state.copyWith(items: items, promotions: promotions, roundingValue: 0);
    calculateCart();
    return true;
  }

  double qtyOnCart(String idItem, {int? idVariant}) {
    List<double> qtyItems = state.items
        .where((i) => i.idItem == idItem && i.idVariant == idVariant)
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

  void setRoundingValue(double value) {
    state = state.copyWith(roundingValue: value);
    calculateCart();
  }

  void setDiscountTransaction(
      {required double discount, required bool discIsPercent}) {
    double discOverallTotal =
        discIsPercent ? state.subtotal * (discount / 100) : discount;
    state = state.copyWith(
      roundingValue: 0,
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
    final shift = ref.read(shiftProvider).value;

    payment = payment.copyWith(
      createdBy: auth.user.user.idUser,
      shiftId: shift?.id,
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
    state = state.copyWith(payments: payments);
    calculateCart();
  }

  void removePayment(String paymentMethodId) {
    List<CartPayment> payments = List<CartPayment>.from(state.payments);
    payments.removeWhere(
        (p) => p.paymentMethodId == paymentMethodId && p.createdAt == null);
    state = state.copyWith(payments: payments);
    calculateCart();
  }

  Future<void> printReceipt(
      {int printCounter = 1, bool? withKitchen = false}) async {
    try {
      log('PRINT RECEIPT $state');
      final printer = ref.read(printerProvider).value;
      if (printer == null) {
        throw 'printer_not_connected'.tr();
      }
      if (printCounter > 1) {
        final isAuthorize =
            await AuthorizationHelper.authorize('print-receipt');
        if (!isAuthorize) {
          return;
        }
      }
      final outlet = ref.read(outletProvider).value as OutletSelected;
      final AttributeReceipts? attributeReceipts =
          outlet.config.attributeReceipts;
      final receipt = await util.Printer.buildReceiptBytes(state,
          outlet: outlet.outlet,
          attributes: attributeReceipts,
          size: printer.size,
          isCopy: printCounter > 1,
          cut: printer.cut);
      await ref.read(printerProvider.notifier).print(receipt);
      if (withKitchen == true) {
        await printKitchen();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> printKitchen() async {
    try {
      final printer = ref.read(printerProvider).value;
      if (printer == null) {
        throw 'printer_not_connected'.tr();
      }
      final outlet = ref.read(outletProvider).value as OutletSelected;
      final AttributeReceipts? attributeReceipts =
          outlet.config.attributeReceipts;
      final receipt = await util.Printer.buildKitchenReceiptBytes(
        state,
        outlet: outlet.outlet,
        attributes: attributeReceipts,
        size: printer.size,
        cut: printer.cut,
      );
      await ref.read(printerProvider.notifier).print(receipt);
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
    final isAuthorize = await AuthorizationHelper.authorize('remove-hold');
    if (!isAuthorize) {
      return;
    }
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

        // log('ITEM GET PROMO: $itemCart');

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
      log('\nA GET B REWARD ITEM=>${reward.item.toString()}\n A GET B REWARD Variant=>${reward.variant.toString()}\n\n');
      if (reward.item != null) {
        for (ItemCart itemCart in eligibleItems) {
          int itemIdx = items.indexWhere(
            (item) => item.identifier == itemCart.identifier,
          );
          itemCart = ItemCart.copyWithPromotion(itemCart, promotion: promo);

          log('ITEM GET PROMO AB: $itemCart');

          items[itemIdx] = itemCart;
        }
        double rewardQty = promo.rewardQty?.toDouble() ?? 1;
        final double itemPromoQty = eligibleItems
            .map((item) => item.quantity)
            .reduce((value, total) => value + total);

        if (promo.kelipatan == true) {
          rewardQty = ((rewardQty * itemPromoQty) ~/ promo.requirementQuantity!)
              .toDouble();
        }
        ItemCart rewardItem = ItemCart.asReward(
          reward.item!,
          variant: reward.variant,
          promotion: promo,
          quantity: rewardQty,
        );
        items.add(rewardItem);
        cartPromotions.add(CartPromotion.fromData(promo));
      }
    }

    // PROMO BY CODE
    Promotion? promoByCode = promotions.firstWhereOrNull((p) => p.needCode);

    state = state.copyWith(
      items: items,
      promotions: cartPromotions,
      vouchers: [],
      subtotal: subtotal,
      promoCode: promoByCode?.promoCode,
    );

    calculateCart();
  }

  void applyVoucher(Voucher voucher) {
    if (voucher.voucherType == 'discount') {
      double voucherValue = voucher.isPercent
          ? state.subtotal * (voucher.discountValue / 100)
          : voucher.discountValue;
      state = state
          .copyWith(vouchers: [voucher.toCartVoucher(value: voucherValue)]);

      setDiscountTransaction(
          discIsPercent: voucher.isPercent, discount: voucher.discountValue);
    } else {
      double voucherValue = voucher.isPercent == true
          ? state.grandTotal * voucher.discountValue / 100
          : voucher.discountValue;
      state = state
          .copyWith(vouchers: [voucher.toCartVoucher(value: voucherValue)]);

      calculateCart();
    }
  }

  void removeVoucher() {
    CartVoucher? discountVoucher = state.vouchers
        .firstWhereOrNull((voucher) => voucher.voucherType == 'discount');
    state = state.copyWith(vouchers: []);
    if (discountVoucher != null) {
      setDiscountTransaction(discount: 0, discIsPercent: false);
    } else {
      calculateCart();
    }
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
            p.type == 2 &&
                (p.requirementMinimumOrder != null &&
                    p.requirementMinimumOrder! <= subtotal) ||
            activePromoByProductIds.contains(p.promotionId))
        .toList();

    CartVoucher? voucher =
        state.vouchers.isNotEmpty ? state.vouchers.first : null;

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
      if (voucher != null && voucher.voucherType == 'discount') {
        discOverallTotal = voucher.isPercent == true
            ? subtotal * (voucher.discountValue ?? 0) / 100
            : (voucher.discountValue ?? 0);
        voucher = voucher.copyWith(
          value: discOverallTotal,
        );
      }
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

    grandTotal += state.roundingValue;

    double totalMoneyPayment = state.payments.isNotEmpty
        ? state.payments
            .map((payment) => payment.paymentValue)
            .reduce((payment, total) => payment + total)
        : 0;

    double totalVoucherPayment = 0;
    if (voucher != null && voucher.voucherType == 'payment') {
      totalVoucherPayment = voucher.isPercent == true
          ? grandTotal * (voucher.discountValue ?? 0) / 100
          : (voucher.discountValue ?? 0);
      voucher = voucher.copyWith(
        value: totalVoucherPayment,
      );
    }

    double totalPayment = totalMoneyPayment + totalVoucherPayment;

    double change = totalPayment > grandTotal ? totalPayment - grandTotal : 0;

    state = state.copyWith(
      subtotal: subtotal,
      ppnTotal: ppnTotal,
      total: total,
      grandTotal: grandTotal,
      discOverallTotal: discOverallTotal,
      discPromotionsTotal: discPromotionsTotal,
      change: change,
      transactionDate: DateTime.now().millisecondsSinceEpoch,
      vouchers: voucher != null ? [voucher] : [],
      promotions: promotions,
      totalPayment: totalPayment,
    );
  }

  void setTables(List<Table> tables) async {
    if (state.transactionNo == '') {
      await initCart();
    }
    state = state.copyWith(
      tables: tables.map((table) => table.name).toList(),
    );
    ref.read(tablesProvider().notifier).markTables(state.transactionNo, tables);
  }
}
