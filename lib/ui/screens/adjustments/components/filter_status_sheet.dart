import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FilterStatusSheet extends StatefulWidget {
  const FilterStatusSheet({
    super.key,
    required this.selected,
  });

  final String selected;

  @override
  State<FilterStatusSheet> createState() => _FilterStatusSheetState();
}

class _FilterStatusSheetState extends State<FilterStatusSheet> {
  String filter = 'all';

  @override
  void initState() {
    setState(() {
      filter = widget.selected;
    });
    super.initState();
  }

  void onChangeFilter(String value) {
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
                  'filter_by_x'.tr(args: ['status']),
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
                onTap: () => onChangeFilter('all'),
                trailing: filter == 'all'
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
                title: Text('new'.tr()),
                dense: true,
                onTap: () => onChangeFilter('new'),
                trailing: filter == 'new'
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
                title: Text('approved'.tr()),
                dense: true,
                onTap: () => onChangeFilter('approve'),
                trailing: filter == 'approve'
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
                title: Text('rejected'.tr()),
                dense: true,
                onTap: () => onChangeFilter('reject'),
                trailing: filter == 'reject'
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
