import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:selleri/data/models/cart_holded.dart';
import 'package:selleri/data/models/pagination.dart';
import 'package:selleri/utils/fetch.dart';
import 'package:selleri/config/api_url.dart';

class TransactionApi {
  final Dio api;

  TransactionApi({required this.api});

  Future<List<dynamic>> storeTransaction(Cart cart) async {
    try {
      final FormData formData = await cart.toTransactionFormData();
      log('TRANSACTION FIELDS: ${formData.fields}');
      log('TRANSACTION FILES: ${formData.files}');
      final res = await api.post(
        ApiUrl.transaction,
        data: formData,
        options: Options(
          contentType: Headers.multipartFormDataContentType,
        ),
      );

      return res.data['data'];
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }

  Future<Pagination<Cart>> transactions(
      {required String idOutlet, int? page, String? q, String? shiftId}) async {
    try {
      final Map<String, dynamic> params = {
        'id_outlet': idOutlet,
        'q': q,
        'page': page,
        'shift_id': shiftId,
      };
      final res = await api.get(ApiUrl.transaction, queryParameters: params);
      final data = res.data['data'];
      final pagination = Pagination<Cart>.fromJson(data, (transaction) {
        return Cart.fromTransaction(transaction as Map<String, dynamic>);
      });

      return pagination;
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }

  Future<Pagination<CartHolded>> holdedTransactions(
      {required String idOutlet, int? page, String? q}) async {
    try {
      final Map<String, dynamic> params = {
        'id_outlet': idOutlet,
        'q': q,
        'page': page
      };
      final res = await api.get(ApiUrl.hold, queryParameters: params);
      final data = res.data['data'];
      final pagination = Pagination<CartHolded>.fromJson(data, (holded) {
        return CartHolded.fromJson(holded as Map<String, dynamic>);
      });

      return pagination;
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }

  Future holdTransaction(Cart cart) async {
    try {
      final json = cart.toJson();
      final List<Map<String, dynamic>> data = [json];
      final res = await api.post(ApiUrl.hold, data: data);

      return res.data['data'];
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }

  Future deleteHoldedTransaction(String transactionId) async {
    try {
      await api.delete('${ApiUrl.hold}/$transactionId');
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }

  Future updateHoldTransaction(String transactionId, Cart cart) async {
    try {
      var json = cart.toJson();
      json['transaction_id'] = transactionId;
      final List<Map<String, dynamic>> data = [json];
      final res = await api.put('${ApiUrl.hold}/$transactionId', data: data);

      return res.data['data'];
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      throw Exception(e);
    }
  }
}

final transactionApiProvider = Provider<TransactionApi>((ref) {
  final api = ref.watch(apiProvider);
  return TransactionApi(api: api);
});
