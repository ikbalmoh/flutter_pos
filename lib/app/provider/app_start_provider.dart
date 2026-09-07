import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:selleri/app/provider/app_start_state.dart';
import 'package:selleri/features/auth/provider/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'dart:developer';

import 'package:selleri/shared/provider/app_config_provider.dart';

part 'app_start_provider.g.dart';

@Riverpod(keepAlive: true)
class AppStart extends _$AppStart {
  bool isAuthenticated = false;
  bool outletSelected = false;

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  @override
  FutureOr<AppStartState> build() async {
    ref.onDispose(() {});

    await ref.read(appConfigProvider.future);

    final authState = ref.watch(authProvider);
    final outletState = ref.watch(outletProvider);

    isAuthenticated = authState.value is Authenticated;
    outletSelected = outletState.value is OutletSelected;

    log('AUTHENTICATED? $isAuthenticated');

    if (isAuthenticated && outletState.value is OutletLoading) {
      return const AppStartState.selectingOutlet();
    }

    if (isAuthenticated && outletSelected) {
      final auth = authState.value as Authenticated;
      final outlet = outletState.value as OutletSelected;

      crashlytics.setCustomKey('company_id', auth.user.user.company.idCompany);
      crashlytics.setCustomKey(
        'company_name',
        auth.user.user.company.companyName,
      );
      crashlytics.setCustomKey('outlet_id', outlet.outlet.idOutlet);
      crashlytics.setCustomKey('outlet_name', outlet.outlet.outletName);

      analytics.setUserProperty(
        name: 'outlet_name',
        value: outlet.outlet.outletName,
      );
      analytics.setUserProperty(
        name: 'outlet_id',
        value: outlet.outlet.idOutlet,
      );
      analytics.setUserProperty(
        name: 'company_name',
        value: auth.user.user.company.companyName,
      );
      analytics.setUserProperty(
        name: 'company_id',
        value: auth.user.user.company.idCompany,
      );
      return const AppStartState.selectedOutlet();
    }

    return authState.when(
      data: (state) async {
        if (state is Authenticated) {
          analytics.setUserId(id: state.user.user.idUser);
          analytics.setUserProperty(name: 'name', value: state.user.user.name);
          analytics.setUserProperty(
            name: 'email',
            value: state.user.user.email,
          );
          crashlytics.setUserIdentifier(state.user.user.idUser);
          crashlytics.setCustomKey('user_name', state.user.user.name);
          crashlytics.setCustomKey('user_email', state.user.user.email);
          return const AppStartState.authenticated();
        }
        return const AppStartState.unauthenticated();
      },
      error: (e, stack) => const AppStartState.unauthenticated(),
      loading: () => const AppStartState.initializing(),
    );
  }
}
