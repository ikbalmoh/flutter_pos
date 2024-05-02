import 'package:flutter/material.dart';
import 'package:selleri/data/objectbox.dart' show objectBox;
import 'package:selleri/data/models/category.dart';

class ItemCategories extends StatefulWidget {
  final String active;
  final void Function(String idCategory) onChange;

  const ItemCategories({required this.active, required this.onChange, super.key});

  @override
  State<ItemCategories> createState() => _ItemCategoriesState();
}

class _ItemCategoriesState extends State<ItemCategories> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: double.infinity,
      child: StreamBuilder(
        stream: objectBox.categoriesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Category> categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length + 1,
              itemBuilder: (context, idx) {
                Category category = idx == 0
                    ? Category(
                        id: 0,
                        idCategory: '',
                        code: 'all',
                        categoryName: 'All',
                        isActive: widget.active == '',
                        )
                    : categories[idx - 1];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: TextButton(
                    onPressed: () => widget.onChange(category.idCategory),
                    style: TextButton.styleFrom(
                      foregroundColor:
                          widget.active == category.idCategory
                              ? Colors.white
                              : Colors.teal.shade400,
                      backgroundColor:
                          widget.active == category.idCategory
                              ? Colors.teal.shade400
                              : Colors.teal.shade50.withOpacity(0.5),
                    ),
                    child: Text(category.categoryName),
                  ),
                );
              },
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
            );
          }
          return ListView.builder(
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
          );
        },
      ),
    );
  }
}
