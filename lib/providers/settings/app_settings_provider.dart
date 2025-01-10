import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/app_settings.dart' as model;

part 'app_settings_provider.g.dart';

@Riverpod(keepAlive: true)
class AppSettings extends _$AppSettings {
  @override
  model.AppSettings build() {
    return model.AppSettings.init();
  }

  void changeItemLayout() {
    state = state.copyWith(itemLayoutGrid: !state.itemLayoutGrid);
  }

  void toggleAutoPrintReceipt(bool value) {
    state = state.copyWith(autoPrintReceipt: value);
  }

  void toggleAutoPrintShiftReport(bool value) {
    state = state.copyWith(autoPrintShiftReport: value);
  }
}
