import 'package:dio/dio.dart';
import 'package:selleri/data/models/outlet.dart';
import 'package:selleri/data/models/outlet_config.dart';
import 'package:selleri/data/repository/outlet_repository.dart';
import 'outlet_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

export 'outlet_state.dart';

part 'outlet_provider.g.dart';

@Riverpod(keepAlive: true)
class OutletNotifier extends _$OutletNotifier {
  late final OutletRepository _outletRepository =
      ref.read(outletRepositoryProvider);

  @override
  FutureOr<OutletState> build() async {
    final outlet = await _outletRepository.retrieveOutlet();
    if (outlet != null) {
      final outletConfig = await _outletRepository.retrieveOutletConfig();
      if (outletConfig != null) {
        return OutletSelected(outlet: outlet, config: outletConfig);
      }
    }
    return OutletNotSelected();
  }

  Future<void> selectOutlet(Outlet outlet,
      {Function(OutletConfig)? onSelected}) async {
    state = AsyncData(OutletLoading());
    try {
      _outletRepository.saveOutlet(outlet);
      final config = await _outletRepository.fetchOutletConfig(outlet.idOutlet);
      state = AsyncData(OutletSelected(outlet: outlet, config: config));
      if (onSelected != null) {
        onSelected(config);
      }
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? e.message;
      state = AsyncData(OutletFailure(message: message));
    }
  }

  Future<void> clearOutlet() async {
    await _outletRepository.remove();
    state = AsyncData(OutletNotSelected());
    // Future.delayed(const Duration(seconds: 1), () {
    //   ref.read(shiftNotifierProvider.notifier).offShift();
    // });
  }
}
