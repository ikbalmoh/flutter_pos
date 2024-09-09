import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/sold_item.dart';
import 'package:selleri/utils/formater.dart';

class SoldItems extends StatelessWidget {
  final List<SoldItem> items;
  const SoldItems({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'item_sold'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: 18,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: items.isNotEmpty
                    ? SoldItemsList(
                        items: items,
                        scrollController: scrollController,
                      )
                    : const EmptySoldItemsPlaceholder(),
              )
            ],
          ),
        );
      },
    );
  }
}

class EmptySoldItemsPlaceholder extends StatelessWidget {
  const EmptySoldItemsPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            size: 40,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'there_is_no'.tr(args: ['item_sold'.tr().toLowerCase()]),
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class SoldItemsList extends StatelessWidget {
  const SoldItemsList({
    super.key,
    required this.items,
    this.scrollController,
  });

  final List<SoldItem> items;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, idx) {
        SoldItem item = items[idx];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          title: Text(item.name),
          titleTextStyle: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.w400),
          minTileHeight: 0,
          trailing: Text(
            CurrencyFormat.currency(
              item.sold,
              symbol: false,
            ),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 0,
          thickness: 0.5,
          color: Colors.blueGrey.shade100,
        );
      },
    );
  }
}
