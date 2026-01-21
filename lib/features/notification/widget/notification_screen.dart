import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide AppBar;
import 'package:selleri/app/widget/app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/features/notification/provider/notification_provider.dart';
import 'package:selleri/shared/widget/app_drawer/app_drawer.dart';
import 'package:selleri/shared/widget/error_handler.dart';
import 'package:selleri/shared/widget/generic/item_list_skeleton.dart';
import 'package:selleri/shared/utils/app_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:selleri/features/notification/model/notification.dart' as model;

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void openNotification(model.Notification notif) async {
      ref.read(notificationProvider.notifier).markAsReaded(notif.id);

      final String? link = notif.data?.link;
      if (link != null) {
        final Uri url = Uri.parse(link.replaceFirst('://', ':/'));
        while (context.canPop()) {
          context.pop();
        }
        if (!await launchUrl(url)) {
          AppAlert.toast('Could not launch $url');
        }
      }
    }

    return VisibilityDetector(
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0) {
          ref.read(notificationProvider.notifier).loadNotifications();
        }
      },
      key: const Key('notif-screen-visible-detector'),
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: Text('notification'.tr()),
          elevation: 3,
          automaticallyImplyLeading: false,
          leading: Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          }),
        ),
        body: RefreshIndicator(
          child: ref.watch(notificationProvider).when(
                data: (data) {
                  return ListView.builder(
                    itemBuilder: (context, idx) {
                      final notif = data[idx];
                      return ListTile(
                        enabled: notif.isReaded != true,
                        title: Text(notif.title),
                        dense: true,
                        subtitle: Text(notif.body),
                        tileColor: notif.isReaded == true
                            ? Colors.white
                            : Colors.red.shade50,
                        onTap: () => openNotification(notif),
                        trailing: notif.data?.link != null
                            ? Icon(
                                CupertinoIcons.chevron_right,
                                size: 16,
                                color: Colors.blueGrey.shade500,
                              )
                            : null,
                        shape: Border(
                          bottom:
                              BorderSide(width: 1, color: Colors.grey.shade100),
                        ),
                      );
                    },
                    itemCount: data.length,
                  );
                },
                error: (error, stackTrace) => ErrorHandler(
                  error: error.toString(),
                  stackTrace: stackTrace.toString(),
                ),
                loading: () => ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, _) => const ItemListSkeleton(),
                ),
              ),
          onRefresh: () =>
              ref.read(notificationProvider.notifier).loadNotifications(),
        ),
      ),
    );
  }
}
