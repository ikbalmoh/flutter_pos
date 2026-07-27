import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/features/cart/model/cart.dart';
import 'package:selleri/shared/utils/formater.dart';

class HoldedBaner extends ConsumerWidget {
  final Cart cart;
  const HoldedBaner({required this.cart, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return cart.holdAt != null
        ? Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.amber.shade800,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cart.transactionNo,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  DateTimeFormater.dateToString(cart.holdAt!,
                      format: 'dd MMM, HH:mm'),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
