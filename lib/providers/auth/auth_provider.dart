import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/repository/auth_repository.dart';
import 'package:selleri/data/repository/token_repository.dart';
import 'auth_state.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  late final AuthRepository _authRepoistory = ref.read(authRepositoryProvider);

  late final TokenRepository _tokenRepository =
      ref.read(tokenRepositoryProvider);

  @override
  FutureOr<AuthState> build() async {
    final token = await _tokenRepository.fetchToken();
    if (token != null) {
      final user = await _authRepoistory.fetchUser();
      if (user != null) {
        return Authenticated(user: user, token: token);
      }
    }
    return Initialized();
  }

  Future<void> login(String username, String password) async {
    state = AsyncData(Authenticating());
    state = AsyncData(await _authRepoistory.login(username, password));
  }

  Future<void> logout() async {
    await _tokenRepository.remove();
    state = AsyncData(await _authRepoistory.logout());
  }
}
