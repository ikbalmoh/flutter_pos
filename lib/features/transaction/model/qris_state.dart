import 'package:freezed_annotation/freezed_annotation.dart';

part 'qris_state.freezed.dart';

@freezed
abstract class QrisState with _$QrisState {
  const QrisState._();

  const factory QrisState({
    required String qrContent,
    @Default(false) bool isPaid,
  }) = _QrisState;
}
