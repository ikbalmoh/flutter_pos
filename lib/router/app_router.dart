import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:selleri/ui/screens/splash/splash_screen.dart';
import 'package:selleri/ui/screens/login/login_screen.dart';
import 'package:selleri/ui/screens/select_outlet/select_outlet_screen.dart';
import 'package:selleri/ui/screens/home/home_screen.dart';
import 'package:selleri/ui/screens/cart/cart_screen.dart';
import 'package:selleri/ui/screens/checkout/checkout_screen.dart';

import 'routes.dart';

part 'app_router.g.dart';

final _key = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
      navigatorKey: _key,
      initialLocation: Routes.root,
      routes: [
        GoRoute(
            path: Routes.root,
            builder: (context, state) => const SplashScreen()),
        GoRoute(
            path: Routes.login,
            builder: (context, state) => const LoginScreen()),
        GoRoute(
            path: Routes.outlet,
            builder: (context, state) => const SelectOutletScreen()),
        GoRoute(
            path: Routes.home, builder: (context, state) => const HomeScreen()),
        GoRoute(
            path: Routes.cart, builder: (context, state) => const CartScreen()),
        GoRoute(
            path: Routes.checkout,
            builder: (context, state) => const CheckoutScreen()),
      ],
    );
}
