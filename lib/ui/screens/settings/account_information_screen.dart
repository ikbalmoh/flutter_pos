import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/utils/app_alert.dart';

class AccountInformationScreen extends StatelessWidget {
  const AccountInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('account_info'.tr()),
      ),
      body: const AccountInformation(),
    );
  }
}

class AccountInformation extends ConsumerWidget {
  const AccountInformation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onSignOut() {
      AppAlert.confirm(
        context,
        title: 'logout_confirmation'.tr(),
        onConfirm: () {
          ref.read(authProvider.notifier).logout();
        },
        confirmLabel: 'logout'.tr(),
      );
    }

    final authState = ref.read(authProvider).value;
    return Scaffold(
      body: ListView(
        children: authState is Authenticated
            ? [
                ListTile(
                  title: Text('full_name'.tr()),
                  subtitle: Text(authState.user.user.name),
                  tileColor: Colors.white,
                ),
                ListTile(
                  title: const Text('Email'),
                  subtitle: Text(authState.user.user.email),
                  tileColor: Colors.white,
                ),
                ListTile(
                  title: Text('phone'.tr()),
                  tileColor: Colors.white,
                ),
                ListTile(
                  title: Text('company'.tr()),
                  subtitle: Text(authState.user.user.company.companyName),
                  tileColor: Colors.white,
                ),
                ListTile(
                  title: Text('company_email'.tr()),
                  subtitle:
                      Text(authState.user.user.company.companyEmail ?? ''),
                  tileColor: Colors.white,
                ),
              ]
            : [],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onSignOut,
        label: Text('logout'.tr()),
        backgroundColor: Colors.red,
        icon: const Icon(CupertinoIcons.square_arrow_left),
      ),
    );
  }
}
