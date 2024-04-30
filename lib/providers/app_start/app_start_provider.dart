import 'package:selleri/data/repository/token_repository.dart';
import 'package:selleri/providers/app_start/app_start_state.dart';
import 'package:selleri/providers/auth/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/providers/auth/auth_state.dart';

part 'app_start_provider.g.dart';

@riverpod
class AppStartNotifier extends _$AppStartNotifier {
  late final TokenRepository _tokenRepository =
      ref.read(tokenRepositoryProvider);

  @override
  FutureOr<AppStartState> build() async {
    ref.onDispose(() {});

    final authState = ref.watch(authNotifierProvider);

    // Check if authenticated
    if (authState is Authenticated) {
      // Check if outlet selected
      return const AppStartState.authenticated();
    } else if (authState is Unauthenticated) {
      return const AppStartState.unauthenticated();
    }

    try {
      final token = await _tokenRepository.fetchToken();

      if (token != null) {
        return const AppStartState.authenticated();
      } else {
        return const AppStartState.unauthenticated();
      }
    } catch (e) {
      print(e);
      return const AppStartState.authenticated();
    }
  }
}
