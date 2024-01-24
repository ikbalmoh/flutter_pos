import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:selleri/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  GetStorage box = GetStorage();

  runApp(App(
    hasToken: box.hasData('token'),
  ));
}
