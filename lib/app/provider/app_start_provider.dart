import 'package:selleri/app/provider/app_start_state.dart';
import 'package:selleri/features/auth/provider/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'dart:developer';

part 'app_start_provider.g.dart';

@Riverpod(keepAlive: true)
class AppStart extends _$AppStart {
  bool isAuthenticated = false;
  bool outletSelected = false;

  @override
  FutureOr<AppStartState> build() async {
    ref.onDispose(() {});

    final authState = ref.watch(authProvider);
    final outletState = ref.watch(outletProvider);

    isAuthenticated = authState.value is Authenticated;
    outletSelected = outletState.value is OutletSelected;

    log('AUTHENTICATED? $isAuthenticated');
    log('OUTLET STATE: ${outletState.value}');

    if (isAuthenticated && outletState.value is OutletLoading) {
      return const AppStartState.selectingOutlet();
    }

    if (isAuthenticated && outletSelected) {
      return const AppStartState.selectedOutlet();
    }

    return authState.when(
        data: (state) async {
          if (state is Authenticated) {
            return const AppStartState.authenticated();
          }
          return const AppStartState.unauthenticated();
        },
        error: (e, stack) => const AppStartState.unauthenticated(),
        loading: () => const AppStartState.initializing());
  }
}
