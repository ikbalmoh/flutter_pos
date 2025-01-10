import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/item.dart';
import 'package:selleri/data/models/item_variant.dart';
import 'package:selleri/data/objectbox.dart';
import 'package:selleri/ui/screens/item/edit_variant_form.dart';
import 'package:selleri/ui/screens/item/store_managed_variants.dart';
import 'package:selleri/utils/formater.dart';

class ManageItemVariantsScreen extends ConsumerStatefulWidget {
  final String idItem;
  const ManageItemVariantsScreen({super.key, required this.idItem});

  @override
  ConsumerState<ManageItemVariantsScreen> createState() =>
      _ManageItemVariantsScreenState();
}

class _ManageItemVariantsScreenState
    extends ConsumerState<ManageItemVariantsScreen> {
  Item? item;
  List<ItemVariant> variants = [];

  @override
  void initState() {
    Item? masterItem = objectBox.getItem(widget.idItem);
    if (masterItem != null) {
      setState(() {
        item = masterItem;
        variants = masterItem.variants;
      });
    }
    super.initState();
  }

  void onSelect(ItemVariant variant) async {
    ItemVariant? edited = await showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.white,
      isDismissible: true,
      context: context,
      builder: (context) {
        return EditVariantForm(variant: variant);
      },
    );
    if (edited != null) {
      setState(() {
        variants = variants.map((v) => v.id == edited.id ? edited : v).toList();
      });
    }
  }

  void onSubmit() {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        enableDrag: false,
        backgroundColor: Colors.white,
        builder: (context) {
          return StoreManagedVariants(
            idItem: widget.idItem,
            attributes: variants,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('manage_variants'.tr()),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('manage_variants'.tr()),
            Text(
              item!.itemName,
              style: Theme.of(context).textTheme.titleSmall,
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton.icon(
              style: TextButton.styleFrom(backgroundColor: Colors.teal.shade50),
              onPressed: onSubmit,
              icon: const Icon(Icons.check),
              label: Text('save'.tr()),
            ),
          )
        ],
        iconTheme: const IconThemeData(color: Colors.black87),
        actionsIconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      body: variants.isEmpty
          ? const Center(
              child: Text('no_variants'),
            )
          : ListView.separated(
              itemCount: variants.length,
              itemBuilder: (context, idx) {
                final variant = variants[idx];
                return ListTile(
                  title: Text(variant.variantName),
                  subtitle: Text(CurrencyFormat.currency(variant.itemPrice)),
                  trailing: const Icon(
                    Icons.edit,
                    size: 20,
                  ),
                  onTap: () => onSelect(variant),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 1,
                  color: Colors.grey.shade200,
                );
              },
            ),
    );
  }
}
