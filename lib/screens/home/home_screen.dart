import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selleri/modules/auth/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (authController.state is Authenticated) {
        Authenticated state = authController.state as Authenticated;
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(state.user.user.name),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () => authController.logout(),
                    child: Text('signout'.tr),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
