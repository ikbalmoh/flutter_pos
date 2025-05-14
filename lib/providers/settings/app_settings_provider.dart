import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/app_settings.dart' as model;

part 'app_settings_provider.g.dart';

const _storageKey = 'app_settings';

@Riverpod(keepAlive: true)
class AppSettings extends _$AppSettings {
  late final FlutterSecureStorage _storage;

  @override
  model.AppSettings build() {
    _storage = const FlutterSecureStorage();
    // Initialize with default settings and then load from storage
    state = model.AppSettings.init();
    _loadSettingsFromStorage();
    return state;
  }

  Future<void> _loadSettingsFromStorage() async {
    try {
      final settingsJson = await _storage.read(key: _storageKey);
      if (settingsJson == null) return;

      final Map<String, dynamic> settingsMap = json.decode(settingsJson);
      final newSettings = model.AppSettings(
        itemLayoutGrid: settingsMap['itemLayoutGrid'] as bool,
        autoPrintReceipt: settingsMap['autoPrintReceipt'] as bool,
        autoPrintOnMakePayment: settingsMap['autoPrintOnMakePayment'] as bool,
        autoPrintOnRefund: settingsMap['autoPrintOnRefund'] as bool,
        autoPrintShiftReport: settingsMap['autoPrintShiftReport'] as bool,
        autoPrintKitchen: settingsMap['autoPrintKitchen'] as bool,
      );
      state = newSettings;
    } catch (e) {
      // Keep default settings if there's an error
    }
  }

  Future<void> _saveSettings(model.AppSettings settings) async {
    final settingsMap = {
      'itemLayoutGrid': settings.itemLayoutGrid,
      'autoPrintReceipt': settings.autoPrintReceipt,
      'autoPrintOnMakePayment': settings.autoPrintOnMakePayment,
      'autoPrintOnRefund': settings.autoPrintOnRefund,
      'autoPrintShiftReport': settings.autoPrintShiftReport,
      'autoPrintKitchen': settings.autoPrintKitchen,
    };
    await _storage.write(key: _storageKey, value: json.encode(settingsMap));
  }

  void changeItemLayout() {
    final newSettings = state.copyWith(itemLayoutGrid: !state.itemLayoutGrid);
    state = newSettings;
    _saveSettings(newSettings);
  }

  void toggleAutoPrintReceipt(bool value) {
    final newSettings = state.copyWith(autoPrintReceipt: value);
    state = newSettings;
    _saveSettings(newSettings);
  }

  void toggleAutoPrintShiftReport(bool value) {
    final newSettings = state.copyWith(autoPrintShiftReport: value);
    state = newSettings;
    _saveSettings(newSettings);
  }

  void toggleAutoPrintKitchen(bool value) {
    final newSettings = state.copyWith(autoPrintKitchen: value);
    state = newSettings;
    _saveSettings(newSettings);
  }
}
