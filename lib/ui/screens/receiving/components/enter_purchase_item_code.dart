import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/ui/components/barcode_scanner/barcode_scanner.dart';

class EnterPurchaseItemCode extends StatefulWidget {
  const EnterPurchaseItemCode(
      {super.key, required this.itemName, required this.onSubmit});

  final String itemName;
  final Function(String) onSubmit;

  @override
  State<EnterPurchaseItemCode> createState() => _EnterPurchaseItemCodeState();
}

class _EnterPurchaseItemCodeState extends State<EnterPurchaseItemCode> {
  TextEditingController codeController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
  }

  void onClearCode() {
    setState(() {
      codeController.text = '';
    });
  }

  void scanItemBarcode() => showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return BarcodeScanner(
          onCaptured: (barcode, cb) {
            context.pop();
            widget.onSubmit(barcode);
          },
        );
      });

  @override
  Widget build(BuildContext context) {
    Widget codeSearchInput = TextFormField(
      textInputAction: TextInputAction.search,
      controller: codeController,
      onChanged: (value) => setState(() {
        codeController.text = value;
      }),
      focusNode: focusNode,
      onEditingComplete: () => widget.onSubmit(codeController.text),
      decoration: InputDecoration(
        labelText: 'please_enter_x'.tr(args: ['sku_number'.tr()]),
        hintText: 'sku_number'.tr(),
        labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey.shade600,
            ),
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            codeController.text != ''
                ? IconButton(
                    onPressed: onClearCode,
                    icon: const Icon(
                      CupertinoIcons.xmark,
                      size: 16,
                    ),
                  )
                : Container()
          ],
        ),
        prefixIcon: const Icon(Icons.search),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        alignLabelWithHint: false,
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey.shade400,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            width: 1,
            color: Colors.teal.shade400,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            width: 1,
            color: Colors.red.shade400,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            width: 1,
            color: Colors.teal.shade400,
          ),
        ),
      ),
    );

    return Container(
      padding: EdgeInsets.only(
        top: 10,
        left: 12.5,
        right: 12.5,
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: Colors.blueGrey.shade100,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Colors.blueGrey.shade100,
                ),
              ),
            ),
            child: Text(
              widget.itemName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: codeSearchInput),
              const SizedBox(width: 5),
              IconButton(
                onPressed: scanItemBarcode,
                icon: const Icon(CupertinoIcons.barcode_viewfinder),
              )
            ],
          ),
        ],
      ),
    );
  }
}
