import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/app/provider/app_start_provider.dart';
import 'package:selleri/app/provider/app_start_state.dart';
import 'package:selleri/features/adjustment/widget/adjustment_history_screen.dart';
import 'package:selleri/features/holded/widget/holded_screen.dart';
import 'package:selleri/features/item/widget/add_item_screen.dart';
import 'package:selleri/features/item/widget/manage_item_variants_screen.dart';
import 'package:selleri/features/notification/widget/notification_screen.dart';
import 'package:selleri/features/promotion/widget/promotions_screen.dart';
import 'package:selleri/features/receiving/widget/receiving_history_screen.dart';
import 'package:selleri/features/receiving/widget/receiving_screen.dart';
import 'package:selleri/features/settings/widget/about_app_screen.dart';
import 'package:selleri/features/settings/widget/account_information_screen.dart';
import 'package:selleri/features/settings/widget/auto_print_screen.dart';
import 'package:selleri/features/settings/widget/setting_screen.dart';
import 'package:selleri/features/settings/widget/sync_screen.dart';
import 'package:selleri/features/settings/widget/outlet_config_screen.dart';
import 'package:selleri/features/shift/widget/shift_history_detail.dart';
import 'package:selleri/features/shift/widget/shift_screen.dart';
import 'package:selleri/app/widget/splash_screen.dart';
import 'package:selleri/features/auth/widget/login_screen.dart';
import 'package:selleri/features/auth/widget/reset_password_screen.dart';
import 'package:selleri/features/outlet/widget/select_outlet_screen.dart';
import 'package:selleri/features/pos/widget/pos_screen.dart';
import 'package:selleri/features/cart/widget/cart_screen.dart';
import 'package:selleri/features/pos/widget/checkout/checkout_screen.dart';
import 'package:selleri/features/customer/widget/customer_screen.dart';
import 'package:selleri/features/settings/widget/printer/printer_setting_screen.dart';
import 'package:selleri/features/transaction/widget/transaction_history_screen.dart';
import 'package:selleri/features/adjustment/widget/adjustment_screen.dart';
import 'package:selleri/features/table/widget/tables_screen.dart';
import 'package:selleri/shared/utils/authorization_helper.dart';

import 'routes.dart';

part 'app_router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final appState =
      ValueNotifier<AsyncValue<AppStartState>>(const AsyncLoading());

  ref
    ..onDispose(appState.dispose)
    ..listen(appStartProvider, (_, next) {
      log('NEXT ROUTE STATE: $next');
      appState.value = next;
    });

  return GoRouter(
      navigatorKey: AuthorizationHelper.navigatorKey,
      initialLocation: Routes.root,
      overridePlatformDefaultLocation: true,
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
          name: Routes.resetPassword,
          path: Routes.resetPassword,
          builder: (context, state) => const ResetPasswordScreen(),
        ),
        GoRoute(
          name: Routes.outlet,
          path: Routes.outlet,
          builder: (context, state) => const SelectOutletScreen(),
        ),
        GoRoute(
          name: Routes.home,
          path: Routes.home,
          builder: (context, state) => const PosScreen(),
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
          path: Routes.tables,
          builder: (context, state) => const TablesScreen(),
        ),
        GoRoute(
          name: Routes.checkout,
          path: Routes.checkout,
          builder: (context, state) => const CheckoutScreen(
            isPartialPayment: false,
          ),
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
          name: Routes.adjustments,
          path: Routes.adjustments,
          builder: (context, state) => const AdjustmentScreen(),
        ),
        GoRoute(
          name: Routes.adjustmentsHistory,
          path: Routes.adjustmentsHistory,
          builder: (context, state) => const AdjustmentHistoryScreen(),
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
        GoRoute(
          name: Routes.outletConfig,
          path: Routes.outletConfig,
          builder: (context, state) => const OutletConfigScreen(),
        ),
        GoRoute(
          name: Routes.addItem,
          path: Routes.addItem,
          builder: (context, state) => const AddItemScreen(),
        ),
        GoRoute(
          name: Routes.manageVariant,
          path: '${Routes.manageVariant}/:idItem',
          builder: (context, state) {
            final String idItem = state.pathParameters['idItem'] ?? '';
            return ManageItemVariantsScreen(idItem: idItem);
          },
        ),
        GoRoute(
          name: Routes.receiving,
          path: '${Routes.receiving}/:type/:code',
          builder: (context, state) => ReceivingScreen(
            type: state.pathParameters['type']?.toString() ?? '1',
            code: state.pathParameters['code']?.toString() ?? '0',
          ),
        ),
        GoRoute(
          name: Routes.receivingHistory,
          path: Routes.receivingHistory,
          builder: (context, state) => const ReceivingHistoryScreen(),
        ),
        GoRoute(
          name: Routes.notificaitons,
          path: Routes.notificaitons,
          builder: (context, state) => const NotificationScreen(),
        ),
      ],
      debugLogDiagnostics: true,
      refreshListenable: appState,
      redirect: (context, state) {
        final currentRoute = state.topRoute?.path;

        if (appState.value.isLoading) {
          return null;
        }

        final redirectRoute = appState.value.when(
          data: (appState) {
            final redirectRoute = appState.maybeWhen(
              initializing: () => Routes.root,
              authenticated: () => Routes.outlet,
              selectingOutlet: () => [Routes.root, Routes.login, Routes.resetPassword].contains(currentRoute) ? Routes.outlet : null,
              selectedOutlet: () => [
                Routes.root,
                Routes.login,
                Routes.resetPassword,
                Routes.outlet
              ].contains(currentRoute)
                  ? Routes.home
                  : null,
              unauthenticated: () =>
                  [Routes.login, Routes.resetPassword].contains(currentRoute)
                      ? null
                      : Routes.login,
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

        if (shouldRedirect) {
          return redirectRoute;
        }

        return null;
      });
}
