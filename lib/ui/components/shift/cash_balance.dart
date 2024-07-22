import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/utils/formater.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CashBalance extends ConsumerStatefulWidget {
  const CashBalance({super.key});

  @override
  ConsumerState<CashBalance> createState() => _CashBalanceState();
}

class _CashBalanceState extends ConsumerState<CashBalance> {
  @override
  Widget build(BuildContext context) {
    final outletState = ref.watch(outletNotifierProvider).value;
    return outletState is OutletSelected
        ? ActionChip(
            tooltip: 'cash_balance'.tr(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.amber.shade50.withOpacity(0.5),
            labelStyle: const TextStyle(
              color: Colors.teal,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            onPressed: outletState.isSyncing == true
                ? null
                : () => ref
                    .read(outletNotifierProvider.notifier)
                    .refreshConfig(only: ['saldo_akun_kas']),
            label: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                outletState.isSyncing == true
                    ? const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Colors.amber,
                        size: 16,
                      ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  CurrencyFormat.currency(
                    outletState.config.saldoAkunKas,
                  ),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.amber, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            side: const BorderSide(color: Colors.transparent),
          )
        : Container();
  }
}
