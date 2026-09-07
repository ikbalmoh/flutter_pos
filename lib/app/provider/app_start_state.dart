import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_start_state.freezed.dart';

@freezed
abstract class AppStartState with _$AppStartState {
  const AppStartState._();

  const factory AppStartState.initializing() = _Initializing;

  const factory AppStartState.unauthenticated() = Unauthenticated;

  const factory AppStartState.authenticated() = AppAuthenticated;
  
  const factory AppStartState.selectedOutlet() = AppSelectedOutlet;

  const factory AppStartState.selectingOutlet() = AppSelectingOutlet;

}