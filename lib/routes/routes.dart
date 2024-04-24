import 'package:get/get.dart' show GetPage, Transition;

import 'package:selleri/modules/auth/auth.dart';
import 'package:selleri/modules/cart/cart.dart';
import 'package:selleri/modules/outlet/outlet.dart';
import 'package:selleri/modules/item/item.dart';

import 'package:selleri/ui/screens/splash/splash_screen.dart';
import 'package:selleri/ui/screens/login/login_screen.dart';
import 'package:selleri/ui/screens/select_outlet/select_outlet_screen.dart';
import 'package:selleri/ui/screens/home/home_screen.dart';
import 'package:selleri/ui/screens/cart/cart_screen.dart';
import 'package:selleri/ui/screens/checkout/checkout_screen.dart';

class Routes {
  static const String root = '/';
  static const String login = '/login';
  static const String outlet = '/outlet';
  static const String home = '/home';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
}

List<GetPage> routes = [
  GetPage(
    name: Routes.root,
    page: () => const SplashScreen(),
    binding: AuthBindings(),
    transition: Transition.fade,
  ),
  GetPage(
    name: Routes.login,
    page: () => const LoginScreen(),
    bindings: [AuthBindings()],
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: Routes.outlet,
    page: () => const SelectOutletScreen(),
    bindings: [AuthBindings()],
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: Routes.home,
    page: () => const HomeScreen(),
    bindings: [AuthBindings(), ItemBindings(), CartBindings()],
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: Routes.cart,
    page: () => const CartScreen(),
    bindings: [CartBindings()],
    transition: Transition.rightToLeft,
  ),
  GetPage(
    name: Routes.checkout,
    page: () => const CheckoutScreen(),
    transition: Transition.rightToLeft,
    bindings: [CartBindings()]
  ),
];
