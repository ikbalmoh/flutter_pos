// ignore_for_file: unused_import

import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/shift_cashflow.dart';
import 'package:selleri/data/models/shift_cashflow_image.dart';
import 'package:selleri/data/models/shift_info.dart';
import 'package:selleri/providers/shift/current_shift_info_provider.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/ui/components/generic/button_selection.dart';
import 'package:selleri/ui/components/generic/loading_placeholder.dart';
import 'package:selleri/ui/components/generic/picked_image.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/formater.dart';
import 'package:image_picker/image_picker.dart';

class CloseShiftForm extends ConsumerStatefulWidget {
  const CloseShiftForm({required this.shift, super.key});

  final ShiftInfo shift;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CloseShiftFormState();
}

class _CloseShiftFormState extends ConsumerState<CloseShiftForm> {
  final _amountFormater = CurrencyFormat.currencyInput();

  int status = 1;
  DateTime transDate = DateTime.now();
  double amount = 0;
  double diffAmount = 0;
  List<XFile> images = [];

  bool isLoading = false;
  bool printReport = true;

  Future pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      setState(() {
        images = images..add(image);
      });
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
    }
  }

  void onDeleteImage(int index) {
    List<XFile> imgs = List.from(images);
    imgs.removeAt(index);
    setState(() {
      images = imgs;
    });
  }

  void submitCloseShift({bool? isDelete}) async {
    setState(() {
      isLoading = true;
    });
    final summary = widget.shift.summary;
    try {
      await ref.read(shiftNotifierProvider.notifier).closeShift(
            widget.shift,
            closeAmount: amount,
            diffAmount: summary.expectedCashEnd - amount,
            refundAmount: summary.refunded,
            attachments: images,
            printReport: printReport,
          );
      // ignore: use_build_context_synchronously
      context.pop();
      AppAlert.toast('shift_closed'.tr());
    } on Exception catch (e, stackTrace) {
      log('submit cashflow error: $e => $stackTrace');
      AppAlert.toast(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  final WidgetStateProperty<Icon?> printIcon =
      WidgetStateProperty.resolveWith<Icon?>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(
          CupertinoIcons.printer_fill,
          color: Colors.teal,
        );
      }
      return const Icon(
        CupertinoIcons.printer,
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    TextStyle? labelStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Colors.blueGrey.shade600);

    return PopScope(
      canPop: !isLoading,
      child: isLoading
          ? const LoadingPlaceholder()
          : SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 15,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        top: 20, left: 15, right: 15, bottom: 15),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 0.5,
                          color: Colors.blueGrey.shade100,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'close_shift'.tr(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: const Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.blueGrey.shade100,
                      ),
                    )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'expected_cash'.tr(),
                          style: labelStyle,
                        ),
                        Text(
                          CurrencyFormat.currency(
                            widget.shift.summary.expectedCashEnd,
                            symbol: false,
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.teal),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      inputFormatters: <TextInputFormatter>[_amountFormater],
                      initialValue: _amountFormater.formatDouble(amount),
                      onChanged: (value) {
                        setState(() {
                          amount =
                              _amountFormater.getUnformattedValue().toDouble();
                        });
                      },
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 0, bottom: 15, right: 0),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        label: Text(
                          'available_cash'.tr(),
                          style: labelStyle,
                        ),
                        prefix: Text(
                          'available_cash'.tr(),
                          style: labelStyle,
                        ),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'attachments'.tr(),
                          style: labelStyle,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          children: List.generate(images.length, (index) {
                            XFile image = images[index];
                            return PickedImage(
                              source: image.path,
                              sourceType: SourceType.path,
                              onDelete: () => onDeleteImage(index),
                            );
                          }),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.blueGrey.shade600,
                                backgroundColor: Colors.blueGrey.shade50,
                              ),
                              icon: const Icon(
                                CupertinoIcons.camera_fill,
                                size: 18,
                              ),
                              onPressed: () =>
                                  pickImage(source: ImageSource.camera),
                              label: Text('photo'.tr()),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.blueGrey.shade600,
                                backgroundColor: Colors.blueGrey.shade50,
                              ),
                              icon: const Icon(
                                CupertinoIcons.photo_fill_on_rectangle_fill,
                                size: 18,
                              ),
                              onPressed: pickImage,
                              label: Text('image'.tr()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Switch(
                          thumbIcon: printIcon,
                          value: printReport,
                          onChanged: (bool value) {
                            setState(() {
                              printReport = value;
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                            ),
                            onPressed: isLoading ? null : submitCloseShift,
                            child: Text(
                              'close_shift'.tr(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
