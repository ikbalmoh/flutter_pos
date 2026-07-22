import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:selleri/shared/constants/store_key.dart';
import 'package:selleri/features/outlet/model/outlet_config.dart';
import 'package:selleri/features/shift/model/shift.dart' as model;
import 'package:selleri/features/shift/model/shift_info.dart';
import 'package:selleri/features/shift/repository/shift_repository.dart';
import 'package:selleri/features/auth/provider/auth_provider.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/settings/provider/printer_provider.dart';
import 'package:selleri/shared/provider/connectivity_status_provider.dart';
import 'package:selleri/shared/utils/formater.dart';
import 'package:selleri/shared/utils/printer.dart' as util;
import 'package:uuid/uuid.dart';
import 'dart:developer';

part 'shift_notifier_provider.g.dart';

var uuid = const Uuid();

@Riverpod(keepAlive: true)
class ShiftNotifier extends _$ShiftNotifier {
  late final ShiftRepository _shiftRepository =
      ref.read(shiftRepositoryProvider);

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  /// Initializes the provider state with `null`.
  /// The shift becomes non-null once [openShift] is called successfully.
  @override
  FutureOr<model.Shift?> build() async {
    final offlineShift = await _shiftRepository.retrieveOfflineShift();
    getCurrentShift();
    analytics.setUserProperty(
        name: 'shift', value: offlineShift?.codeShift ?? '');
    crashlytics.setCustomKey('shift', offlineShift?.codeShift ?? '');
    return offlineShift;
  }

