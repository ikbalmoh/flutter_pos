import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/data/repository/outlet_repository.dart';
import 'package:selleri/data/network/api.dart' show ItemApi;

part 'item_repository.g.dart';

@riverpod
ItemRepository itemRepository(ItemRepositoryRef ref) => ItemRepository(ref);

abstract class ItemRepositoryProtocol {
  Future<List<Category>> fetchCategoris();
  Future<List<Item>> fetchItems(String idCategory);
}

class ItemRepository implements ItemRepositoryProtocol {
  ItemRepository(this.ref);

  final Ref ref;

  final api = ItemApi();

  late final outletState = ref.read(outletRepositoryProvider);

  @override
  Future<List<Category>> fetchCategoris() async {
    final storedCategories = objectBox.categories();
    if (storedCategories.isNotEmpty) {
      return storedCategories;
    }
    try {
      final outlet = await outletState.retrieveOutlet();
      if (outlet == null) {
        [];
      }
      final data = await api.categories(outlet!.idOutlet);
      final categories = List<Category>.from(
          data['data'].map((json) => Category.fromJson(json)));
      objectBox.putCategories(categories);
      return categories;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    } on PlatformException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<List<Item>> fetchItems(String idCategory) async {
    try {
      final outlet = await outletState.retrieveOutlet();
      if (outlet == null) {
        [];
      }
      final data = await api.items(outlet!.idOutlet, idCategory: idCategory);
      return List<Item>.from(data['data'].map((json) => Item.fromJson(json)));
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    } on PlatformException catch (e) {
      throw Exception(e.message);
    }
  }
}
