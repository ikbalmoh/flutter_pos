import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/repository/auth_repository.dart';
import 'package:selleri/data/repository/token_repository.dart';
import 'auth_state.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    return Initialized();
  }

  late final AuthRepository _authRepoistory = ref.read(authRepositoryProvider);

  Future<void> login(String username, String password) async {
    state = Authenticating();
    state = await _authRepoistory.login(username, password);
  }

  late final TokenRepository _tokenRepository =
      ref.read(tokenRepositoryProvider);

  Future<void> logout() async {
    await _tokenRepository.remove();
    state = await _authRepoistory.logout();
  }
}
