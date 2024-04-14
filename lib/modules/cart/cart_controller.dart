import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:selleri/models/item.dart';
import 'package:selleri/models/item_cart.dart';
import 'package:selleri/models/cart.dart';
import 'package:selleri/models/item_variant.dart';
import 'package:selleri/models/outlet.dart';
import 'package:selleri/models/user.dart';
import 'package:selleri/modules/auth/auth.dart';
import 'package:selleri/modules/outlet/outlet.dart';

class CartController extends GetxController {
  OutletController outletController = Get.find();
  AuthController authController = Get.find();

  final GetStorage box = GetStorage();

  final _cart = Rxn<Cart>();

  Cart? get cart => _cart.value;

  int get totalQty => cart?.items.length ?? 0;

  @override
  void onInit() {
    initNewCart();
    super.onInit();
  }

  void initNewCart() {
    int timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toInt();
    UserAccount user = (authController.state as Authenticated).user.user;
    Outlet outlet = outletController.activeOutlet.value!;
    String transactionNo =
        'BILL-${outlet.outletCode}-${user.idUser.substring(9, 13)}-$timestamp';
    _cart.value = Cart(
      transactionDate: DateTime.now(),
      transactionNo: transactionNo,
      idOutlet: outletController.activeOutlet.value!.idOutlet,
      outletName: outletController.activeOutlet.value!.outletName,
      createdBy: user.idUser,
      createdName: user.name,
      items: [],
      subtotal: 0,
      total: 0,
      grandTotal: 0,
    );

    if (kDebugMode) {
      print('CART INITIALIZED $cart');
    }
  }

  void calculateCart() {
    double? subtotal = cart!.items.isNotEmpty
        ? cart?.items
            .map((i) => i.total)
            .reduce((value, total) => value + total)
        : 0;
    double total = 0;
    if (subtotal != null) {
      total = subtotal - (cart?.discOverallTotal ?? 0);
    }
    _cart.value?.subtotal = subtotal;
    _cart.value?.total = total;
    _cart.value?.grandTotal = total;
    _cart.refresh();
  }

  void addToCart(Item item, {ItemVariant? variant}) {
    String identifier = item.idItem;
    String itemName = item.itemName;
    if (item.isPackage) {
      identifier += (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    } else if (variant != null) {
      identifier += '-v${variant.idVariant.toString()}';
    }
    int idx = _cart.value!.items.indexWhere((i) => i.identifier == identifier);

    if (idx > -1) return addQty(identifier);

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
    _cart.value!.items.add(itemCart);
    _cart.refresh();
    calculateCart();
  }

  void addQty(String identifier) {
    int idx = _cart.value!.items.indexWhere((i) => i.identifier == identifier);
    ItemCart item = _cart.value!.items[idx];
    int quantity = item.quantity + 1;
    item.quantity = quantity;
    item.total = item.price * quantity;
    _cart.value!.items[idx] = item;
    _cart.refresh();
    calculateCart();
  }

  Future<int> updateCartItem(ItemCart item) {
    int idx =
        _cart.value?.items.indexWhere((i) => i.identifier == item.identifier) ??
            -1;
    if (idx >= 0) {
      if (item.quantity > 0) {
        _cart.value?.items[idx] = item;
      } else {
        _cart.value?.items.removeAt(idx);
      }
      _cart.refresh();
      calculateCart();
    }
    return Future(() => _cart.value!.items.length);
  }

  int qtyOnCart(String idItem) {
    List<int> qtyItems = cart?.items
            .where((i) => i.idItem == idItem)
            .map((i) => i.quantity)
            .toList() ??
        [];
    return qtyItems.isNotEmpty
        ? qtyItems.reduce((qty, total) => qty + total)
        : 0;
  }
}
