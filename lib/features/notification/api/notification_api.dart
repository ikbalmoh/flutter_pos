import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/shared/router/api_url.dart';
import 'package:selleri/features/notification/model/notification.dart';
import 'package:selleri/features/notification/repository/notification_repository.dart';
import 'package:selleri/shared/utils/fetch.dart';

class NotificationApi {
  final Dio api;
  final NotificationRepository repository;

  const NotificationApi({required this.api, required this.repository});

  Future<List<Notification>> notificationList(
      {required String idOutlet}) async {
    try {
      final params = {"id_outlet": idOutlet};
      final res = await api.get(ApiUrl.notifications, queryParameters: params);
      List<Map<String, dynamic>> listJson = List.from(res.data['data']);
      List<Notification> listData = [];
      for (var json in listJson) {
        Notification notif = Notification.fromJson(json);
        bool isReaded = false;
        if (notif.data != null) {
          isReaded = notif.data!.link == null;
        } else {
          isReaded = await repository.isReaded(notif.id);
        }
        notif = notif.copyWith(isReaded: isReaded);
        listData.add(notif);
      }
      return listData;
    } on DioException catch (e) {
      throw e.message!;
    } catch (e) {
      rethrow;
    }
  }
}

final notificationApiProvider = Provider<NotificationApi>((ref) {
  final api = ref.watch(apiProvider);
  final NotificationRepository repository =
      ref.watch(notificationRepositoryProvider);
  return NotificationApi(api: api, repository: repository);
});
