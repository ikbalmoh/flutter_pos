import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_start_state.freezed.dart';

@freezed
class AppStartState with _$AppStartState {
  const factory AppStartState.initializing() = _Initializing;

  const factory AppStartState.unauthenticated() = Unauthenticated;

  const factory AppStartState.authenticated() = AppAuthenticated;
  
  const factory AppStartState.selectedOutlet() = AppSelectedOutlet;

}