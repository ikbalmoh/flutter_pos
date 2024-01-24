import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/services.dart';
import 'package:selleri/config/lang/lang.dart';
import 'package:selleri/config/theme.dart';
import 'package:selleri/routes/routes.dart';

class App extends StatelessWidget {
  final bool hasToken;

  const App({required this.hasToken, super.key});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.shortestSide < 451) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      enableLog: kDebugMode,
      title: 'Selleri',
      theme: appTheme(context),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        breakpoints: const [
          Breakpoint(start: 0, end: 450, name: MOBILE),
          Breakpoint(start: 451, end: 800, name: TABLET),
        ],
        child: child!,
      ),
      initialRoute: hasToken ? Routes.home : Routes.login,
      getPages: routes,
      translations: Languages(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('id', 'ID'),
    );
  }
}
