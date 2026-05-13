import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/features/outlet/model/outlet.dart';
import 'package:selleri/features/outlet/model/outlet_config.dart';
import 'package:selleri/features/shift/model/shift_info.dart';
import 'package:selleri/features/shift/model/shift_summary.dart';
import 'package:selleri/shared/utils/formater.dart';
import 'package:selleri/shared/utils/transaction.dart';
import 'package:selleri/features/cart/widget/components/order_summary/receipt_attributes.dart';

const _receiptStyle = TextStyle(fontSize: 20, color: Colors.black);

class ShiftSummaryReceipt extends StatelessWidget {
  final ShiftInfo shift;
  final Outlet outlet;
  final AttributeReceipts? attributeReceipts;
  final bool asReceipt;
  final bool withAttribute;

  const ShiftSummaryReceipt({
    required this.shift,
    required this.outlet,
    this.attributeReceipts,
    this.asReceipt = false,
    this.withAttribute = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final TextStyle infoStyle =
        asReceipt ? _receiptStyle : textTheme.bodyMedium!;

    final TextStyle boldStyle = asReceipt
        ? _receiptStyle.copyWith(fontWeight: FontWeight.bold)
        : textTheme.bodyLarge!
            .copyWith(color: Colors.black87, fontWeight: FontWeight.w700);

    final TextStyle headerStyle = asReceipt
        ? _receiptStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 22)
        : textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold);

    final List<SummaryItem> summaries = ShiftUtil.paymentList(shift.summary);

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Receipt header (logo, outlet name, address) ──────────────────
        if (withAttribute)
          Padding(
            padding: asReceipt
                ? const EdgeInsets.only(bottom: 8)
                : const EdgeInsets.only(top: 20, bottom: 10),
            child: ReceiptHeader(
              outlet: outlet,
              attributeReceipts: attributeReceipts,
              asReceipt: asReceipt,
            ),
          ),

        // Outlet address & phone (when NOT using ReceiptHeader or as extra detail)
        if (!withAttribute) ...[
          Text(
            shift.outletName ?? '',
            style: headerStyle,
            textAlign: TextAlign.center,
          ),
          if (outlet.outletAddress != null &&
              outlet.outletAddress!.isNotEmpty)
            Text(
              outlet.outletAddress!,
              style: infoStyle,
              textAlign: TextAlign.center,
            ),
          if (outlet.outletPhone != null &&
              outlet.outletPhone!.isNotEmpty)
            Text(
              outlet.outletPhone!,
              style: infoStyle,
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 8),
        ],

        // ── SHIFT REPORT label ────────────────────────────────────────────
        Center(
          child: Text(
            'SHIFT REPORT',
            style: headerStyle,
            textAlign: TextAlign.center,
          ),
        ),

        Divider(
          height: asReceipt ? 12 : 16,
          color: asReceipt ? Colors.black : Colors.blueGrey.shade100,
        ),

        // ── Shift info ────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Code: ${shift.codeShift}', style: infoStyle),
              Text('${'cashier'.tr()}: ${shift.openedBy}', style: infoStyle),
              Text(
                'Open: ${DateTimeFormater.dateToString(shift.openShift, format: 'dd/MM/y HH:mm')}',
                style: infoStyle,
              ),
              Text(
                'Close: ${shift.closeShift != null ? DateTimeFormater.dateToString(shift.closeShift!, format: 'dd/MM/y HH:mm') : '-'}',
                style: infoStyle,
              ),
            ],
          ),
        ),

        Divider(
          height: asReceipt ? 12 : 16,
          color: asReceipt ? Colors.black : Colors.blueGrey.shade100,
        ),

        // ── Payment summary ───────────────────────────────────────────────
        ...summaries.map((summary) {
          if (summary.isTotal == true) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(summary.label, style: boldStyle),
            );
          }
          return _TwoColumn(
            label: '  ${summary.label}',
            value: summary.value ?? 0,
            asReceipt: asReceipt,
          );
        }),

        Divider(
          height: asReceipt ? 12 : 16,
          color: asReceipt ? Colors.black : Colors.blueGrey.shade100,
        ),

        // ── Sold items ────────────────────────────────────────────────────
        if (shift.soldItems.isNotEmpty) ...[
          _TwoColumn(
            label: 'item_sold'.tr(),
            value: shift.soldItems.map((s) => s.sold).reduce((a, b) => a + b),
            labelStyle: boldStyle,
            valueStyle: boldStyle,
            asReceipt: asReceipt,
          ),
          ...shift.soldItems.map(
            (item) => _TwoColumn(
              label: '  ${item.name}',
              value: item.sold,
              asReceipt: asReceipt,
              isQty: true,
            ),
          ),
          Divider(
            height: asReceipt ? 12 : 16,
            color: asReceipt ? Colors.black : Colors.blueGrey.shade100,
          ),
        ],
      ],
    );

    final container = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(asReceipt ? 0 : 12),
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

// ── Helper: two-column row (label + value) ────────────────────────────────────

class _TwoColumn extends StatelessWidget {
  const _TwoColumn({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
    this.asReceipt = false,
    this.isQty = false,
  });

  final String label;
  final double value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final bool asReceipt;

  /// When true, formats the value as a plain quantity (no currency symbol).
  final bool isQty;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

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
          Expanded(
            child: Text(
              label,
              style: effectiveLabelStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            CurrencyFormat.currency(value, symbol: false),
            style: effectiveValueStyle,
          ),
        ],
      ),
    );
  }
}
