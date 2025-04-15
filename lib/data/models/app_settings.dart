import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    required bool itemLayoutGrid,
    required bool autoPrintReceipt,
    required bool autoPrintOnMakePayment,
    required bool autoPrintOnRefund,
    required bool autoPrintShiftReport,
    required bool autoPrintKitchen,
  }) = _AppSettings;

  factory AppSettings.init() => const AppSettings(
        itemLayoutGrid: false,
        autoPrintReceipt: true,
        autoPrintOnMakePayment: true,
        autoPrintOnRefund: true,
        autoPrintShiftReport: true,
        autoPrintKitchen: true,
      );
}
