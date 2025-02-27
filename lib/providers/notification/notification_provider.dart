// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/notification/notification.dart' as model;
import 'package:selleri/data/network/notification.dart';
import 'package:selleri/data/repository/notification_repository.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';

part 'notification_provider.g.dart';

@Riverpod()
class Notification extends _$Notification {
  @override
  FutureOr<List<model.Notification>> build() async {
    loadNotifications();
    return future;
  }

  loadNotifications() async {
    try {
      final outlet = ref.watch(outletProvider).value as OutletSelected;
      final api = ref.watch(notificationApiProvider);
      final notifications =
          await api.notificationList(idOutlet: outlet.outlet.idOutlet);
      state = AsyncData(notifications);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  markAsReaded(int id) {
    log('mark as readed $id');
    final notifications = state.value!
        .map((notif) => notif.id == id ? notif.copyWith(isReaded: true) : notif)
        .toList();
    state = AsyncData(notifications);
    ref.read(notificationRepositoryProvider).markAsReaded(id);
  }
}
