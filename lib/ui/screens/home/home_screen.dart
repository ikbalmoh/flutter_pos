import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/models/item.dart';
import 'package:selleri/modules/auth/auth.dart';
import 'package:selleri/modules/item/item.dart';
import 'package:selleri/modules/outlet/outlet.dart';
import './components/item_categories.dart';
import 'package:selleri/ui/components/item_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = Get.find();
  final ItemController itemController = Get.find();
  final OutletController outletController = Get.find();

  String idCategory = '';
  Stream<List<Item>> itemStrem = objectBox.itemsStream();

  void onChangeCategory(String id) => setState(() {
        idCategory = id;
        itemStrem = objectBox.itemsStream(idCategory: id);
      });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (authController.state is Authenticated) {
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
            mainAxisSize: MainAxisSize.max,
            children: [
              ItemCategories(
                active: idCategory,
                onChange: onChangeCategory,
              ),
              Expanded(
                child: ItemContainer(
                  stream: itemStrem,
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
