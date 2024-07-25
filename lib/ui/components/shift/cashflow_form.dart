// ignore_for_file: unused_import

import 'dart:developer';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/outlet_config.dart';
import 'package:selleri/data/models/shift_cashflow.dart';
import 'package:selleri/data/models/shift_cashflow_image.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/providers/shift/current_shift_info_provider.dart';
import 'package:selleri/ui/components/generic/button_selection.dart';
import 'package:selleri/ui/components/generic/loading_placeholder.dart';
import 'package:selleri/ui/components/generic/picked_image.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/formater.dart';
import 'package:image_picker/image_picker.dart';

class CashflowForm extends ConsumerStatefulWidget {
  const CashflowForm({this.cashflow, this.height, super.key});

  final ShiftCashflow? cashflow;
  final double? height;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CashflowFormState();
}

class _CashflowFormState extends ConsumerState<CashflowForm> {
  final _amountFormater = CurrencyFormat.currencyInput();

  int status = 1;
  DateTime transDate = DateTime.now();
  double amount = 0;
  String descriptions = '';
  List<XFile> images = [];
  List<ShiftCashflowImage> prevImages = [];
  List<int> removeImages = [];
  Akun? account;

  bool isLoading = false;

  @override
  void initState() {
    if (widget.cashflow != null) {
      final config =
          (ref.read(outletNotifierProvider).value as OutletSelected).config;
      List<Akun> accounts = List<Akun>.from(config.akunBiaya ?? []);
      accounts.addAll(config.akunPendapatan ?? []);
      accounts.addAll(config.akunSetoran ?? []);
      Akun? findAccount = widget.cashflow?.idAkun != null
          ? accounts
              .firstWhereOrNull((ac) => ac.idAkun == widget.cashflow!.idAkun)
          : null;
      setState(() {
        status = widget.cashflow!.status;
        amount = widget.cashflow!.amount;
        transDate = widget.cashflow!.transDate;
        descriptions = widget.cashflow!.descriptions ?? '';
        prevImages = widget.cashflow!.images;
        account = findAccount;
      });
    }
    super.initState();
  }

  void onChangeCashflowType(int type) {
    setState(() {
      status = type;
      account = null;
    });
  }

