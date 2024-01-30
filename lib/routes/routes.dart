import 'package:get/get.dart' show GetPage;

import 'package:selleri/modules/auth/auth.dart' show AuthBindings;

import 'package:selleri/screens/splash/splash_screen.dart';
import 'package:selleri/screens/login/login_screen.dart';
import 'package:selleri/screens/home/home_screen.dart';

class Routes {
  static const String root = '/';
  static const String login = '/login';
  static const String home = '/home';
}

List<GetPage> routes = [
  GetPage(
    name: Routes.root,
    page: () => const SplashScreen(),
    bindings: [AuthBindings()],
  ),
  GetPage(
    name: Routes.login,
    page: () => const LoginScreen(),
  ),
  GetPage(
    name: Routes.home,
    page: () => const HomeScreen(),
  ),
];
