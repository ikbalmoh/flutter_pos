import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/services.dart';
import 'package:selleri/app/widget/app_theme.dart';
import 'package:selleri/features/cart/model/cart.dart';
import 'package:selleri/features/fcm/provider/fcm_provider.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/transaction/provider/offline_transactions_provider.dart';
import 'package:selleri/shared/router/app_router.dart';
import 'package:selleri/shared/utils/app_alert.dart';
import 'package:selleri/shared/provider/connectivity_status_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(connectivityStatusProvider) ==
        ConnectivityState.connected; //trigger rebuild

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

    final router = ref.watch(routerProvider);
    ref.read(fcmProvider.notifier).build();

    final outlet = ref.watch(outletProvider).value;
    if (outlet is OutletSelected) {
      context.setLocale(
        outlet.config.locale == 'en'
            ? const Locale('en', 'US')
            : const Locale('id', 'ID'),
      );
    }

    // Listen for connectivity changes and sync when back online
    ref.listen<ConnectivityState>(connectivityStatusProvider, (previous, next) {
      if (previous == ConnectivityState.disconnected &&
          next == ConnectivityState.connected) {
        ref.read(offlineTransactionsProvider.notifier).sync();
      }
    });

    ref.listen(offlineTransactionsProvider, (previous, next) {
      if (next is AsyncData<List<Cart>> &&
          next.value.isNotEmpty &&
          isConnected) {
        ref.read(offlineTransactionsProvider.notifier).sync();
      }
    });

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Selleri',
      theme: appTheme(context),
      scaffoldMessengerKey: AppAlert.rootScaffoldMessengerKey,
      routerConfig: router,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        breakpoints: const [
          Breakpoint(start: 0, end: 400, name: PHONE),
          Breakpoint(start: 401, end: 510, name: MOBILE),
          Breakpoint(start: 511, end: 800, name: TABLET),
          Breakpoint(start: 801, end: 1920, name: DESKTOP),
          Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
        child: child!,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
