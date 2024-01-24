import 'package:get/get.dart' show GetPage;
import 'package:selleri/screens/login/login_screen.dart';

class Routes {
  static const String root = '/';
  static const String login = '/login';
  static const String home = '/home';
}

List<GetPage> routes = [
  GetPage(
    name: Routes.login,
    page: () => const LoginScreen(),
  ),
];
