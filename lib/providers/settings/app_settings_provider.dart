import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/app_settings.dart' as model;

part 'app_settings_provider.g.dart';

@Riverpod(keepAlive: true)
class AppSettings extends _$AppSettings {
  @override
  model.AppSettings build() {
    return const model.AppSettings(itemLayoutGrid: false);
  }

  void changeItemLayout() {
    state = state.copyWith(itemLayoutGrid: !state.itemLayoutGrid);
  }
}
