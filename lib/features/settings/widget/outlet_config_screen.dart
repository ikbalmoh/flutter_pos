import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide AppBar;
import 'package:selleri/app/widget/app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/shared/exeptions/offline_exeption.dart';
import 'package:selleri/shared/provider/connectivity_status_provider.dart';
import 'package:selleri/shared/utils/app_alert.dart';
import 'package:selleri/features/outlet/provider/outlet_provider.dart';
import 'package:selleri/features/outlet/model/outlet_config.dart';

class OutletConfigScreen extends StatelessWidget {
  const OutletConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('outlet_config'.tr()),
        actions: const [
          SyncConfigButton(),
        ],
      ),
      body: const OutletConfigView(),
    );
  }
}

class SyncConfigButton extends ConsumerStatefulWidget {
  const SyncConfigButton({super.key});

  @override
  ConsumerState<SyncConfigButton> createState() => _SyncConfigButtonState();
}

class _SyncConfigButtonState extends ConsumerState<SyncConfigButton> {
  bool _inSync = false;

  void _runSync() async {
    try {
      setState(() {
        _inSync = true;
      });
      final isOffline = ref.read(connectivityStatusProvider) ==
          ConnectivityState.disconnected;

      if (isOffline) {
        throw OfflineException();
      }
      
      await ref.read(outletProvider.notifier).refreshConfig();
      if (!mounted) return;
      
      AppAlert.toast('synced'.tr());
    } catch (e) {
      if (!mounted) return;
      AppAlert.snackbar(e.toString(), alertType: AlertType.error);
    } finally {
      if (mounted) {
        setState(() {
          _inSync = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _inSync
        ? const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          )
        : IconButton(
            icon: const Icon(CupertinoIcons.refresh),
            onPressed: _runSync,
            tooltip: 'run_sync'.tr(),
          );
  }
}

class OutletConfigView extends ConsumerStatefulWidget {
  const OutletConfigView({super.key});

  @override
  ConsumerState<OutletConfigView> createState() => _OutletConfigViewState();
}

class _OutletConfigViewState extends ConsumerState<OutletConfigView> {

  String _formatKey(String key) {
    return key.split('_').map((word) {
      if (word.isEmpty) return '';
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join(' ');
  }

  String _formatValue(dynamic value) {
    if (value == null) return '-';
    if (value is bool) return value ? 'yes'.tr() : 'no'.tr();
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final outletState = ref.watch(outletProvider).value;

    if (outletState is! OutletSelected) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final OutletConfig config = outletState.config;
    final Map<String, dynamic> configMap = {
      'max_offline': config.maxOffline,
      'sale_with_pic': config.saleWithPic,
      'customer_trans_mandatory': config.customerTransMandatory,
      'stock_minus': config.stockMinus,
      'partial_payment': config.partialPayment,
      'tax': config.taxable,
      'extra_item': config.extraItem,
      'auto_shift': config.autoShift,
      'decimal_places': config.decimalPlaces,
      'default_open_amount': config.defaultOpenAmount,
      'discount_overall': config.discountOverall,
      'generate_sku': config.generateSku,
      'generate_barcode': config.generateBarcode,
      'print_include_ppn': config.printIncludePpn,
      'show_work_duration': config.showWorkDuration,
      'show_cash_account_balance': config.showCashAccountBalance,
    };

    return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: configMap.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.black12),
        itemBuilder: (context, index) {
          final entry = configMap.entries.elementAt(index);
          return ListTile(
            title: Text(
              _formatKey(entry.key),
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            trailing: Text(
              _formatValue(entry.value),
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
            tileColor: Colors.white,
          );
        },
      ),
    );
  }
}
