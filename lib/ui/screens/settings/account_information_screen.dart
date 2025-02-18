import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/helpers.dart';

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
        padding: const EdgeInsets.all(0),
        children: authState is Authenticated
            ? [
                ListTile(
                  title: Text('full_name'.tr()),
                  subtitle: Text(authState.user.user.name),
                  tileColor: Colors.white,
                ),
                ListTile(
                  dense: true,
                  title: const Text('Email'),
                  subtitle: Text(authState.user.user.email),
                  tileColor: Colors.white,
                  trailing: IconButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () => Helpers.copy(authState.user.user.email,
                        message: 'x_copied'.tr(args: ['email'])),
                    icon: Icon(
                      Icons.copy,
                      size: 15,
                      color: Colors.grey,
                    ),
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
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
                  trailing: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Helpers.copy(
                        authState.user.user.company.companyEmail ?? '',
                        message: 'x_copied'.tr(args: ['company_email'.tr()])),
                    icon: Icon(
                      Icons.copy,
                      size: 15,
                      color: Colors.grey,
                    ),
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
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
