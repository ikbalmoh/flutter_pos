import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selleri/features/cart/model/cart.dart' as model;
import 'package:selleri/features/outlet/model/outlet_config.dart';
import 'package:selleri/features/cart/provider/cart_provider.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/pos/widget/checkout/payment/qris_payment_modal.dart';
import 'package:selleri/features/pos/widget/select_table.dart';
import 'package:selleri/features/settings/provider/app_settings_provider.dart';
import 'package:selleri/shared/provider/app_config_provider.dart';
import 'package:selleri/shared/widget/generic/picked_image.dart';
import 'package:selleri/shared/widget/generic/custom_text_input.dart';
import 'package:selleri/shared/widget/pic/pic_picker.dart';
import 'package:selleri/features/pos/widget/checkout/store_transaction.dart';
import 'package:selleri/shared/utils/authorization_helper.dart';
import 'package:selleri/shared/utils/formater.dart';

class ConfirmStoreTransaction extends ConsumerStatefulWidget {
  const ConfirmStoreTransaction({super.key, required this.isPartialPayment});

  final bool isPartialPayment;

  @override
  ConsumerState<ConfirmStoreTransaction> createState() =>
      _ConfirmStoreTransactionState();
}

class _ConfirmStoreTransactionState
    extends ConsumerState<ConfirmStoreTransaction> {
  final noteController = TextEditingController();
  List<XFile> images = [];
  List<String> imageNotes = [];
  bool printKitchen = false;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();

    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          printKitchen = ref.read(appSettingsProvider).autoPrintKitchen;
        });
      }
    });

    super.initState();
  }

  Future pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      setState(() {
        images = images..add(image);
        imageNotes = imageNotes..add('');
      });
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
    }
  }

  void onDeleteImage(int index) {
    List<XFile> imgs = List.from(images);
    List<String> imgNotes = List.from(imageNotes);
    imgs.removeAt(index);
    imgNotes.removeAt(index);
    setState(() {
      images = imgs;
      imageNotes = imgNotes;
    });
  }

  void onSubmit(BuildContext context) async {
    model.Cart cart = ref.watch(cartProvider);

    if (cart.totalPayment < cart.grandTotal) {
      final isAuhtorized =
          await AuthorizationHelper.authorize('partial-payment');
      if (!context.mounted) return;
      if (!isAuhtorized) {
        return;
      }
    }

    final cartAction = ref.read(cartProvider.notifier);

    cartAction.addNote(
      notes: noteController.text,
      images: images,
      imageNotes: imageNotes,
    );

    bool isPicRequired = false;
    final outletState = ref.read(outletProvider).value;
    if (outletState is OutletSelected) {
      isPicRequired = outletState.config.saleWithPic == true;
    }

    PersonInCharge? pic;
    if (isPicRequired) {
      pic = await showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.white,
          context: context,
          enableDrag: true,
          useSafeArea: true,
          builder: (context) {
            return const PicPicker();
          });
      if (!context.mounted) return;

      if (pic == null) {
        return;
      }
    }

    log('PIC: ${pic?.name}');

    await cartAction.setPic(pic);

    final OutletConfig outletConfig = (outletState as OutletSelected).config;

    bool? hasTableAddon = outletConfig.addOns?.contains('table');

    // check if using qris payment
    final appConfig = await ref.read(appConfigProvider.future);
    final qrisMethodIds = outletConfig.paymentMethods
            ?.where((p) => p.type == (appConfig.qrisPaymentType ?? 6))
            .map((e) => e.id)
            .toList() ??
        [];

    final qrisPayment = cart.payments.firstWhereOrNull(
        (p) => qrisMethodIds.contains(p.paymentMethodId) && p.id == null);

    if (qrisPayment != null) {
      if (context.mounted) {
        // show qris payment modal
        final isPaid = await QrisPaymentModal.show(
          context,
          transactionNo: cart.transactionNo,
          amount: cart.grandTotal,
        );

        if (isPaid != true) return;
      }
    }

    if (context.mounted) {
      showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        useSafeArea: true,
        builder: (context) => PopScope(
          canPop: false,
          child: StoreTransaction(
            isPartialPayment: widget.isPartialPayment,
            printKitchen: hasTableAddon == true ? printKitchen : false,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle? labelStyle =
        textTheme.bodyMedium?.copyWith(color: Colors.blueGrey.shade600);

    model.Cart cart = ref.watch(cartProvider);

    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    double height =
        MediaQuery.of(context).size.height * (isKeyboardVisible ? 0.95 : 0.8);

    OutletConfig outletConfig =
        (ref.watch(outletProvider).value as OutletSelected).config;

    bool? hasTableAddon = outletConfig.addOns?.contains('table');
    bool isPartialPayment = outletConfig.partialPayment ?? false;

    return SafeArea(
      child: Container(
        height: height,
        padding: EdgeInsets.only(
          top: 10,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 5),
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
                    'finish_x'.tr(args: ['transaction'.tr()]),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(CupertinoIcons.xmark),
                  )
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  cart.totalPayment < cart.grandTotal
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.amber.shade300,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(CupertinoIcons.info),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                  child:
                                      Text('insufficient_payment_warning'.tr()))
                            ],
                          ),
                        )
                      : Container(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                width: 1,
                                color: Colors.grey.shade200,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Column(
                            children: [
                              Text(
                                'total_transaction'.tr(args: ['']),
                                style: textTheme.titleSmall
                                    ?.copyWith(color: Colors.grey.shade700),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                CurrencyFormat.currency(cart.grandTotal),
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Column(
                            children: [
                              Text(
                                'payment_amount'.tr(args: ['']),
                                style: textTheme.titleSmall
                                    ?.copyWith(color: Colors.grey.shade700),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                CurrencyFormat.currency(cart.totalPayment),
                                style: textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: cart.totalPayment >= cart.grandTotal
                                        ? Colors.green.shade700
                                        : Colors.red),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey.shade200,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextInput(
                    controller: noteController,
                    label: 'add'.tr(args: ['note'.tr()]),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Text(
                          'attachments'.tr(),
                          style: labelStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(images.length, (index) {
                            XFile image = images[index];
                            return PickedImage(
                              source: image.path,
                              sourceType: SourceType.path,
                              onDelete: () => onDeleteImage(index),
                              note: imageNotes.length > index
                                  ? imageNotes[index]
                                  : null,
                              size: 120,
                              withNote: true,
                              onAddNote: (note) => setState(() {
                                imageNotes[index] = note;
                              }),
                            );
                          }),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.blue.shade500,
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
                              foregroundColor: Colors.blue.shade500,
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
                ],
              ),
            )),
            if (!isKeyboardVisible)
              Column(
                spacing: 5,
                children: [
                  Divider(thickness: 0.2),
                  if (hasTableAddon == true) ...[
                    SelectTable(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 10,
                        children: [
                          Icon(
                            Icons.restaurant,
                            color: Colors.grey.shade700,
                          ),
                          Expanded(
                            child: Text(
                              'print_kitchen'.tr(),
                              style: textTheme.bodyLarge,
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            width: 45,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Switch(
                                value: printKitchen,
                                onChanged: (value) {
                                  setState(() {
                                    printKitchen = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                    onPressed: isPartialPayment ||
                            cart.totalPayment >= cart.grandTotal ||
                            cart.grandTotal == 0
                        ? () => onSubmit(context)
                        : null,
                    child: Text('finish'.tr()),
                  ),
                  SizedBox(height: 2),
                ],
              )
          ],
        ),
      ),
    );
  }
}
