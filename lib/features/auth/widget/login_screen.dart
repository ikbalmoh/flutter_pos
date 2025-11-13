import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/features/auth/provider/auth_provider.dart';
import 'package:selleri/shared/router/routes.dart';
import 'package:selleri/shared/widget/update_patcher.dart';
import 'package:selleri/shared/utils/app_alert.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final shorebirdCodePush = ShorebirdUpdater();

  final TextEditingController _usernameController =
      TextEditingController(text: kDebugMode ? 'admin.staging@dgti.com' : '');
  final TextEditingController _passwordController =
      TextEditingController(text: kDebugMode ? '12345678' : '');

  final FocusNode _passwordNode = FocusNode();

  String buildNumber = '';
  int patch = 0;

  bool hidePassword = true;

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authProvider.notifier)
          .login(_usernameController.text, _passwordController.text);
    }
  }

  @override
  void initState() {
    PackageInfo.fromPlatform().then((packageInfo) {
      log('INFO: $packageInfo');
      setState(() {
        buildNumber = packageInfo.version;
      });
    });
    shorebirdCodePush.readCurrentPatch().then((currentPatch) {
      if (currentPatch != null) {
        setState(() {
          patch = currentPatch.number;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  void onTapRegister() async {
    final Uri url = Uri.parse('https://selleri.co.id/register');
    if (!await launchUrl(url)) {
      AppAlert.toast('Could not open $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);
    ref.listen(authProvider, (prev, next) {
      if (next.value is AuthFailure) {
        AppAlert.snackbar(
          (next.value as AuthFailure).message,
          alertType: AlertType.error,
        );
      }
    });
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: isTablet ? 350 : MediaQuery.of(context).size.width - 50,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 15,
                            children: [
                              const SizedBox(height: 5),
                              Image.asset(
                                'assets/images/icon.png',
                                height: 50,
                                width: 200,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 25),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Username",
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 15,
                                  ),
                                  alignLabelWithHint: false,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.teal.shade400,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.red.shade400,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.teal.shade400,
                                    ),
                                  ),
                                ),
                                controller: _usernameController,
                                scrollPadding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                          10,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'enter_email'.tr();
                                  }
                                  return null;
                                },
                                onEditingComplete: () =>
                                    _passwordNode.requestFocus(),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  suffix: GestureDetector(
                                    onTap: () => setState(() {
                                      hidePassword = !hidePassword;
                                    }),
                                    child: Icon(
                                      hidePassword
                                          ? CupertinoIcons.eye_slash_fill
                                          : CupertinoIcons.eye_solid,
                                      size: 18,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  labelText: "Password",
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 15,
                                  ),
                                  alignLabelWithHint: false,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.teal.shade400,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.red.shade400,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.teal.shade400,
                                    ),
                                  ),
                                ),
                                controller: _passwordController,
                                obscureText: hidePassword,
                                scrollPadding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                          10,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'enter_password'.tr();
                                  }
                                  return null;
                                },
                                focusNode: _passwordNode,
                                onEditingComplete: _submitLogin,
                                textInputAction: TextInputAction.go,
                              ),
                              ElevatedButton.icon(
                                onPressed: state.value is Authenticating
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          _submitLogin();
                                        }
                                      },
                                label: Text('login'.tr()),
                                icon: state.value is Authenticating
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.login,
                                        color: Colors.white,
                                      ),
                              )
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              context.pushNamed(Routes.resetPassword),
                          child: Text('forgot_password'.tr()),
                        ),
                        isTablet
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 0,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      'no_account'.tr(),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.grey,
                                          ),
                                    ),
                                  ),
                                  if (Platform.isAndroid)
                                    TextButton.icon(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.teal.shade50,
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 15),
                                      ),
                                      onPressed: onTapRegister,
                                      icon: Icon(CupertinoIcons.chevron_right),
                                      iconAlignment: IconAlignment.end,
                                      label: Text(
                                        'register'.tr(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                ],
                              )
                            : SizedBox(
                                width: double.maxFinite,
                                child: TextButton.icon(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.teal.shade50,
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 15),
                                  ),
                                  onPressed: onTapRegister,
                                  icon: Icon(CupertinoIcons.chevron_right),
                                  iconAlignment: IconAlignment.end,
                                  label: Text(
                                    'register'.tr(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'v$buildNumber-$patch',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              const UpdatePatcher()
            ],
          ),
        ),
      ),
    );
  }
}