  void pickCashflowDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(transDate.millisecondsSinceEpoch >
              DateTime.now().millisecondsSinceEpoch
          ? DateTime.now().year
          : transDate.year),
      lastDate: DateTime.now(),
      initialDate: transDate,
    );
    if (pickedDate != null) {
      setState(() {
        transDate = pickedDate;
      });
    }
  }

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

  void onRemovePrevImage(int id) {
    setState(() {
      prevImages = List<ShiftCashflowImage>.from(prevImages)
        ..removeWhere((img) => img.id == id);
      removeImages = List<int>.from(removeImages)..add(id);
    });
  }

  String cashflowType() {
    switch (status) {
      case 1:
        return 'expense'.tr();
      case 2:
        return 'income'.tr();
      default:
        return 'deposit'.tr();
    }
  }

  void onDeleteCashflow() {
    AppAlert.confirm(
      context,
      title: 'delete_n'.tr(args: ['cashflow'.tr()]),
      subtitle: 'are_you_sure'.tr(),
      danger: true,
      onConfirm: () {
        submitCashflow(isDelete: true);
      },
    );
  }

  void submitCashflow({bool? isDelete}) async {
    setState(() {
      isLoading = true;
    });
    try {
      Map<String, dynamic> mapData = {
        "trans_date": transDate.millisecondsSinceEpoch / 1000,
        "status": status,
        "amount": amount,
        "descriptions": descriptions,
        "images": images,
        "remove_images": removeImages,
        "id_akun": account?.idAkun,
      };
      if (isDelete == true) {
        mapData['deleted_at'] = DateTime.now().millisecondsSinceEpoch / 1000;
      }
      if (widget.cashflow != null) {
        mapData["id"] = widget.cashflow?.id ?? '';
      }
      ref.read(shiftInfoNotifierProvider.notifier).submitCashflow(
        mapData,
        onSubmited: () {
          context.pop();
          String message = isDelete == true
              ? 'deleted'.tr()
              : widget.cashflow != null
                  ? 'updated'.tr()
                  : 'saved'.tr();
          AppAlert.toast(message);
        },
      );
    } catch (e, stackTrace) {
      log('submit cashflow error: $e => $stackTrace');
      AppAlert.toast(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? labelStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Colors.blueGrey.shade600);

    final outletConfig =
        (ref.read(outletNotifierProvider).value as OutletSelected).config;

    List<Akun> accountList = switch (status) {
      1 => outletConfig.akunBiaya ?? [],
      2 => outletConfig.akunPendapatan ?? [],
      int() => outletConfig.akunSetoran ?? [],
    };

    return PopScope(
      canPop: !isLoading,
      child: isLoading
          ? const LoadingPlaceholder()
          : SizedBox(
              height: (widget.height ?? MediaQuery.of(context).size.height) +
                  MediaQuery.of(context).viewInsets.bottom + 15,
              child: Column(
                mainAxisSize: MainAxisSize.max,
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
                          (widget.cashflow == null ? 'add' : 'edit')
                              .tr(args: ['cashflow'.tr()]),
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ButtonSelection(
                                  color: Colors.red,
                                  label: 'expense'.tr(),
                                  onSelect: () => onChangeCashflowType(1),
                                  selected: status == 1,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                ButtonSelection(
                                  color: Colors.green,
                                  label: 'income'.tr(),
                                  onSelect: () => onChangeCashflowType(2),
                                  selected: status == 2,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                ButtonSelection(
                                  color: Colors.blue,
                                  label: 'deposit'.tr(),
                                  onSelect: () => onChangeCashflowType(3),
                                  selected: status == 3,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            padding: const EdgeInsets.symmetric(vertical: 0),
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
                                  'date'.tr(),
                                  style: labelStyle,
                                ),
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.blue.shade600),
                                  icon: const Icon(
                                    Icons.calendar_month,
                                    size: 18,
                                  ),
                                  onPressed: pickCashflowDate,
                                  label: Text(DateTimeFormater.dateToString(
                                      transDate,
                                      format: 'd MMM y')),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            padding: const EdgeInsets.symmetric(vertical: 0),
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
                                  'account'.tr(),
                                  style: labelStyle,
                                ),
                                DropdownButton<Akun>(
                                  dropdownColor: Colors.white,
                                  value: account,
                                  hint: Text(
                                      'select_x'.tr(args: ['account'.tr()])),
                                  onChanged: (value) {
                                    setState(() {
                                      account = value;
                                    });
                                  },
                                  items: accountList
                                      .map<DropdownMenuItem<Akun>>((Akun akun) {
                                    return DropdownMenuItem<Akun>(
                                      value: akun,
                                      child: Text(akun.namaAkun),
                                    );
                                  }).toList(),
                                  underline: const SizedBox(),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              inputFormatters: <TextInputFormatter>[
                                _amountFormater
                              ],
                              initialValue:
                                  _amountFormater.formatDouble(amount),
                              onChanged: (value) {
                                setState(() {
                                  amount = _amountFormater
                                      .getUnformattedValue()
                                      .toDouble();
                                });
                              },
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 0, bottom: 15, right: 0),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                label: Text(
                                  'amount'.tr(),
                                  style: labelStyle,
                                ),
                                prefix: Text(
                                  'amount'.tr(),
                                  style: labelStyle,
                                ),
                                alignLabelWithHint: true,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              initialValue: descriptions,
                              onChanged: (value) => setState(() {
                                descriptions = value;
                              }),
                              decoration: InputDecoration(
                                label: Text(
                                  'description'.tr(),
                                  style: labelStyle,
                                ),
                                hintText: 'add'.tr(args: ['description'.tr()]),
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
                                  children: [
                                    ...List.generate(prevImages.length,
                                        (index) {
                                      return PickedImage(
                                        source: prevImages[index].uri,
                                        sourceType: SourceType.uri,
                                        onDelete: () => onRemovePrevImage(
                                            prevImages[index].id),
                                      );
                                    }),
                                    ...List.generate(images.length, (index) {
                                      XFile image = images[index];
                                      return PickedImage(
                                        source: image.path,
                                        sourceType: SourceType.path,
                                        onDelete: () => onDeleteImage(index),
                                      );
                                    })
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextButton.icon(
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            Colors.blueGrey.shade600,
                                        backgroundColor:
                                            Colors.blueGrey.shade50,
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
                                        foregroundColor:
                                            Colors.blueGrey.shade600,
                                        backgroundColor:
                                            Colors.blueGrey.shade50,
                                      ),
                                      icon: const Icon(
                                        CupertinoIcons
                                            .photo_fill_on_rectangle_fill,
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
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        widget.cashflow != null
                            ? Container(
                                margin: const EdgeInsets.only(right: 15),
                                child: IconButton(
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.red),
                                  onPressed: onDeleteCashflow,
                                  icon: const Icon(CupertinoIcons.trash),
                                ),
                              )
                            : Container(),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                            ),
                            onPressed: isLoading ||
                                    amount == 0 ||
                                    descriptions == '' ||
                                    account == null ||
                                    (images.isEmpty && prevImages.isEmpty)
                                ? null
                                : submitCashflow,
                            child: Text(
                              '${widget.cashflow != null ? 'update'.tr() : 'save'.tr()} ${cashflowType()}',
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
