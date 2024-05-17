import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/providers/app_start/app_start_provider.dart';
import 'package:selleri/providers/app_start/app_start_state.dart';

import 'package:selleri/ui/screens/splash/splash_screen.dart';
import 'package:selleri/ui/screens/login/login_screen.dart';
import 'package:selleri/ui/screens/select_outlet/select_outlet_screen.dart';
import 'package:selleri/ui/screens/home/home_screen.dart';
import 'package:selleri/ui/screens/cart/cart_screen.dart';
import 'package:selleri/ui/screens/checkout/checkout_screen.dart';

import 'routes.dart';

part 'app_router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  final key = GlobalKey<NavigatorState>();

  final appState =
      ValueNotifier<AsyncValue<AppStartState>>(const AsyncLoading());

  ref
    ..onDispose(appState.dispose)
    ..listen(appStartNotifierProvider, (_, next) {
      appState.value = next;
    });

  return GoRouter(
      navigatorKey: key,
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
      refreshListenable: appState,
      redirect: (context, state) {
        final currentRoute = state.topRoute?.path;

        if (kDebugMode) {
          print(
              'ROUTE STATE:\napp : ${appState.value.asData}\nroute: ${state.topRoute}');
        }

        if (appState.value.isLoading) {
          return null;
        }

        final redirectRoute = appState.value.when(
          data: (appState) {
            final redirectRoute = appState.maybeWhen(
              initializing: () => Routes.root,
              authenticated: () => Routes.outlet,
              selectedOutlet: () => [Routes.root, Routes.login, Routes.outlet]
                      .contains(currentRoute)
                  ? Routes.home
                  : null,
              unauthenticated: () => Routes.login,
              orElse: () => Routes.login,
            );
            return redirectRoute;
          },
          error: (e, stack) => Routes.login,
          loading: () => Routes.root,
        );

        final shouldRedirect = redirectRoute != null
            ? (currentRoute != null && currentRoute != redirectRoute)
            : false;

        if (kDebugMode) {
          print(
              'ROUTE: current = $currentRoute | redirect = $redirectRoute | should redirect = $shouldRedirect');
        }

        if (shouldRedirect) {
          return redirectRoute;
        }

        return null;
      });
}
