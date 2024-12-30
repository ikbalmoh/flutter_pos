import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/receiving/purchase_item.dart';

class PurchaseItemList extends StatelessWidget {
  final PurchaseItem item;
  final Function(PurchaseItem) onReceive;
  final int receiveQty;
  final String type;

  const PurchaseItemList({
    required this.item,
    required this.onReceive,
    required this.receiveQty,
    required this.type,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget variants = item.variants != null && item.variants!.isNotEmpty
        ? Container(
            margin: const EdgeInsets.only(right: 15),
            child: Row(
              children: [
                Icon(
                  Icons.list,
                  size: 18,
                  color: Colors.amber.shade600,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text('${item.variants!.length} ${'variants'.tr()}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade700,
                        ))
              ],
            ),
          )
        : Container();

    Row qtyReceived = Row(
      children: [
        const Icon(
          CupertinoIcons.checkmark_square,
          size: 16,
          color: Colors.grey,
        ),
        const SizedBox(
          width: 5,
        ),
        Text('${item.qtyReceived}/${item.qtyRequest} ${'received'.tr()}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade700,
                ))
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: () => onReceive(item),
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: receiveQty > 0 ? Colors.teal : Colors.blueGrey.shade50,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.itemName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      Text(
                          item.skuNumber != null
                              ? item.skuNumber!
                              : 'no_sku'.tr(),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade800,
                                  )),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [variants, qtyReceived],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                receiveQty > 0
                    ? Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(
                            Radius.circular(999),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        margin: const EdgeInsets.only(right: 10),
                        child: Text(
                          receiveQty.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                        ),
                      )
                    : TextButton.icon(
                        style: TextButton.styleFrom(
                            backgroundColor:
                                Colors.teal.shade50.withValues(alpha: 0.7)),
                        onPressed: () => onReceive(item),
                        icon: Icon(type == '1'
                            ? CupertinoIcons.barcode_viewfinder
                            : CupertinoIcons.checkmark_alt),
                        label: Text('receive'.tr()))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
