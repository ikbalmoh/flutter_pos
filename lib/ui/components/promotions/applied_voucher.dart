import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/voucher.dart';
import 'package:selleri/providers/cart/cart_provider.dart';
import 'package:selleri/utils/formater.dart';

class AppliedVoucher extends ConsumerWidget {
  final Voucher voucher;

  const AppliedVoucher({
    super.key,
    required this.voucher,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: Colors.orange.shade200),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  CupertinoIcons.ticket_fill,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      voucher.code,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                    Text(
                      voucher.promoName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade900,
                          ),
                    ),
                    const SizedBox(height: 5),
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
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                        ),
                      ],
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
                  voucher.voucherType == 'discount'
                      ? CurrencyFormat.currency(
                          ref.watch(cartProvider).discOverallTotal,
                          minus: true,
                        )
                      : voucher.isPercent
                          ? '${voucher.discountValue}%'
                          : CurrencyFormat.currency(
                              voucher.discountValue.toDouble(),
                              minus: true,
                            ),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.red.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
