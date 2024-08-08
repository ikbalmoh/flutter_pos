import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/cart.dart';
import 'package:selleri/data/models/item_cart.dart';
import 'package:selleri/utils/formater.dart';
import 'order_item.dart';
import 'receipt_attributes.dart';

class OrderSummary extends StatelessWidget {
  final Cart cart;
  final Radius? radius;
  final MainAxisSize? mainAxisSize;
  final bool? withAttribute;

  const OrderSummary({
    required this.cart,
    this.radius,
    this.mainAxisSize,
    this.withAttribute,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    Widget summaryContent = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        withAttribute == true
            ? const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: ReceiptHeader(),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
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
        Divider(
          height: 1,
          color: Colors.blueGrey.shade50,
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
      padding: const EdgeInsets.all(15),
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
          Divider(
            height: 1,
            color: Colors.blueGrey.shade50,
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
          TwoColumn(
            label: 'promotions'.tr(),
            value: cart.discPromotionsTotal,
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
          withAttribute == true
              ? const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: ReceiptFooter(),
                )
              : Container(),
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
      padding: const EdgeInsets.symmetric(vertical: 2.5),
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
