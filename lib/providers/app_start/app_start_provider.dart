import 'package:flutter/foundation.dart';
import 'package:selleri/data/models/token.dart';
import 'package:selleri/data/models/user.dart';
import 'package:selleri/data/repository/auth_repository.dart';
import 'package:selleri/data/repository/outlet_repository.dart';
import 'package:selleri/data/repository/token_repository.dart';
import 'package:selleri/providers/app_start/app_start_state.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/providers/auth/auth_state.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';

part 'app_start_provider.g.dart';

@riverpod
class AppStartNotifier extends _$AppStartNotifier {
  @override
  FutureOr<AppStartState> build() async {
    ref.onDispose(() {});

    final outletState = ref.watch(outletNotifierProvider);
    print('OUTLET STATE: ${outletState.value}');
    if (outletState.value is OutletSelected) {
      return const AppStartState.selectedOutlet();
    }

    final authState = ref.watch(authNotifierProvider);
    if (kDebugMode) {
      print('AUTH STATE ${authState.value.toString()}');
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
