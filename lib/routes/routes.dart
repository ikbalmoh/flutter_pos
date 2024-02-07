import 'package:get/get.dart' show GetPage;

import 'package:selleri/modules/auth/auth.dart';
import 'package:selleri/modules/outlet/outlet.dart';
import 'package:selleri/modules/item/item.dart';

import 'package:selleri/screens/splash/splash_screen.dart';
import 'package:selleri/screens/login/login_screen.dart';
import 'package:selleri/screens/select_outlet/select_outlet_screen.dart';
import 'package:selleri/screens/home/home_screen.dart';

class Routes {
  static const String root = '/';
  static const String login = '/login';
  static const String outlet = '/outlet';
  static const String home = '/home';
}

List<GetPage> routes = [
  GetPage(
    name: Routes.root,
    page: () => const SplashScreen(),
    bindings: [OutletBindings(), AuthBindings()],
  ),
  GetPage(
    name: Routes.login,
    page: () => const LoginScreen(),
    bindings: [OutletBindings(), AuthBindings()],
  ),
  GetPage(
    name: Routes.outlet,
    page: () => const SelectOutletScreen(),
    binding: OutletBindings(),
  ),
  GetPage(
    name: Routes.home,
    page: () => const HomeScreen(),
    bindings: [OutletBindings(), ItemBindings()],
  ),
];
