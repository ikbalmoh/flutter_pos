import 'package:dio/dio.dart';
import 'package:selleri/data/models/outlet.dart';
import 'package:selleri/data/models/outlet_config.dart';
import 'package:selleri/data/repository/outlet_repository.dart';
import 'outlet_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/network/api.dart' show OutletApi;

export 'outlet_state.dart';

part 'outlet_provider.g.dart';

@Riverpod(keepAlive: true)
class OutletNotifier extends _$OutletNotifier {
  late final OutletRepository _outletRepository =
      ref.read(outletRepositoryProvider);

  @override
  OutletState build() {
    return OutletNotSelected();
  }

  Future<void> selectOutlet(Outlet outlet) async {
    state = OutletLoading();
    try {
      final api = OutletApi();
      final configJson = await api.configs(outlet.idOutlet);
      final OutletConfig config = OutletConfig.fromJson(configJson);
      _outletRepository.saveOutlet(outlet);
      state = OutletSelected(outlet: outlet, config: config);
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? e.message;
      state = OutletFailure(message: message);
    }
  }
}
