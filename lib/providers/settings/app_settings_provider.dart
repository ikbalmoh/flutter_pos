import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/data/models/app_settings.dart';

part 'app_settings_provider.g.dart';

@Riverpod(keepAlive: true)
class AppSettingsNotifier extends _$AppSettingsNotifier {
  @override
  AppSettings build() {
    return const AppSettings(itemLayoutGrid: false);
  }

  void changeItemLayout() {
    state = state.copyWith(itemLayoutGrid: !state.itemLayoutGrid);
  }
}
