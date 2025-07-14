import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';

class VerificatorPicker extends ConsumerWidget {
  final String description;
  final ScrollController? scrollController;

  const VerificatorPicker(
      {super.key, required this.description, this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userHasPinList =
        (ref.watch(outletProvider).value as OutletSelected).config.userHasPin ??
            [];
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(
                top: 15, left: 17.5, right: 15, bottom: 10),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'select_x'.tr(args: ['verificator'.tr()]),
                      style: Theme.of(context).textTheme.headlineSmall,
                      maxLines: 2,
                    ),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 2,
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  iconSize: 18,
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey.shade700,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: userHasPinList.length,
              itemBuilder: (context, index) {
                final user = userHasPinList[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 0,
                  ),
                  title: Text(user.userName),
                  subtitle: user.rolesName != null && user.rolesName!.isNotEmpty
                      ? Text(user.rolesName!.join(', '))
                      : null,
                  onTap: () => Navigator.of(context).pop(user),
                  leading: Icon(Icons.lock_outline_rounded),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
