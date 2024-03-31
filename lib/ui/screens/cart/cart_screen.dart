import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selleri/models/item_cart.dart';
import 'package:selleri/modules/cart/cart.dart';
import 'package:selleri/routes/routes.dart';
import 'package:selleri/ui/components/cart_item.dart';
import 'package:selleri/ui/components/edit_cart_item.dart';
import 'package:selleri/utils/formater.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartController controller = Get.find();

  void onPressItem(ItemCart item) => Get.bottomSheet(EditCartItem(item: item));

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.blueGrey.shade50,
        appBar: AppBar(
          title: Text('cart'.tr.capitalizeFirst!),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, idx) {
                  ItemCart item = controller.cart!.items[idx];
                  return CartItem(
                    item: item,
                    onPress: onPressItem,
                  );
                },
                itemCount: controller.cart!.items.length,
              ),
            ),
            Card(
              color: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25))),
              margin: const EdgeInsets.all(0),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'subtotal'.tr.capitalizeFirst!,
                            style: TextStyle(color: Colors.blueGrey.shade700),
                          ),
                          Text(
                            CurrencyFormat.currency(controller.cart?.subtotal),
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            flex: 1,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                              ),
                              onPressed: () {},
                              child: Text('hold'.tr.toUpperCase()),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                              ),
                              onPressed: () => Get.toNamed(Routes.checkout),
                              icon: const Icon(CupertinoIcons.creditcard_fill),
                              label: Text('checkout'.tr.toUpperCase()),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
