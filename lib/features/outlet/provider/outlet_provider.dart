import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:selleri/features/outlet/model/outlet.dart' as model;
import 'package:selleri/features/outlet/repository/outlet_repository.dart';
import 'package:selleri/features/item/provider/item_provider.dart';
import 'package:selleri/features/shift/provider/shift_provider.dart';
import 'outlet_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

export 'outlet_state.dart';

part 'outlet_provider.g.dart';

@Riverpod(keepAlive: true)
class Outlet extends _$Outlet {
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

  Future<void> selectOutlet(model.Outlet outlet) async {
    var progress = OutletLoading(
      config: false,
      message: 'preparing_outlet'.tr(),
      promotions: false,
      items: [],
    );
    state = AsyncData(progress);
    try {
      state = AsyncData(OutletNotSelected());
      _outletRepository.saveOutlet(outlet);
      await _outletRepository.fetchOutletInfo(outlet.idOutlet);
      final config = await _outletRepository.fetchOutletConfig(outlet.idOutlet);
      log('CONFIG LOADED: $config');

      state = AsyncData(progress.copyWith(config: true));

      await ref.read(itemsProvider().notifier).loadItems(
            refresh: true,
            fullSync: false,
            progressCallback: (status) {
              log('LOAD OUTLET STATUS: $status');
              state = AsyncData(status);
            },
          );

      state = AsyncData(OutletSelected(outlet: outlet, config: config));
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print("SELECT OUTLET ERROR: $e\n$stacktrace");
      }
      state = AsyncData(OutletFailure(message: "$e"));
    }
  }

  Future<void> refreshConfig({List<String>? only = const []}) async {
    try {
      log('SYNC CONFIG: $only');
      if (state.value is OutletSelected) {
        final outletState = state.value as OutletSelected;
        state = AsyncData(OutletSelected(
          outlet: outletState.outlet,
          config: outletState.config,
          isSyncing: true,
        ));
        final config = await _outletRepository.fetchOutletConfig(
          outletState.outlet.idOutlet,
          only: only,
          current: outletState.config,
        );
        state = AsyncData(OutletSelected(
          outlet: outletState.outlet,
          config: config,
          isSyncing: false,
        ));
      }
    } catch (e) {
      log('SYNC CONFIG ERROR: $e');
    }
  }

  Future<void> clearOutlet() async {
    await _outletRepository.remove();
    state = AsyncData(OutletNotSelected());
    ref.read(shiftProvider.notifier).offShift();
  }
}
