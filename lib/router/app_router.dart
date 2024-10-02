import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/providers/app_start/app_start_provider.dart';
import 'package:selleri/providers/app_start/app_start_state.dart';
import 'package:selleri/ui/screens/holded/holded_screen.dart';
import 'package:selleri/ui/screens/promotions/promotions_screen.dart';
import 'package:selleri/ui/screens/settings/about_app_screen.dart';
import 'package:selleri/ui/screens/settings/account_information_screen.dart';
import 'package:selleri/ui/screens/settings/auto_print_screen.dart';
import 'package:selleri/ui/screens/settings/setting_screen.dart';
import 'package:selleri/ui/screens/settings/sync_screen.dart';
import 'package:selleri/ui/screens/shift/shift_history_detail.dart';
import 'package:selleri/ui/screens/shift/shift_screen.dart';
import 'package:selleri/ui/screens/splash/splash_screen.dart';
import 'package:selleri/ui/screens/login/login_screen.dart';
import 'package:selleri/ui/screens/select_outlet/select_outlet_screen.dart';
import 'package:selleri/ui/screens/home/home_screen.dart';
import 'package:selleri/ui/screens/cart/cart_screen.dart';
import 'package:selleri/ui/screens/checkout/checkout_screen.dart';
import 'package:selleri/ui/screens/customer/customer_screen.dart';
import 'package:selleri/ui/screens/settings/printer/printer_setting_screen.dart';
import 'package:selleri/ui/screens/transaction_history/transaction_history_screen.dart';

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
      log('NEXT ROUTE STATE: $next');
      appState.value = next;
    });

  return GoRouter(
      navigatorKey: key,
      initialLocation: Routes.root,
      routes: [
        GoRoute(
          name: Routes.root,
          path: Routes.root,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          name: Routes.login,
          path: Routes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          name: Routes.outlet,
          path: Routes.outlet,
          builder: (context, state) => const SelectOutletScreen(),
        ),
        GoRoute(
          name: Routes.home,
          path: Routes.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          name: Routes.customers,
          path: Routes.customers,
          builder: (context, state) => const CustomerScreen(),
        ),
        GoRoute(
          path: Routes.cart,
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          name: Routes.checkout,
          path: Routes.checkout,
          builder: (context, state) => const CheckoutScreen(),
        ),
        GoRoute(
          name: Routes.promotions,
          path: Routes.promotions,
          builder: (context, state) => const PromotionsScreen(),
        ),
        GoRoute(
          name: Routes.printers,
          path: Routes.printers,
          builder: (context, state) => const PrinterSettingScreen(),
        ),
        GoRoute(
          name: Routes.holded,
          path: Routes.holded,
          builder: (context, state) => const HoldedScreen(),
        ),
        GoRoute(
          name: Routes.transactions,
          path: Routes.transactions,
          builder: (context, state) => const TransactionHistoryScreen(),
        ),
        GoRoute(
          name: Routes.shift,
          path: Routes.shift,
          builder: (context, state) => const ShiftScreen(),
        ),
        GoRoute(
          name: Routes.shiftDetail,
          path: '${Routes.shift}/:id',
          builder: (context, state) {
            final String shiftId = state.pathParameters['id'] ?? '';
            return ShiftHistoryDetailScreen(shiftId: shiftId);
          },
        ),
        GoRoute(
          name: Routes.settings,
          path: Routes.settings,
          builder: (context, state) => const SettingScreen(),
        ),
        GoRoute(
          name: Routes.autoPrint,
          path: Routes.autoPrint,
          builder: (context, state) => const AutoPrintScreen(),
        ),
        GoRoute(
          name: Routes.syncData,
          path: Routes.syncData,
          builder: (context, state) => const SyncScreen(),
        ),
        GoRoute(
          name: Routes.account,
          path: Routes.account,
          builder: (context, state) => const AccountInformationScreen(),
        ),
        GoRoute(
          name: Routes.about,
          path: Routes.about,
          builder: (context, state) => const AboutAppScreen(),
        ),
      ],
      refreshListenable: appState,
      redirect: (context, state) {
        final currentRoute = state.topRoute?.path;

        log('ROUTE STATE:\napp : ${appState.value.asData}\nroute: ${state.topRoute}');

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

        log('ROUTE: current = $currentRoute | redirect = $redirectRoute | should redirect = $shouldRedirect');

        if (shouldRedirect) {
          return redirectRoute;
        }

        return null;
      });
}
