import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/features/cart/model/cart.dart';
import 'package:selleri/features/cart/model/cart_voucher.dart';
import 'package:selleri/features/item/model/item_cart.dart';
import 'package:selleri/features/outlet/provider/outlet_state.dart';
import 'package:selleri/shared/utils/formater.dart';
import 'order_item.dart';
import 'receipt_attributes.dart';

class OrderSummary extends StatelessWidget {
  final Cart cart;
  final Radius? radius;
  final MainAxisSize? mainAxisSize;
  final bool? withAttribute;
  final bool taxable;
  final OutletSelected outletState;
  final Function? onChangeRoundingValue;

  const OrderSummary({
    required this.cart,
    this.onChangeRoundingValue,
    this.radius,
    this.mainAxisSize,
    this.withAttribute,
    required this.taxable,
    required this.outletState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    Widget summaryContent = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (withAttribute == true)
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: ReceiptHeader(
              outletState: outletState,
            ),
          ),
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
                '${'customer'.tr()}: ${cart.idCustomer != null ? [
                    cart.customerName,
                    cart.vehicle?.licensePlate
                  ].whereType<String>().join(' - ') : 'walk_in'.tr()}',
                textAlign: TextAlign.left,
              ),
              if (cart.tables != null && cart.tables!.isNotEmpty)
                Text(
                  '${'table'.tr()}: ${cart.tables?.join(', ') ?? '-'}',
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

    CartVoucher? voucher =
        cart.vouchers.isNotEmpty ? cart.vouchers.first : null;

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
          voucher != null && voucher.voucherType == 'discount'
              ? TwoColumn(
                  label: '${'voucher'.tr()} (${voucher.code})',
                  value: -voucher.value,
                )
              : TwoColumn(
                  label:
                      '${'discount'.tr()} ${cart.discIsPercent && cart.discOverall > 0 ? '(${CurrencyFormat.currency(cart.discOverall, symbol: false)}%)' : ''}',
                  value: -cart.discOverallTotal,
                ),
          if (cart.discPromotionsTotal > 0)
            TwoColumn(
              label: 'promotions'.tr(),
              value: cart.discPromotionsTotal,
            ),
          if (outletState.config.printIncludePpn == true || !cart.ppnIsInclude)
            TwoColumn(
              label: 'tax'.tr(),
              value: cart.ppnTotal,
            ),
          TwoColumn(
            label: 'Total',
            value: cart.total,
            labelStyle: textTheme.bodyLarge
                ?.copyWith(color: Colors.black87, fontWeight: FontWeight.w700),
            valueStyle: textTheme.bodyLarge
                ?.copyWith(color: Colors.black87, fontWeight: FontWeight.w700),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'rounding'.tr(),
                style: textTheme.bodyLarge?.copyWith(
                    color: Colors.black87, fontWeight: FontWeight.w700),
              ),
              onChangeRoundingValue != null
                  ? Expanded(
                      child: GestureDetector(
                        onTap: () => onChangeRoundingValue!(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.edit,
                                size: 12,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 5),
                              Text(
                                CurrencyFormat.currency(
                                  cart.roundingValue,
                                  symbol: false,
                                ),
                                style: textTheme.bodyLarge
                                    ?.copyWith(color: Colors.blue.shade500),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : Text(
                      CurrencyFormat.currency(
                        cart.roundingValue,
                        symbol: false,
                      ),
                      style:
                          textTheme.bodyLarge?.copyWith(color: Colors.black87),
                    ),
            ],
          ),
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
          if (cart.vouchers.where((v) => v.voucherType == 'payment').isNotEmpty)
            ...cart.vouchers
                .where((v) => v.voucherType == 'payment')
                .map((voucher) {
              return TwoColumn(
                label: "${'voucher'.tr()} (${voucher.code})",
                value: voucher.value,
              );
            }),
          if (cart.payments.isNotEmpty)
            ...cart.payments.map((payment) {
              return TwoColumn(
                label: payment.paymentName,
                value: payment.paymentValue,
              );
            }),
          TwoColumn(
            label: 'payment_amount'.tr(),
            value: cart.totalPayment,
            labelStyle: textTheme.bodyLarge
                ?.copyWith(color: Colors.black87, fontWeight: FontWeight.w700),
            valueStyle:
                textTheme.bodyLarge?.copyWith(color: Colors.green.shade700),
          ),
          if (cart.totalPayment < cart.grandTotal)
            TwoColumn(
              label: 'insufficient_payment'.tr(),
              value: cart.grandTotal - cart.totalPayment,
              labelStyle: textTheme.bodyLarge?.copyWith(
                  color: Colors.black87, fontWeight: FontWeight.w700),
              valueStyle:
                  textTheme.bodyLarge?.copyWith(color: Colors.red.shade700),
            ),
          TwoColumn(
            label: 'change'.tr(),
            value: cart.change,
          ),
          const SizedBox(height: 10),
          if (withAttribute == true &&
              outletState.config.attributeReceipts != null)
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: ReceiptFooter(
                  attributeReceipts: outletState.config.attributeReceipts!),
            ),
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
            CurrencyFormat.currency(value, symbol: false, minus: true),
            style: valueStyle ??
                textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
