import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/providers/notification/notification_provider.dart';
import 'package:selleri/ui/components/app_drawer/app_drawer.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/components/generic/item_list_skeleton.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void openNotification(String link) async {
      final Uri url = Uri.parse(link.replaceFirst('://', ':/'));
      while (context.canPop()) {
        context.pop();
      }
      if (!await launchUrl(url)) {
        AppAlert.toast('Could not launch $url');
      }
    }

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text('notification'.tr()),
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
                      title: Text(notif.title),
                      dense: true,
                      subtitle: Text(notif.body),
                      onTap: notif.data?.link != null
                          ? () => openNotification(notif.data!.link!)
                          : null,
                      trailing: notif.data?.link != null
                          ? Icon(
                              CupertinoIcons.chevron_right,
                              size: 16,
                              color: Colors.blueGrey.shade700,
                            )
                          : null,
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
    );
  }
}
