import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/item_attribute_variant.dart';
import 'package:selleri/providers/item/item_provider.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/widgets/loading_widget.dart';

enum Status { loading, success, error }

class StoreItem extends ConsumerStatefulWidget {
  final Map<String, dynamic> itemPayload;
  final List<AttributeVariant> attributes;

  const StoreItem(
      {super.key, required this.itemPayload, required this.attributes});

  @override
  ConsumerState<StoreItem> createState() => _StoreItemState();
}

class _StoreItemState extends ConsumerState<StoreItem> {
  Status status = Status.loading;
  String error = '';

  @override
  void initState() {
    super.initState();
    submitItem();
  }

  void submitItem() async {
    setState(() {
      status = Status.loading;
    });
    try {
      log('store item: ${widget.itemPayload}\n${widget.attributes}');
      await ref
          .read(ItemsStreamProvider().notifier)
          .storeItem(widget.itemPayload, widget.attributes);
      setState(() {
        status = Status.success;
      });
    } on Exception catch (e) {
      setState(() {
        error = e.toString();
        status = Status.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        actions: status == Status.error
            ? [
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
                  onPressed: () => context.pop(false),
                  child: Text('cancel'.tr()),
                ),
                TextButton(
                  onPressed: submitItem,
                  child: Text('retry'.tr()),
                )
              ]
            : status == Status.success
                ? [
                    ElevatedButton(
                      onPressed: () {
                        while (context.canPop()) {
                          context.pop(true);
                        }
                      },
                      child: Text('done'.tr()),
                    )
                  ]
                : [],
        content: status == Status.loading
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  const LoadingIndicator(color: Colors.teal),
                  const SizedBox(height: 20),
                  Text(
                    'please_wait'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                ],
              )
            : status == Status.error
                ? ErrorHandler(
                    error: error,
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      const Icon(
                        CupertinoIcons.checkmark_circle,
                        color: Colors.teal,
                        size: 40,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'x_stored'.tr(args: [widget.itemPayload['item_name']]),
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    ],
                  ));
  }
}
