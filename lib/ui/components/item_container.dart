import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selleri/models/item.dart';
import 'package:selleri/ui/components/shop_item.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ItemContainer extends StatelessWidget {
  final Stream<List<Item>> stream;

  const ItemContainer({required this.stream, super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);
    return StreamBuilder<List<Item>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              List<Item> items = snapshot.data!;
              return GridView.count(
                crossAxisCount: isTablet ? 4 : 2,
                childAspectRatio: 0.9,
                padding: const EdgeInsets.all(7.5),
                crossAxisSpacing: 7.5,
                mainAxisSpacing: 7.5,
                children: List.generate(
                  items.length,
                  (index) => ShopItem(item: items[index]),
                ),
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.bag,
                    size: 60,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'no_items'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.grey),
                  )
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
