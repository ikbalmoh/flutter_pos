import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/ui/components/update_patcher.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final shorebirdCodePush = ShorebirdCodePush();

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
          .read(authNotifierProvider.notifier)
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
    shorebirdCodePush.currentPatchNumber().then((value) {
      if (value != null) {
        setState(() {
          patch = value;
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);
    ref.listen(authNotifierProvider, (prev, next) {
      if (next.value is AuthFailure) {
        AppAlert.snackbar(
          context,
          (next.value as AuthFailure).message,
          alertType: AlertType.error,
        );
      }
    });
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: SizedBox(
                    width: 300,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/icon.png',
                            height: 50,
                            width: 200,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 40),
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
                                  MediaQuery.of(context).viewInsets.bottom + 10,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'enter_username'.tr();
                              }
                              return null;
                            },
                            onEditingComplete: () =>
                                _passwordNode.requestFocus(),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 15),
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
                                  MediaQuery.of(context).viewInsets.bottom + 10,
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
                          const SizedBox(height: 20),
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
                                : const Icon(Icons.login),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'v$buildNumber-$patch',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const UpdatePatcher()
              ],
            ),
            Text(
              'v$buildNumber-$patch',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(
              height: 20,
            ),
            const UpdatePatcher()
          ],
        ),
      ),
    );
  }
}
