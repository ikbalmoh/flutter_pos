import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/config/api_url.dart';
import 'package:selleri/data/models/notification/notification.dart';
import 'package:selleri/utils/fetch.dart';

class NotificationApi {
  final Dio api;

  const NotificationApi({required this.api});

  Future<List<Notification>> notificationList(
      {required String idOutlet}) async {
    try {
      final params = {"id_outlet": idOutlet};
      final res = await api.get(ApiUrl.notifications, queryParameters: params);
      List<Map<String, dynamic>> listJson = List.from(res.data['data']);
      final List<Notification> data =
          listJson.map((json) => Notification.fromJson(json)).toList();
      return data;
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }
}

final notificationApiProvider = Provider<NotificationApi>((ref) {
  final api = ref.watch(apiProvider);
  return NotificationApi(api: api);
});
