import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/features/item/model/category.dart' as model;
import 'package:selleri/features/item/model/item.dart';
import 'package:selleri/features/item/provider/item_provider.dart';
import 'package:selleri/shared/objectbox.dart';
import 'package:selleri/features/item/provider/category_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/shared/utils/formater.dart';
import 'package:selleri/shared/widget/error_handler.dart';

class ItemCategories extends ConsumerWidget {
  final String active;
  final FilterStock? filterStock;
  final bool? itemLoading;
  final void Function(String idCategory) onChange;

  const ItemCategories({
    required this.active,
    this.filterStock,
    this.itemLoading,
    required this.onChange,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider(onlyHasItems: true));

    var loadingSkeleton = ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      itemBuilder: (context, _) {
        return Container(
          width: 100,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(25),
          ),
        );
      },
      itemCount: 10,
    );

    if (itemLoading == true) {
      return loadingSkeleton;
    }

    return categories.when(
        data: (value) {
          List<model.Category> categories = value.where((c) {
            final items =
                ref.watch(itemsProvider(idCategory: c.idCategory)).value;
            if (items != null && items.isNotEmpty) {
              return true;
            }
            return false;
          }).toList();
          return SizedBox(
            height: 55,
            width: double.infinity,
            child: ListView.builder(
              itemCount: categories.length + 2,
              itemBuilder: (context, idx) {
                model.Category category = idx == 0
                    ? model.Category(
                        id: 0,
                        idCategory: '',
                        code: 'all',
                        categoryName: 'all'.tr(),
                        isActive: active == '',
                      )
                    : idx == 1
                        ? model.Category(
                            id: 1,
                            idCategory: 'promo',
                            code: 'promo',
                            categoryName: 'promotion'.tr(),
                            isActive: active == 'promo',
                          )
                        : categories[idx - 2];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: ActionChip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: active == category.idCategory
                        ? Colors.teal.shade400
                        : category.idCategory == 'promo'
                            ? Colors.amber.shade100.withValues(alpha: 0.5)
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
                        if (category.idCategory == 'promo') ...[
                          Icon(
                            Icons.discount,
                            size: 16,
                            color: active == category.idCategory
                                ? Colors.white
                                : Colors.amber.shade700,
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                        Text(
                          category.categoryName,
                        ),
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
                                filterStock: filterStock,
                                isPromo: category.idCategory == 'promo',
                              ),
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
          );
        },
        error: (error, stackTrace) => ErrorHandler(
              error: error,
              stackTrace: stackTrace.toString(),
            ),
        loading: () => loadingSkeleton);
  }
}
