import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/features/cart/model/cart.dart';
import 'package:selleri/features/cart/model/cart_voucher.dart';
import 'package:selleri/features/item/model/item_cart.dart';
import 'package:selleri/features/outlet/provider/outlet_state.dart';
import 'package:selleri/shared/utils/formater.dart';
import 'order_item.dart';
import 'receipt_attributes.dart';

const _receiptStyle = TextStyle(fontSize: 20, color: Colors.black);

class OrderSummary extends StatelessWidget {
  final Cart cart;
  final Radius? radius;
  final MainAxisSize? mainAxisSize;
  final bool? withAttribute;
  final bool taxable;
  final OutletSelected outletState;
  final Function? onChangeRoundingValue;
  final bool asReceipt;
  final bool withPrice;

  const OrderSummary({
    required this.cart,
    this.onChangeRoundingValue,
    this.radius,
    this.mainAxisSize,
    this.withAttribute,
    required this.taxable,
    required this.outletState,
    this.asReceipt = false,
    this.withPrice = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    final TextStyle? infoStyle = asReceipt ? _receiptStyle : null;

    final TextStyle boldStyle = asReceipt
        ? _receiptStyle
        : textTheme.bodyLarge!
            .copyWith(color: Colors.black87, fontWeight: FontWeight.w700);

    final TextStyle greenBoldStyle = asReceipt
        ? _receiptStyle
        : textTheme.bodyLarge!.copyWith(color: Color(0xFF388E3C));

    final TextStyle redBoldStyle = asReceipt
        ? _receiptStyle
        : textTheme.bodyLarge!
            .copyWith(color: Color(0xFFD32F2F), fontWeight: FontWeight.w700);

    final showWorkDuration = outletState.config.showWorkDuration == true;

    Widget summaryContent = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (withAttribute == true)
          Padding(
            padding: asReceipt
                ? const EdgeInsets.only(bottom: 8)
                : const EdgeInsets.only(top: 20, bottom: 10),
            child: ReceiptHeader(
              outlet: outletState.outlet,
              attributeReceipts: outletState.config.attributeReceipts,
              asReceipt: asReceipt,
            ),
          ),
        Padding(
          padding: asReceipt
              ? const EdgeInsets.symmetric(vertical: 4)
              : const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'No: ${cart.transactionNo}',
                style: infoStyle,
                textAlign: TextAlign.left,
              ),
              Text(
                '${'cashier'.tr()}: ${cart.createdName}',
                style: infoStyle,
                textAlign: TextAlign.left,
              ),
              Text(
                '${'date'.tr()}: ${DateTimeFormater.msToString(cart.transactionDate, format: 'd/MM/y HH:mm')}',
                style: infoStyle,
                textAlign: TextAlign.left,
              ),
              Text(
                '${'customer'.tr()}: ${cart.idCustomer != null ? [
                    cart.customerName,
                    cart.vehicle?.licensePlate
                  ].whereType<String>().join(' - ') : 'walk_in'.tr()}',
                style: infoStyle,
                textAlign: TextAlign.left,
              ),
              if (cart.tables != null && cart.tables!.isNotEmpty)
                Text(
                  '${'table'.tr()}: ${cart.tables?.join(', ') ?? '-'}',
                  style: infoStyle,
                  textAlign: TextAlign.left,
                ),
              if (showWorkDuration)
                Text(
                  cart.holdAt != null
                      ? '${'work_duration'.tr()}: ${DateTimeFormater.formatDuration(DateTime.fromMillisecondsSinceEpoch(cart.transactionDate).toLocal().difference(cart.holdAt!.toLocal()))}'
                      : '${'work_duration'.tr()}: -',
                  style: infoStyle,
                  textAlign: TextAlign.left,
                ),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: asReceipt == true ? Colors.black : Colors.blueGrey.shade50,
        ),
        ListView.builder(
          padding: EdgeInsets.symmetric(vertical: asReceipt ? 4 : 7.5),
          itemBuilder: (context, idx) {
            ItemCart item = cart.items[idx];
            return OrderItem(
              item: item,
              asReceipt: asReceipt,
            );
          },
          itemCount: cart.items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );

    CartVoucher? voucher =
        cart.vouchers.isNotEmpty ? cart.vouchers.first : null;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          color: asReceipt == true ? Colors.black : Colors.blueGrey.shade50,
        ),
        SizedBox(height: asReceipt ? 4 : 7),
        TwoColumn(
          label: 'Subtotal',
          value: cart.subtotal,
          asReceipt: asReceipt,
        ),
        voucher != null && voucher.voucherType == 'discount'
            ? TwoColumn(
                label: '${'voucher'.tr()} (${voucher.code})',
                value: -voucher.value,
                asReceipt: asReceipt,
              )
            : TwoColumn(
                label:
                    '${'discount'.tr()} ${cart.discIsPercent && cart.discOverall > 0 ? '(${CurrencyFormat.currency(cart.discOverall, symbol: false)}%)' : ''}',
                value: -cart.discOverallTotal,
                asReceipt: asReceipt,
              ),
        if (cart.discPromotionsTotal > 0)
          TwoColumn(
            label: 'promotions'.tr(),
            value: cart.discPromotionsTotal,
            asReceipt: asReceipt,
          ),
        if (outletState.config.printIncludePpn == true || !cart.ppnIsInclude)
          TwoColumn(
            label: 'tax'.tr(),
            value: cart.ppnTotal,
            asReceipt: asReceipt,
          ),
        TwoColumn(
          label: 'Total',
          value: cart.total,
          labelStyle: boldStyle,
          valueStyle: boldStyle,
          asReceipt: asReceipt,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'rounding'.tr(),
              style: boldStyle,
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
                              style: asReceipt
                                  ? _receiptStyle
                                  : textTheme.bodyLarge
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
                    style: boldStyle,
                  ),
          ],
        ),
        TwoColumn(
          label: 'Grand Total',
          value: cart.grandTotal,
          labelStyle: boldStyle,
          valueStyle: boldStyle,
          asReceipt: asReceipt,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          child: Divider(
            height: 1,
            color: asReceipt == true ? Colors.black : Colors.blueGrey.shade50,
          ),
        ),
        if (cart.vouchers.where((v) => v.voucherType == 'payment').isNotEmpty)
          ...cart.vouchers
              .where((v) => v.voucherType == 'payment')
              .map((voucher) {
            return TwoColumn(
              label: "${'voucher'.tr()} (${voucher.code})",
              value: voucher.value,
              asReceipt: asReceipt,
            );
          }),
        if (cart.payments.isNotEmpty)
          ...cart.payments.map((payment) {
            return TwoColumn(
              label: payment.paymentName,
              value: payment.paymentValue,
              asReceipt: asReceipt,
            );
          }),
        TwoColumn(
          label: 'payment_amount'.tr(),
          value: cart.totalPayment,
          labelStyle: boldStyle,
          valueStyle: greenBoldStyle,
          asReceipt: asReceipt,
        ),
        if (cart.totalPayment < cart.grandTotal)
          TwoColumn(
            label: 'insufficient_payment'.tr(),
            value: cart.grandTotal - cart.totalPayment,
            labelStyle: boldStyle,
            valueStyle: redBoldStyle,
            asReceipt: asReceipt,
          ),
        TwoColumn(
          label: 'change'.tr(),
          value: cart.change,
          asReceipt: asReceipt,
        ),
        Divider(
          height: 10,
          color: asReceipt == true ? Colors.black : Colors.blueGrey.shade50,
        ),
        if (cart.notes != null && cart.notes!.isNotEmpty)
          Text(
            cart.notes!,
            style: asReceipt
                ? _receiptStyle
                : textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
            textAlign: TextAlign.left,
          ),
        if (withAttribute == true &&
            outletState.config.attributeReceipts != null)
          Padding(
            padding: asReceipt
                ? const EdgeInsets.only(top: 8, bottom: 8)
                : const EdgeInsets.only(top: 20, bottom: 10),
            child: ReceiptFooter(
                attributeReceipts: outletState.config.attributeReceipts!),
          ),
      ],
    );

    final container = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          radius ?? const Radius.circular(0),
        ),
      ),
      padding: asReceipt
          ? const EdgeInsets.only(bottom: 30)
          : const EdgeInsets.all(15),
      child: content,
    );

    if (asReceipt) {
      return DefaultTextStyle(style: _receiptStyle, child: container);
    }
    return container;
  }
}

class TwoColumn extends StatelessWidget {
  const TwoColumn({
    super.key,
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
    this.asReceipt = false,
  });

  final String label;
  final double value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final bool asReceipt;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    final effectiveLabelStyle = asReceipt
        ? _receiptStyle
        : labelStyle ??
            textTheme.bodySmall?.copyWith(color: Colors.grey.shade700);

    final effectiveValueStyle = asReceipt
        ? _receiptStyle
        : valueStyle ??
            textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: effectiveLabelStyle,
          ),
          Text(
            CurrencyFormat.currency(value, symbol: false, minus: true),
            style: effectiveValueStyle,
          ),
        ],
      ),
    );
  }
}
