import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/promotion/promotion_provider.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/components/generic/item_list_skeleton.dart';

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
        return 'order';
      case 3:
        return 'product';
      default:
        return 'transaction';
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
                          tileColor: promo.status ? Colors.white : Colors.grey.shade200,
                          shape: Border(
                            bottom: BorderSide(
                              width: 0.5,
                              color: Colors.blueGrey.shade50,
                            ),
                          ),
                          title: Text(
                            promo.name,
                          ),
                          subtitle: promo.description != null
                              ? Text(promo.description!)
                              : null,
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                                color: promo.type == 1
                                    ? Colors.blue.shade100
                                    : promo.type == 2
                                        ? Colors.orange.shade100
                                        : Colors.green.shade100,
                                borderRadius: BorderRadius.circular(15)),
                            child: Text(
                              getPromotionType(promo.type),
                              style: TextStyle(
                                  color: promo.type == 1
                                      ? Colors.blue.shade600
                                      : promo.type == 2
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
