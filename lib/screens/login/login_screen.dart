import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 300,
            child: Form(
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
                    decoration: const InputDecoration(labelText: "Email"),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Password"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('login'.tr),
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
