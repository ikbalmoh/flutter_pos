import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/services.dart';
import 'package:selleri/app/widget/app_theme.dart';
import 'package:selleri/features/fcm/provider/fcm_provider.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/shared/router/app_router.dart';
import 'package:selleri/shared/utils/app_alert.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
