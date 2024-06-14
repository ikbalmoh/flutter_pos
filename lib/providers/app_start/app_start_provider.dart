import 'package:selleri/providers/app_start/app_start_state.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/providers/auth/auth_state.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'dart:developer';

part 'app_start_provider.g.dart';

@Riverpod(keepAlive: true)
class AppStartNotifier extends _$AppStartNotifier {
  @override
  FutureOr<AppStartState> build() async {
    ref.onDispose(() {});

    final outletState = ref.watch(outletNotifierProvider);
    final authState = ref.watch(authNotifierProvider);

    log('AUTH STATE ${authState.value.toString()}');
    log('OUTLET STATE: ${outletState.value}');
    if (outletState.value is OutletSelected) {
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
