import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/voucher.dart';
import 'package:selleri/utils/formater.dart';

class VoucherCard extends StatelessWidget {
  final Voucher voucher;
  final VoidCallback onTap;
  final bool disabled;
  final String? disabledReason;

  const VoucherCard({
    super.key,
    required this.voucher,
    required this.onTap,
    this.disabled = false,
    this.disabledReason,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1,
              color: disabled ? Colors.grey.shade300 : Colors.orange.shade200,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: disabled ? Colors.grey.shade50 : Colors.orange.shade50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: disabled
                            ? Colors.grey.shade100
                            : Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        voucher.voucherType == 'discount'
                            ? CupertinoIcons.ticket_fill
                            : CupertinoIcons.creditcard_fill,
                        color: disabled ? Colors.grey : Colors.orange,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            voucher.promoName,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: disabled
                                      ? Colors.grey.shade700
                                      : Colors.orange.shade900,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            voucher.code,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: disabled
                                          ? Colors.grey.shade500
                                          : Colors.orange.shade700,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        voucher.isPercent
                            ? '${CurrencyFormat.currency(voucher.discountValue, symbol: false)}%'
                            : CurrencyFormat.currency(voucher.discountValue),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: disabled
                                  ? Colors.grey.shade600
                                  : Colors.orange.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        Icon(
                          CupertinoIcons.tag,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        Text(
                          '${voucher.voucherType.tr()} ${voucher.isPercent ? '${CurrencyFormat.currency(voucher.discountValue, symbol: false)}%' : CurrencyFormat.currency(voucher.discountValue)}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.calendar,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${DateTimeFormater.dateToString(voucher.start, format: 'dd MMM yyyy')} - ${DateTimeFormater.dateToString(voucher.end, format: 'dd MMM yyyy')}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.info_circle,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            voucher.description,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    if (disabled) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.exclamationmark_circle,
                              size: 16,
                              color: Colors.red.shade600,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                disabledReason ??
                                    'cannot_use_with_promotion'.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.red.shade600,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
