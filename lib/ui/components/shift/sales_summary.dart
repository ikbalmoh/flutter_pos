import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/data/models/shift_summary.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/ui/components/shift/edit_open_amount.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/formater.dart';
import 'package:selleri/utils/transaction.dart';

class SalesSummary extends StatelessWidget {
  final ShiftSummary summary;
  final bool? openCashEditable;

  const SalesSummary({required this.summary, this.openCashEditable, super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return DraggableScrollableSheet(
      maxChildSize: 0.9,
      minChildSize: 0.4,
      initialChildSize: 0.6,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'summary'.tr(),
                    style: textTheme.titleMedium,
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: 18,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SalesSummaryList(
                summary: summary,
                scrollController: scrollController,
                openCashEditable: openCashEditable,
              ),
            )
          ],
        );
      },
    );
  }
}

class SalesSummaryList extends ConsumerWidget {
  const SalesSummaryList({
    super.key,
    required this.summary,
    this.scrollController,
    this.openCashEditable,
  });

  final ShiftSummary summary;
  final bool? openCashEditable;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    void onEditOpenAmount(BuildContext context, double openAmount) async {
      final newAmount = await showDialog(
          context: context,
          builder: (context) {
            return EditOpenAmount(
              openAmount: openAmount,
            );
          });

      if (newAmount != openAmount) {
        if (!isTablet && context.mounted) {
          context.pop();
        }
        ref.read(shiftProvider.notifier).updateOpenAmount(newAmount);
        AppAlert.toast('open_amount_updated_x'
            .tr(args: [CurrencyFormat.currency(newAmount)]));
      }
    }

    final summaries = ShiftUtil.paymentList(summary);
    TextTheme textTheme = Theme.of(context).textTheme;

    return ListView.separated(
      controller: scrollController,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: summaries.length,
      itemBuilder: (context, idx) {
        SummaryItem item = summaries[idx];
        return ListTile(
          tileColor: item.isTotal != null
              ? Colors.blueGrey.shade50.withValues(alpha: 0.6)
              : Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          title: Text(item.label),
          titleTextStyle: textTheme.bodyLarge?.copyWith(
            fontWeight:
                item.isTotal != null ? FontWeight.bold : FontWeight.w400,
          ),
          minTileHeight: 0,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              item.isStartingCash == true && openCashEditable == true
                  ? Builder(builder: (context) {
                      return IconButton(
                        onPressed: () =>
                            onEditOpenAmount(context, item.value ?? 0),
                        icon: Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.blue.shade600,
                        ),
                        tooltip: 'edit_open_amount'.tr(),
                      );
                    })
                  : Container(),
              Text(
                item.value != null
                    ? CurrencyFormat.currency(
                        item.value,
                        symbol: false,
                      )
                    : '',
                style: item.isTotal != null
                    ? textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)
                    : textTheme.bodyLarge,
              )
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 0,
          thickness: 0.5,
          color: Colors.blueGrey.shade100,
        );
      },
    );
  }
}
