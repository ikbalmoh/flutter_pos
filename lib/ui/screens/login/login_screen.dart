import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:selleri/providers/auth/auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController =
      TextEditingController(text: kDebugMode ? 'admin.staging@dgti.com' : '');
  final TextEditingController _passwordController =
      TextEditingController(text: kDebugMode ? '12345678' : '');

  final FocusNode _passwordNode = FocusNode();

  bool hidePassword = true;

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      // SUBMIT
      ref
          .read(authNotifierProvider.notifier)
          .login(_usernameController.text, _passwordController.text);
    }
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
    final state = ref.read(authNotifierProvider);
    return Scaffold(
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
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.teal.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Userna"),
                    controller: _usernameController,
                    scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'enter username';
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
                        return 'enter_password';
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
                    label: const Text('Login'),
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
      ),
    );
  }
}
