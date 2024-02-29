import 'package:flutter/material.dart';
import 'package:selleri/models/item.dart';
import 'package:selleri/utils/formater.dart';

class ShopItem extends StatelessWidget {
  final Item item;
  const ShopItem({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                color: Colors.grey.shade200,
              ),
              child: item.image != null && item.image != ''
                  ? Image.network(
                      item.image!,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Text(
                        item.itemName.substring(0, 3).toUpperCase(),
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: Colors.grey.shade400,
                                ),
                      ),
                    ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
              color: Colors.white,
            ),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemName,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(CurrencyFormat.idr(item.itemPrice, 0))
              ],
            ),
          )
        ],
      ),
    );
  }
}