  /// Opens a new shift for the current authenticated user and outlet.
  ///
  /// Creates a new [model.Shift] record with the given [openAmount] as the
  /// opening cash balance, then persists it via [ShiftRepository.startShift].
  /// The state transitions to [AsyncLoading] during the operation and resolves
  /// to [AsyncData] on success or [AsyncError] on failure.
  ///
  /// - [openAmount]: The opening cash amount for the shift.
  Future<void> openShift(double openAmount) async {
    if (state.isLoading) {
      return;
    }
    state = const AsyncLoading();
    final outletState = await ref.read(outletProvider.future) as OutletSelected;
    final authState = await ref.read(authProvider.future) as Authenticated;

    final userAccount = authState.user.user;

    const storage = FlutterSecureStorage();
    final deviceId = await storage.read(key: StoreKey.device.name);

    final outlet = outletState.outlet;

    final shift = model.Shift(
      id: uuid.v4(),
      outletId: outlet.idOutlet,
      outletName: outlet.outletName,
      deviceId: deviceId!,
      createdAt: DateTime.now(),
      createdBy: userAccount.idUser,
      createdName: userAccount.name,
      updatedBy: userAccount.idUser,
      updatedName: userAccount.name,
      startShift: DateTime.now(),
      openAmount: openAmount,
    );

    analytics.logEvent(
      name: 'open_shift',
      parameters: {
        'id_outlet': outlet.idOutlet,
        'open_amount': openAmount,
      },
    );
    try {
      final storedShift = await _shiftRepository.startShift(shift);
      analytics.setUserProperty(
          name: 'shift', value: storedShift?.codeShift ?? '');
      crashlytics.setCustomKey('shift', storedShift?.codeShift ?? '');
      state = AsyncData(storedShift);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  /// Closes the currently active shift.
  ///
  /// Submits closing data to the repository and, if [reopen] is `true`,
  /// immediately opens a new shift using [closeAmount] as the opening balance.
  /// Optionally prints a shift report via [printShift] when [printReport] is `true`.
  ///
  /// - [shift]: The current shift summary info used for the closing report.
  /// - [closeAmount]: The actual cash count at close.
  /// - [diffAmount]: The difference between expected and actual cash.
  /// - [refundAmount]: Total refund amount for the shift.
  /// - [attachments]: Optional images/files attached to the closing report.
  /// - [printReport]: Whether to print the shift report after closing. Defaults to `true`.
  /// - [reopen]: Whether to immediately open a new shift after closing. Defaults to `false`.
  Future<void> closeShift(
    ShiftInfo shift, {
    required double closeAmount,
    required double diffAmount,
    required double refundAmount,
    List<XFile>? attachments,
    bool printReport = true,
    bool reopen = false,
  }) async {
    final connectivity = ref.read(connectivityStatusProvider);
    if (connectivity != ConnectivityState.connected) {
      throw 'connect_internet_to_close_shift'.tr();
    }

    final user = (ref.read(authProvider).value as Authenticated).user.user;
    final model.Shift currentShift = state.value!;
    try {
      state = const AsyncLoading();

      final closeShift = DateTime.now();
      Map<String, dynamic> payload = {
        "close_shift": DateTimeFormater.dateToString(closeShift),
        "close_amount": closeAmount,
        "diff_amount": diffAmount,
        "refund_amount": refundAmount,
        "attachments": attachments,
        "updated_by": user.idUser,
        "_method": "PUT"
      };
      analytics.logEvent(
        name: 'close_shift',
        parameters: {
          'id': currentShift.id,
          'close_amount': closeAmount,
          'diff_amount': diffAmount,
          'refund_amount': refundAmount,
        },
      );
      await _shiftRepository.close(currentShift.id, payload);

      if (reopen) {
        state = const AsyncData(null);
        await openShift(closeAmount);
      } else {
        state = const AsyncData(null);
      }

      ShiftInfo shiftInfo = shift.copyWith(
        closeShift: closeShift,
        closedBy: user.idUser,
        summary: shift.summary.copyWith(
          actualCash: closeAmount,
          different: diffAmount,
        ),
      );
      if (printReport) {
        printShift(shiftInfo);
      }
    } catch (e) {
      state = AsyncData(currentShift);
      rethrow;
    }
  }

  /// Prints the shift report for the given [info].
  ///
  /// Builds the receipt bytes using [util.Printer], choosing between
  /// image-based or text-based rendering depending on the printer configuration.
  /// Errors are logged; if [throwError] is `true`, the error is re-thrown
  /// so the caller can handle it explicitly.
  ///
  /// - [info]: The shift summary data to include in the report.
  /// - [throwError]: If `true`, rethrows any caught exception. Defaults to `null` (suppressed).
  Future<void> printShift(ShiftInfo info, {bool? throwError}) async {
    try {
      final printer = ref.read(printerProvider).value;
      if (printer == null) {
        throw 'printer_not_connected'.tr();
      }
      final outlet = ref.read(outletProvider).value as OutletSelected;
      final AttributeReceipts? attributeReceipts =
          outlet.config.attributeReceipts;
      List<int> receipt = [];
      if (printer.printImage) {
        receipt = await util.Printer.buildShiftReportReceiptCaptureBytes(
          outlet: outlet.outlet,
          info,
          attributes: attributeReceipts,
          size: printer.size,
          cut: printer.cut,
        );
      } else {
        receipt = await util.Printer.buildShiftReportBytes(
          outlet: outlet.outlet,
          info,
          attributes: attributeReceipts,
          size: printer.size,
          cut: printer.cut,
        );
      }
      await ref.read(printerProvider.notifier).print(receipt);
    } catch (e, stackTrace) {
      log('PRINT SHIFT ERROR: $e => $stackTrace');
      if (throwError == true) {
        rethrow;
      }
    }
  }

  /// Initializes the shift state from the repository on app startup.
  ///
  /// Retrieves the active shift from [ShiftRepository] and
  /// saves it locally before updating the state.
  Future<model.Shift?> getCurrentShift() async {
    log('GET CURRENT SHIFT');
    final shift = await _shiftRepository.retrieveShift();
    if (shift != null) {
      analytics.setUserProperty(name: 'shift', value: shift.codeShift ?? '');
      crashlytics.setCustomKey('shift', shift.codeShift ?? '');
      await _shiftRepository.saveShift(shift);
      state = AsyncData(shift);
    }
    return shift;
  }

  /// Sets the state to [AsyncLoading], typically used to show a loading
  /// indicator while an external shift operation is in progress.
  void shiftLoading() {
    state = const AsyncLoading();
  }

  /// Clears the shift data from local storage and resets the state to loading.
  ///
  /// Called when the user logs out or when the outlet session ends,
  /// ensuring no stale shift data remains.
  Future<void> offShift() async {
    await _shiftRepository.clear();
    state = const AsyncValue.loading();
  }

  /// Updates the opening cash amount for the current active shift.
  ///
  /// Persists the new [amount] via [ShiftRepository.changeOpenAmount] and
  /// reflects the change in the provider state. Re-throws any exception
  /// so the caller can handle it.
  ///
  /// - [amount]: The new opening cash amount to set.
  void updateOpenAmount(double amount) async {
    try {
      await _shiftRepository.changeOpenAmount(state.value!.id, amount);
      state = AsyncData(state.value?.copyWith(openAmount: amount));
    } catch (e) {
      rethrow;
    }
  }
}
