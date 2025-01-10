import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/item_variant.dart';
import 'package:selleri/providers/item/item_provider.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/components/generic/loading_placeholder.dart';

enum Status { loading, success, error }

class StoreManagedVariants extends ConsumerStatefulWidget {
  final String idItem;
  final List<ItemVariant> attributes;

  const StoreManagedVariants(
      {super.key, required this.idItem, required this.attributes});

  @override
  ConsumerState<StoreManagedVariants> createState() =>
      _StoreManagedVariantsState();
}

class _StoreManagedVariantsState extends ConsumerState<StoreManagedVariants> {
  Status status = Status.loading;
  String error = '';

  @override
  void initState() {
    super.initState();
    submitVariants();
  }

  void submitVariants() async {
    setState(() {
      status = Status.loading;
    });
    try {
      log('update variants: ${widget.attributes}');
      await ref
          .read(ItemsStreamProvider().notifier)
          .updateVariants(widget.idItem, widget.attributes);
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
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 15,
        right: 15,
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: status == Status.loading
            ? [
                const LoadingPlaceholder(),
              ]
            : status == Status.error
                ? [
                    ErrorHandler(
                      error: error,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.grey),
                          onPressed: () => context.pop(false),
                          child: Text('cancel'.tr()),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: submitVariants,
                            child: Text('retry'.tr()),
                          ),
                        ),
                      ],
                    )
                  ]
                : [
                    const SizedBox(height: 20),
                    const Icon(
                      CupertinoIcons.checkmark_circle,
                      color: Colors.teal,
                      size: 40,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'x_stored'.tr(args: ['variants'.tr()]),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        while (context.canPop()) {
                          context.pop(true);
                        }
                      },
                      child: Text('done'.tr()),
                    ),
                  ],
      ),
    );
  }
}
