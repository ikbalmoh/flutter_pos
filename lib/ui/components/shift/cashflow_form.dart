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
import 'package:selleri/providers/shift/shift_info_provider.dart';
import 'package:selleri/ui/components/generic/button_selection.dart';
import 'package:selleri/ui/components/generic/loading_placeholder.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/formater.dart';
import 'package:image_picker/image_picker.dart';

class CashflowForm extends ConsumerStatefulWidget {
  const CashflowForm({super.key});

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

  bool isLoading = false;

  void onChangeCashflowType(int type) {
    setState(() {
      status = type;
    });
  }

  void pickCashflowDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year),
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

  String statusName() {
    switch (status) {
      case 1:
        return 'expense'.tr();
      case 2:
        return 'income'.tr();
      default:
        return 'deposit'.tr();
    }
  }

  void submitCashflow() async {
    setState(() {
      isLoading = true;
    });
    try {
      final Map<String, dynamic> mapData = {
        "trans_date": transDate.millisecondsSinceEpoch / 1000,
        "status": status,
        "amount": amount,
        "descriptions": descriptions,
        "images": images
      };
      await ref.read(shiftInfoNotifierProvider.notifier).submitCashflow(
        mapData,
        onSubmited: () {
          context.pop();
          AppAlert.toast('successfully_stored'.tr(args: ['cashflow'.tr()]));
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

    return isLoading
        ? LoadingPlaceholder(
            label: 'saving'.tr(args: [statusName()]),
          )
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
                  child: Text(
                    'add'.tr(args: ['cashflow'.tr()]),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                        label: Text(DateTimeFormater.dateToString(transDate,
                            format: 'd MMM y')),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    inputFormatters: <TextInputFormatter>[_amountFormater],
                    initialValue: '0',
                    onChanged: (value) {
                      setState(() {
                        amount =
                            _amountFormater.getUnformattedValue().toDouble();
                      });
                    },
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(left: 0, bottom: 15, right: 0),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      label: Text(
                        'amount'.tr(),
                        style: labelStyle,
                      ),
                      prefix: Text(
                        'amount'.tr(),
                        style: labelStyle,
                      ),
                      alignLabelWithHint: true,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.blueGrey.shade100,
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    onChanged: (value) => setState(() {
                      descriptions = value;
                    }),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                          left: 0, top: 10, right: 0, bottom: 15),
                      label: Text(
                        'description'.tr(),
                        style: labelStyle,
                      ),
                      hintText: 'add'.tr(args: ['description'.tr()]),
                      alignLabelWithHint: true,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.blueGrey.shade100,
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                            image: image,
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
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.grey),
                        onPressed: () => context.pop(),
                        child: Text('cancel'.tr()),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
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
                                  images.isEmpty
                              ? null
                              : submitCashflow,
                          child: Text(
                            '${statusName()} ${CurrencyFormat.currency(amount)}',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

class PickedImage extends StatelessWidget {
  const PickedImage({
    super.key,
    required this.image,
    required this.onDelete,
  });

  final XFile image;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, right: 10),
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.file(
              File(image.path),
              fit: BoxFit.cover,
              width: 90,
              height: 90,
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              iconSize: 15,
              constraints: const BoxConstraints(),
              style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Colors.white.withOpacity(0.4)),
              padding: const EdgeInsets.all(3),
              onPressed: onDelete,
              icon: const Icon(
                Icons.close_rounded,
              ),
            ),
          )
        ],
      ),
    );
  }
}
