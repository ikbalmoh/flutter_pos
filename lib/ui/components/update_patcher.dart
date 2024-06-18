import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

enum Status { waiting, downloading, downloaded }

class UpdatePatch extends StatefulWidget {
  const UpdatePatch({super.key});

  @override
  State<UpdatePatch> createState() => _UpdatePatchState();
}

class _UpdatePatchState extends State<UpdatePatch> {
  final shorebirdCodePush = ShorebirdCodePush();

  Status updateStatus = Status.waiting;

  void applyUpdate() async {
    setState(() {
      updateStatus = Status.downloading;
    });
    await shorebirdCodePush.downloadUpdateIfAvailable();
    setState(() {
      updateStatus = Status.downloaded;
    });
  }

  void restart() {
    Restart.restartApp();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 15,
        right: 15,
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 15),
          Text(
            updateStatus == Status.downloaded
                ? 'update_applied'.tr()
                : 'update_available'.tr(),
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            updateStatus == Status.downloading
                ? 'please_wait'.tr()
                : updateStatus == Status.downloaded
                    ? 'please_restart'.tr()
                    : 'update_note'.tr(),
            style: textTheme.bodySmall?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
            ),
            onPressed: updateStatus == Status.downloading
                ? null
                : updateStatus == Status.downloaded
                    ? restart
                    : applyUpdate,
            icon: updateStatus == Status.downloading
                ? const SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      color: Colors.white,
                    ),
                  )
                : null,
            label: Text(updateStatus == Status.downloading
                ? 'downloading'.tr()
                : updateStatus == Status.downloaded
                    ? 'restart'.tr()
                    : 'apply_update'.tr()),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class UpdatePatcher extends StatelessWidget {
  const UpdatePatcher({super.key});

  @override
  Widget build(BuildContext context) {
    final shorebirdCodePush = ShorebirdCodePush();
    shorebirdCodePush.isNewPatchAvailableForDownload().then((updateAvailable) {
      log('SHOREBIRD UPDATE: $updateAvailable');
      if (updateAvailable && !context.canPop()) {
        Future.delayed(
          Duration.zero,
          () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              builder: (context) {
                return const UpdatePatch();
              },
              isDismissible: false,
              enableDrag: false,
            );
          },
        );
      }
    });
    return Container();
  }
}
