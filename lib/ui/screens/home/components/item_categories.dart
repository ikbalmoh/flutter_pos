import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/category.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/providers/item/category_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/utils/formater.dart';

class ItemCategories extends ConsumerWidget {
  final String active;
  final FilterStock? filterStock;
  final void Function(String idCategory) onChange;

  const ItemCategories({
    required this.active,
    this.filterStock,
    required this.onChange,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesStreamProvider);
    return switch (categories) {
      AsyncData(:final value) => SizedBox(
          height: 55,
          width: double.infinity,
          child: ListView.builder(
            itemCount: value.length + 1,
            itemBuilder: (context, idx) {
              Category category = idx == 0
                  ? Category(
                      id: 0,
                      idCategory: '',
                      code: 'all',
                      categoryName: 'all'.tr(),
                      isActive: active == '',
                    )
                  : value[idx - 1];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: ActionChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: active == category.idCategory
                      ? Colors.teal.shade400
                      : Colors.teal.shade50.withValues(alpha: 0.5),
                  labelStyle: TextStyle(
                    color: active == category.idCategory
                        ? Colors.white
                        : Colors.teal,
                  ),
                  onPressed: () => onChange(category.idCategory),
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(category.categoryName),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          CurrencyFormat.currency(
                            objectBox.getTotalItem(
                                idCategory: category.idCategory,
                                filterStock: filterStock),
                            symbol: false,
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                  side: const BorderSide(color: Colors.transparent),
                ),
              );
            },
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
          ),
        ),
      AsyncError(:final error) => Text(error.toString()),
      _ => ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
          itemBuilder: (context, _) {
            return Container(
              width: 100,
              height: 30,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
            );
          },
          itemCount: 10,
        ),
    };
  }
}
