import 'dart:developer';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/data/repository/auth_repository.dart';
import 'package:selleri/data/repository/outlet_repository.dart';
import 'package:selleri/data/repository/token_repository.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/item/item_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'auth_state.dart';

export 'auth_state.dart';

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
    try {
      state = AsyncData(Authenticating());
      state = AsyncData(await _authRepoistory.login(username, password));
    } catch (e) {
      state = AsyncData(AuthFailure(message: e.toString()));
    }
  }

  Future<void> logout() async {
    ref.read(shiftProvider.notifier).shiftLoading();
    try {
      log('API LOGOUT');
      await _authRepoistory.logout();
      state = AsyncData(UnAuthenticated());
    } catch (e) {
      log('LOGOUT ERROR: $e');
    } finally {
      log('API LOGOUT DONE');
    }
    Future.delayed(const Duration(seconds: 1), () async {
      await ref.read(outletProvider.notifier).clearOutlet();
      objectBox.clearAll();
      ref.invalidate(itemsStreamProvider);
      ref.invalidate(cartProvider);
      ref.invalidate(outletProvider);
      ref.invalidate(shiftProvider);
    });
  }
}
