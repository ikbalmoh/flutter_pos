import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:selleri/utils/formater.dart';

class OrderItem extends StatelessWidget {
  final ItemCart item;
  const OrderItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    String itemName = item.itemName;
    if (item.variantName != '' && item.variantName != null) {
      itemName += ' - ${item.variantName}';
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            itemName,
            style: textTheme.bodyMedium,
          ),
          item.details.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: item.details
                        .map(
                          (itemPackage) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '- ${itemPackage.quantity} x',
                                style: textTheme.bodySmall
                                    ?.copyWith(color: Colors.black54),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  itemPackage.name,
                                  style: textTheme.bodySmall
                                      ?.copyWith(color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                )
              : Container(),
          item.note != ''
              ? Text(
                  item.note ?? '',
                  style: textTheme.bodySmall,
                )
              : Container(),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  ' ${item.quantity} x ${CurrencyFormat.currency(item.price)}',
                  style: textTheme.bodySmall
                      ?.copyWith(fontSize: 14, color: Colors.grey.shade700),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                children: [
                  (item.price * item.quantity) != item.total
                      ? Text(
                          CurrencyFormat.currency(item.price * item.quantity,
                              symbol: false),
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                          ),
                        )
                      : Container(),
                  Text(
                    CurrencyFormat.currency(item.total, symbol: false),
                    textAlign: TextAlign.right,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class OrderSummary extends StatelessWidget {
  final Cart cart;
  final Radius? radius;
  final bool? isDone;
  final MainAxisSize? mainAxisSize;

  const OrderSummary(
      {required this.cart,
      this.isDone,
      this.radius,
      this.mainAxisSize,
      super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    Widget summaryContent = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'No: ${cart.transactionNo}',
                textAlign: TextAlign.left,
              ),
              Text(
                '${'cashier'.tr()}: ${cart.createdName}',
                textAlign: TextAlign.left,
              ),
              Text(
                '${'date'.tr()}: ${DateTimeFormater.msToString(cart.transactionDate, format: 'd/MM/y HH:mm')}',
                textAlign: TextAlign.left,
              ),
              Text(
                '${'customer'.tr()}: ${cart.customerName ?? '-'}',
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Divider(
            height: 1,
            color: Colors.blueGrey.shade50,
          ),
        ),
        ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 7.5),
          itemBuilder: (context, idx) {
            ItemCart item = cart.items[idx];
            return OrderItem(item: item);
          },
          itemCount: cart.items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          radius ?? const Radius.circular(0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: mainAxisSize ?? MainAxisSize.min,
        children: [
          mainAxisSize == MainAxisSize.max
              ? Expanded(
                  child: SingleChildScrollView(
                    child: summaryContent,
                  ),
                )
              : summaryContent,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Divider(
              height: 1,
              color: Colors.blueGrey.shade50,
            ),
          ),
          const SizedBox(height: 7),
          TwoColumn(
            label: 'Subtotal',
            value: cart.subtotal,
          ),
          TwoColumn(
            label:
                '${'discount'.tr()} ${cart.discIsPercent && cart.discOverall > 0 ? '(${CurrencyFormat.currency(cart.discOverall, symbol: false)}%)' : ''}',
            value: cart.discOverallTotal,
          ),
          cart.ppnTotal > 0
              ? TwoColumn(
                  label: cart.taxName ?? 'tax'.tr(),
                  value: cart.ppnTotal,
                )
              : Container(),
          TwoColumn(
            label: 'Grand Total',
            value: cart.grandTotal,
            labelStyle: textTheme.bodyLarge
                ?.copyWith(color: Colors.black87, fontWeight: FontWeight.w700),
            valueStyle: textTheme.bodyLarge
                ?.copyWith(color: Colors.black87, fontWeight: FontWeight.w700),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            child: Divider(
              height: 1,
              color: Colors.blueGrey.shade50,
            ),
          ),
          TwoColumn(
            label: 'payment_amount'.tr(),
            value: cart.totalPayment,
            labelStyle: textTheme.bodyLarge
                ?.copyWith(color: Colors.black87, fontWeight: FontWeight.w700),
            valueStyle:
                textTheme.bodyLarge?.copyWith(color: Colors.green.shade700),
          ),
          cart.totalPayment < cart.grandTotal
              ? TwoColumn(
                  label: 'insufficient_payment'.tr(),
                  value: cart.grandTotal - cart.totalPayment,
                  labelStyle: textTheme.bodyLarge?.copyWith(
                      color: Colors.black87, fontWeight: FontWeight.w700),
                  valueStyle:
                      textTheme.bodyLarge?.copyWith(color: Colors.red.shade700),
                )
              : Container(),
          TwoColumn(
            label: 'change'.tr(),
            value: cart.change,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class TwoColumn extends StatelessWidget {
  const TwoColumn({
    super.key,
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
  });

  final String label;
  final double value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: labelStyle ??
                textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
          ),
          Text(
            CurrencyFormat.currency(value, symbol: false),
            style: valueStyle ??
                textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
