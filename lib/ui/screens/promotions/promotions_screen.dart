import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/promotion/promotion_provider.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/components/generic/item_list_skeleton.dart';
import 'package:selleri/utils/formater.dart';

class PromotionsScreen extends ConsumerStatefulWidget {
  const PromotionsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PromotionsScreenState();
}

class _PromotionsScreenState extends ConsumerState<PromotionsScreen> {
  String getPromotionType(int type) {
    switch (type) {
      case 2:
        return 'transaction'.tr();
      case 3:
        return 'item'.tr();
      default:
        return 'A get B';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('promotions'.tr()),
        elevation: 3,
        iconTheme: const IconThemeData(color: Colors.black87),
        actionsIconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(promotionStreamProvider.notifier).loadPromotions(),
        child: ref.watch(promotionStreamProvider).when(
              data: (data) => data.isNotEmpty
                  ? ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final promo = data[index];
                        return ListTile(
                          tileColor: promo.status
                              ? Colors.white
                              : Colors.grey.shade200,
                          shape: Border(
                            bottom: BorderSide(
                              width: 0.5,
                              color: Colors.blueGrey.shade50,
                            ),
                          ),
                          title: Text(
                            promo.name,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              promo.startDate != null
                                  ? Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 3, top: 1),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            CupertinoIcons.calendar,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            [
                                              DateTimeFormater.dateToString(
                                                  promo.startDate!,
                                                  format: 'dd MMM'),
                                              DateTimeFormater.dateToString(
                                                  promo.endDate!,
                                                  format: 'dd MMM'),
                                            ].join(' - '),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              promo.description != null
                                  ? Text(
                                      promo.description!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                              color: Colors.grey.shade700),
                                    )
                                  : Container()
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                                color: promo.type == 3
                                    ? Colors.blue.shade100
                                    : promo.type == 1
                                        ? Colors.orange.shade100
                                        : Colors.green.shade100,
                                borderRadius: BorderRadius.circular(15)),
                            child: Text(
                              getPromotionType(promo.type),
                              style: TextStyle(
                                  color: promo.type == 3
                                      ? Colors.blue.shade600
                                      : promo.type == 1
                                          ? Colors.orange.shade600
                                          : Colors.green.shade600),
                            ),
                          ),
                        );
                      },
                    )
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text('no_data'.tr(args: ['promotions'.tr()]))
                        ],
                      ),
                    ),
              error: (error, stackTrace) => ErrorHandler(
                error: error.toString(),
                stackTrace: stackTrace.toString(),
              ),
              loading: () => ListView.builder(
                itemCount: 10,
                itemBuilder: (context, _) => const ItemListSkeleton(
                  leading: false,
                ),
              ),
            ),
      ),
    );
  }
}
