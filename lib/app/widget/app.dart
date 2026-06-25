import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/app/widget/app_theme.dart';
import 'package:selleri/features/cart/model/cart.dart';
import 'package:selleri/features/fcm/provider/fcm_provider.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/transaction/provider/offline_transactions_provider.dart';
import 'package:selleri/shared/provider/connectivity_status_provider.dart';
import 'package:selleri/shared/router/app_router.dart';
import 'package:selleri/shared/utils/app_alert.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();

    // Initialize FCM once — reading the provider triggers its build()
    // which sets up listeners for auth/outlet changes internally.
    ref.read(fcmProvider);

    // Listen for connectivity changes and sync offline transactions when
    // back online. Registered once here to avoid duplicate listeners on rebuild.
    ref.listenManual<ConnectivityState>(
      connectivityStatusProvider,
      (previous, next) {
        if (previous == ConnectivityState.disconnected &&
            next == ConnectivityState.connected) {
          ref.read(offlineTransactionsProvider.notifier).syncBackground();
        }
      },
    );

    // Listen for offline transactions becoming available while connected.
    // We read connectivity fresh inside the callback to avoid stale closures.
    ref.listenManual(
      offlineTransactionsProvider,
      (previous, next) {
        final isConnected = ref.read(connectivityStatusProvider) ==
            ConnectivityState.connected;
        if (next is AsyncData<List<Cart>> &&
            next.value.isNotEmpty &&
            isConnected &&
            next.value != previous?.value) {
          ref.read(offlineTransactionsProvider.notifier).syncOfflineTransactions();
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Lock orientation based on shortest screen side.
    // Called here (not in build) to avoid repeated platform-channel calls
    // on every rebuild.
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    if (shortestSide < 451) {
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
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    final outlet = ref.watch(outletProvider).value;
    if (outlet is OutletSelected) {
      context.setLocale(
        outlet.config.locale == 'en'
            ? const Locale('en', 'US')
            : const Locale('id', 'ID'),
      );
    }

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
