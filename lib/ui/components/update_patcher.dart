
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
          Text('update_available'.tr(),
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text('update_note'.tr(),
            style: textTheme.bodySmall?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
            ),
            onPressed: restart,
            child: Text('apply_update'.tr()),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class UpdatePatcher extends StatefulWidget {
  const UpdatePatcher({super.key});

  @override
  State<UpdatePatcher> createState() => _UpdatePatcherState();
}

class _UpdatePatcherState extends State<UpdatePatcher> {
  final shorebirdCodePush = ShorebirdCodePush();

  void checkUpdate() async {
    final available = await shorebirdCodePush.isNewPatchAvailableForDownload();
    if (!available) {
      return;
    }
    await shorebirdCodePush.downloadUpdateIfAvailable();
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

  @override
  void initState() {
    checkUpdate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
