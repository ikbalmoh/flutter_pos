import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selleri/modules/auth/auth.dart';
import 'package:selleri/modules/item/item.dart';
import 'package:selleri/modules/outlet/outlet.dart';
import './components/item_categories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = Get.find();
  final ItemController itemController = Get.find();
  final OutletController outletController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (authController.state is Authenticated) {
        Authenticated state = authController.state as Authenticated;
        return Scaffold(
          appBar: AppBar(
            title: Text(outletController.activeOutlet.value?.outletName ?? ''),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert_rounded),
              )
            ],
          ),
          body: Column(
            children: [
              const ItemCategories(),
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
