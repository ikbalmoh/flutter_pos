import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:selleri/modules/auth/auth.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController authController = Get.find();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
      TextEditingController(text: kDebugMode ? 'admin.staging@dgti.com' : '');
  final TextEditingController _passwordController =
      TextEditingController(text: kDebugMode ? '12345678' : '');

  final FocusNode _passwordNode = FocusNode();

  bool hidePassword = true;

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      authController.login(_emailController.text, _passwordController.text);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: SafeArea(
          child: Center(
            child: SizedBox(
              width: 300,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'selleri',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: Colors.teal.shade400,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Email"),
                      controller: _emailController,
                      scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'enter_email'.tr;
                        } else if (!value.isEmail) {
                          return 'enter_valid_email'.tr;
                        }
                        return null;
                      },
                      onEditingComplete: () => _passwordNode.requestFocus(),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Password",
                      ),
                      controller: _passwordController,
                      obscureText: hidePassword,
                      scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'enter_password'.tr;
                        }
                        return null;
                      },
                      focusNode: _passwordNode,
                      onEditingComplete: _submitLogin,
                      textInputAction: TextInputAction.go,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: authController.state is AuthLoading
                          ? null
                          : _submitLogin,
                      label: Text('login'.tr),
                      icon: authController.state is AuthLoading
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
        ),
      ),
    );
  }
}
