import 'package:flutter/material.dart';
import 'package:selleri/data/models/category.dart';
import 'package:selleri/providers/item/category_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemCategories extends ConsumerWidget {
  final String active;
  final void Function(String idCategory) onChange;

  const ItemCategories(
      {required this.active, required this.onChange, super.key});

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
                      categoryName: 'All',
                      isActive: active == '',
                    )
                  : value[idx - 1];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: TextButton(
                  onPressed: () => onChange(category.idCategory),
                  style: TextButton.styleFrom(
                    foregroundColor: active == category.idCategory
                        ? Colors.white
                        : Colors.teal.shade400,
                    backgroundColor: active == category.idCategory
                        ? Colors.teal.shade400
                        : Colors.teal.shade50.withOpacity(0.5),
                  ),
                  child: Text(category.categoryName),
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
