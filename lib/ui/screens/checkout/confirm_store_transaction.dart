import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:selleri/data/models/cart.dart' as model;
import 'package:selleri/data/models/outlet_config.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/ui/components/generic/picked_image.dart';
import 'package:selleri/ui/components/pic_picker.dart';
import 'package:selleri/ui/screens/checkout/store_transaction.dart';
import 'package:selleri/utils/formater.dart';

class ConfirmStoreTransaction extends ConsumerStatefulWidget {
  const ConfirmStoreTransaction({super.key});

  @override
  ConsumerState<ConfirmStoreTransaction> createState() =>
      _ConfirmStoreTransactionState();
}

class _ConfirmStoreTransactionState
    extends ConsumerState<ConfirmStoreTransaction> {
  final noteController = TextEditingController();
  List<XFile> images = [];

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

  void onSubmit(BuildContext context) async {
    // context.pop();

    final cartAction = ref.read(cartProvider.notifier);

    cartAction.addNote(notes: noteController.text, images: images);

    bool isPicRequired = false;
    final outletState = ref.watch(outletProvider).value;
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
          builder: (context) {
            return const PicPicker();
          });

      if (pic == null) {
        return;
      }
    }

    log('PIC: ${pic?.name}');

    await cartAction.setPic(pic);

    if (context.mounted) {
      showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        builder: (context) => const PopScope(
          canPop: false,
          child: StoreTransaction(),
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
        MediaQuery.of(context).size.height * (isKeyboardVisible ? 0.95 : 0.7);

    return Container(
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
                TextFormField(
                  controller: noteController,
                  decoration: InputDecoration(
                    label: Text(
                      'add'.tr(args: ['note'.tr()]),
                      style: labelStyle,
                    ),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    contentPadding: const EdgeInsets.all(10),
                    focusColor: Colors.teal,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    )),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.teal,
                      width: 1,
                    )),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
              ],
            ),
          )),
          isKeyboardVisible
              ? Container()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () => onSubmit(context),
                  child: Text('finish'.tr()),
                )
        ],
      ),
    );
  }
}
