import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:selleri/features/outlet/model/outlet.dart' as model;
import 'package:selleri/features/outlet/repository/outlet_repository.dart';
import 'package:selleri/features/item/provider/item_provider.dart';
import 'package:selleri/features/shift/provider/shift_notifier_provider.dart';
import 'package:selleri/shared/provider/connectivity_status_provider.dart';
import 'outlet_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

export 'outlet_state.dart';

part 'outlet_provider.g.dart';

@Riverpod(keepAlive: true)
class Outlet extends _$Outlet {
  late final OutletRepository _outletRepository =
      ref.read(outletRepositoryProvider);

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

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
    analytics.logEvent(
      name: 'select_outlet',
      parameters: {
        'outlet_name': outlet.outletName,
        'outlet_id': outlet.idOutlet,
      },
    );

    var progress = OutletLoading(
      config: false,
      message: 'preparing_outlet'.tr(),
      promotions: false,
      items: [],
    );
    state = AsyncData(progress.copyWith(config: true));

    try {
      await _outletRepository.fetchOutletInfo(outlet.idOutlet);
      final config = await _outletRepository.fetchOutletConfig(outlet.idOutlet);
      _outletRepository.saveOutlet(outlet);

      await ref.read(itemsProvider().notifier).loadItems(
            refresh: true,
            fullSync: false,
            progressCallback: (status) {
              state = AsyncData(status);
            },
          );

      state = AsyncData(OutletSelected(outlet: outlet, config: config));
    } catch (e, stacktrace) {
      if (kDebugMode) {
        log("SELECT OUTLET ERROR: $e\n$stacktrace");
      }
      analytics.logEvent(
        name: 'select_outlet_failed',
        parameters: {
          'outlet_name': outlet.outletName,
          'outlet_id': outlet.idOutlet,
          'error': e.toString(),
        },
      );
      crashlytics.recordError(
        e,
        stacktrace,
        fatal: false,
      );
      state = AsyncData(OutletFailure(message: "$e"));
    }
  }

  Future<void> refreshConfig({List<String>? only = const []}) async {
    try {
      final connection = ref.read(connectivityStatusProvider);
      if (connection == ConnectivityState.disconnected ||
          state.value! is! OutletSelected) {
        return;
      }
      log('SYNC CONFIG: $only');
      analytics.logEvent(
        name: 'sync_config',
        parameters: {'only': only?.join(',') ?? ''},
      );

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
      log('CONFIG SYNCED');
    } catch (e) {
      log('SYNC CONFIG ERROR: $e');
    }
  }

  Future<void> clearOutlet() async {
    await _outletRepository.remove();
    if (state.value is! OutletNotSelected) {
      state = AsyncData(OutletNotSelected());
    }
    ref.read(shiftNotifierProvider.notifier).offShift();
  }
}
