// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/notification/model/notification.dart' as model;
import 'package:selleri/features/notification/api/notification_api.dart';
import 'package:selleri/features/notification/repository/notification_repository.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';

part 'notification_provider.g.dart';

@Riverpod(keepAlive: true)
class Notification extends _$Notification {
  @override
  FutureOr<List<model.Notification>> build() async {
    loadNotifications();
    return future;
  }

  Future<void> loadNotifications() async {
    try {
      state = AsyncLoading();
      final outlet = ref.watch(outletProvider).value as OutletSelected;
      final api = ref.watch(notificationApiProvider);
      final notifications =
          await api.notificationList(idOutlet: outlet.outlet.idOutlet);
      state = AsyncData(notifications);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  void markAsReaded(int id) {
    log('mark as readed $id');
    final notifications = state.value!
        .map((notif) => notif.id == id ? notif.copyWith(isReaded: true) : notif)
        .toList();
    state = AsyncData(notifications);
    ref.read(notificationRepositoryProvider).markAsReaded(id);
  }
}
