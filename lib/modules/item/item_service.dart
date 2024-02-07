import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:selleri/data/network/api.dart' show ItemApi;
import 'package:selleri/data/network/item.dart';
import 'package:selleri/models/category.dart';

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
}
