import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:selleri/data/network/api.dart' show ItemApi;
import 'package:selleri/data/network/item.dart';
import 'package:selleri/data/models/category.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/data/models/item_package.dart';
import 'package:selleri/data/models/item_variant.dart';
import 'package:selleri/objectbox.g.dart';

class ItemService {
  final api = ItemApi();

  Future<List<Category>> categories(String idOutlet) async {
    try {
      final data = await api.categories(idOutlet);
      return List<Category>.from(
          data['data'].map((json) => Category.fromJson(json)));
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    } on PlatformException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<List<Item>> items(String idOutlet, String idCategory) async {
    try {
      final data = await api.items(idOutlet, idCategory: idCategory);
      return List<Item>.from(data['data'].map((json) {
        Item? existItem = objectBox.getItem(json['id_item']);
        json['id'] = existItem?.id ?? 0;
        json['variants'] = json['variants']?.map((variant) {
          ItemVariant? existVariant = objectBox.itemVariantBox.query(ItemVariant_.idVariant.equals(variant['id_variant'])).build().findFirst();
          variant['id'] = existVariant?.id ?? 0;
          return variant;
        }).toList();
        json['package_items'] = json['package_items']?.map((package) {
          ItemPackage? existPackage = objectBox.itemPackageBox.query(ItemPackage_.idItem.equals(package['id_item'])).build().findFirst();
          package['id'] = existPackage?.id ?? 0;
          return package;
        }).toList();
        return Item.fromJson(json);
      }));
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    } on PlatformException catch (e) {
      throw Exception(e.message);
    }
  }
}
