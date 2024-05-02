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

    final authState = ref.watch(authNotifierProvider);
    return authState.when(
        data: (state) {
          print('AUTH STATE ${state.toString()}');
          if (state is Authenticated) {
            final outletState = ref.watch(outletNotifierProvider);
            if (outletState is OutletSelected) {
              return const AppStartState.selectedOutlet();
            }
            return const AppStartState.authenticated();
          }
          return const AppStartState.unauthenticated();
        },
        error: (e, stack) => const AppStartState.unauthenticated(),
        loading: () => const AppStartState.initializing());
  }
}
