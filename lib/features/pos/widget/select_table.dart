import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/features/cart/model/cart.dart' as model;
import 'package:selleri/features/cart/provider/cart_provider.dart';
import 'package:selleri/shared/router/routes.dart';

class SelectTable extends ConsumerStatefulWidget {
  const SelectTable({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectTableState();
}

class _SelectTableState extends ConsumerState<SelectTable> {
  @override
  Widget build(BuildContext context) {
    model.Cart cart = ref.watch(cartProvider);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Material(
      child: InkWell(
        onTap: () => context.push(Routes.tables),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              Icon(
                CupertinoIcons.square_grid_3x2,
                color: Colors.grey.shade700,
              ),
              Expanded(
                child: Text(
                  'table'.tr(),
                  style: textTheme.bodyLarge,
                ),
              ),
              Text(
                cart.tables == null || cart.tables!.isEmpty
                    ? 'select'.tr()
                    : cart.tables!.join(','),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.teal),
              ),
              cart.tables == null || cart.tables!.isEmpty
                  ? Icon(
                      CupertinoIcons.chevron_right,
                      size: 16,
                      color: Colors.teal,
                    )
                  : IconButton(
                      visualDensity: VisualDensity.compact,
                      iconSize: 16,
                      onPressed: () =>
                          ref.read(cartProvider.notifier).clearTables(),
                      icon: Icon(
                        CupertinoIcons.xmark,
                        color: Colors.red,
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
