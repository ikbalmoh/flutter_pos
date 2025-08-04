import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

enum Status { waiting, downloading, downloaded }

final _shorebirdCodePush = ShorebirdUpdater();

class UpdatePatch extends StatefulWidget {
  const UpdatePatch({super.key});

  @override
  State<UpdatePatch> createState() => _UpdatePatchState();
}

class _UpdatePatchState extends State<UpdatePatch> {
  bool downloading = false;
  bool downloaded = false;

  void downloadUpdate() async {
    setState(() {
      downloading = true;
    });
    await Future.wait([
      _shorebirdCodePush.update(),
      Future<void>.delayed(const Duration(milliseconds: 250)),
    ]);
    setState(() {
      downloading = false;
      downloaded = true;
    });
  }

  void onRestart() {
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
            downloaded ? 'update_applied'.tr() : 'update_available'.tr(),
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            downloaded ? 'please_restart'.tr() : 'update_note'.tr(),
            style: textTheme.bodySmall?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          downloaded
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: onRestart,
                  child: Text('restart'.tr()),
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: downloading ? null : downloadUpdate,
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
  void checkUpdate() async {
    final status = await _shorebirdCodePush.checkForUpdate();
    if (status == UpdateStatus.outdated) {
      Future.delayed(
        Duration.zero,
            () {
          if (context.mounted) {
            showModalBottomSheet(
              // ignore: use_build_context_synchronously
              context: context,
              backgroundColor: Colors.white,
              builder: (context) {
                return const UpdatePatch();
              },
              isDismissible: false,
              enableDrag: false,
            );
          }
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkUpdate());
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
