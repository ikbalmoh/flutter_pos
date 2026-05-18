import 'package:freezed_annotation/freezed_annotation.dart';

part 'qris_state.freezed.dart';

@freezed
class QrisState with _$QrisState {
  const factory QrisState({
    required String qrContent,
    @Default(false) bool isPaid,
  }) = _QrisState;
}
