import 'package:selleri/providers/app_start/app_start_state.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'dart:developer';


part 'app_start_provider.g.dart';

@Riverpod(keepAlive: true)
class AppStartNotifier extends _$AppStartNotifier {
  @override
  FutureOr<AppStartState> build() async {
    ref.onDispose(() {});

    final outletState = ref.watch(outletProvider);
    final authState = ref.watch(authProvider);

    log('AUTHENTICATED? ${authState.value is Authenticated ? true : false}');
    if (authState.value is Authenticated &&
        outletState.value is OutletSelected) {
      log('OUTLET SELECTED');
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
