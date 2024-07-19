import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/data/models/item.dart';

class FilterItemsSheet extends StatefulWidget {
  const FilterItemsSheet({
    super.key,
    required this.selected,
  });

  final FilterStock selected;

  @override
  State<FilterItemsSheet> createState() => _FilterItemsSheetState();
}

class _FilterItemsSheetState extends State<FilterItemsSheet> {
  FilterStock filter = FilterStock.all;

  @override
  void initState() {
    setState(() {
      filter = widget.selected;
    });
    super.initState();
  }

  void onChangeFilter(FilterStock value) {
    setState(() {
      filter = value;
    });
  }

  void onSubmit() {
    context.pop(filter);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 2, left: 15, right: 15, bottom: 10),
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
                  'filter_items'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.teal,
                  ),
                  onPressed: onSubmit,
                  icon: const Icon(
                    Icons.check,
                    size: 16,
                  ),
                  label: Text('apply'.tr()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ListTile(
                title: Text('all'.tr()),
                dense: true,
                onTap: () => onChangeFilter(FilterStock.all),
                trailing: filter == FilterStock.all
                    ? const Icon(
                        CupertinoIcons.checkmark_alt_circle_fill,
                        color: Colors.teal,
                      )
                    : Icon(
                        CupertinoIcons.circle,
                        color: Colors.grey.shade300,
                      ),
              ),
              ListTile(
                title: Text('on_stock'.tr()),
                dense: true,
                onTap: () => onChangeFilter(FilterStock.available),
                trailing: filter == FilterStock.available
                    ? const Icon(
                        CupertinoIcons.checkmark_alt_circle_fill,
                        color: Colors.teal,
                      )
                    : Icon(
                        CupertinoIcons.circle,
                        color: Colors.grey.shade300,
                      ),
              ),
              ListTile(
                title: Text('out_of_stock'.tr()),
                dense: true,
                onTap: () => onChangeFilter(FilterStock.empty),
                trailing: filter == FilterStock.empty
                    ? const Icon(
                        CupertinoIcons.checkmark_alt_circle_fill,
                        color: Colors.teal,
                      )
                    : Icon(
                        CupertinoIcons.circle,
                        color: Colors.grey.shade300,
                      ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
