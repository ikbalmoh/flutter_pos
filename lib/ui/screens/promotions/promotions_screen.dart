import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/promotion/promotion_provider.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/components/generic/item_list_skeleton.dart';
import 'package:selleri/ui/components/promotions/promotion_date.dart';
import 'package:selleri/ui/components/promotions/promotion_days.dart';
import 'package:selleri/ui/components/promotions/promotion_times.dart';
import 'package:selleri/ui/components/promotions/promotion_type_badge.dart';
import 'package:selleri/ui/components/search_app_bar.dart';
import 'package:selleri/ui/widgets/loading_widget.dart';

class PromotionsScreen extends ConsumerStatefulWidget {
  const PromotionsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PromotionsScreenState();
}

class _PromotionsScreenState extends ConsumerState<PromotionsScreen> {
  final _searchController = TextEditingController();
  String searchQuery = '';

  bool searchVisible = false;
  Timer? _debounce;

  void onSearchCustomers(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchQuery = query;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final promotions =
        ref.watch(promotionStreamProvider(search: _searchController.text));

    return Scaffold(
      appBar: searchVisible
          ? SearchAppBar(
              controller: _searchController,
              placeholder: 'search_customer'.tr(),
              onBack: () {
                setState(() {
                  searchVisible = false;
                });
                _searchController.text = '';
              },
              onChanged: onSearchCustomers,
            )
          : AppBar(
              title: Text('promotions'.tr()),
              elevation: 3,
              iconTheme: const IconThemeData(color: Colors.black87),
              actionsIconTheme: const IconThemeData(color: Colors.black87),
              titleTextStyle: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              actions: [
                IconButton(
                  onPressed: () => setState(() {
                    searchVisible = true;
                  }),
                  icon: const Icon(CupertinoIcons.search),
                )
              ],
            ),
      body: RefreshIndicator(
          onRefresh: () =>
              ref.read(promotionStreamProvider().notifier).loadPromotions(),
          child: switch (promotions) {
            AsyncData(:final value) => value.isNotEmpty
                ? ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      final promo = value[index];
                      final isExpired = promo.allTime == false &&
                          !(promo.startDate!.isBefore(DateTime.now()) &&
                              promo.endDate!.isAfter(DateTime.now()));
                      final isActive = promo.status && !isExpired;
                      return ListTile(
                        tileColor:
                            isActive ? Colors.white : Colors.grey.shade100,
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
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                promo.allTime == false
                                    ? PromotionDate(promo: promo)
                                    : Container(),
                                PromotionDays(promo: promo),
                                promo.times != null
                                    ? PromotionTimes(promo: promo)
                                    : Container(),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            promo.description != null
                                ? Text(
                                    promo.description!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(color: Colors.grey.shade600),
                                  )
                                : Container()
                          ],
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [PromotionTypeBadge(type: promo.type)],
                        ),
                      );
                    },
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.3),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'no_data'.tr(args: ['promotions'.tr()]),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.grey.shade500,
                                ),
                          )
                        ],
                      ),
                    ),
                  ),
            AsyncLoading() => ListView.builder(
                itemCount: 10,
                itemBuilder: (context, _) => const ItemListSkeleton(
                  leading: false,
                ),
              ),
            AsyncError(:final error) => ErrorHandler(
                error: error.toString(),
              ),
            _ => const LoadingIndicator(color: Colors.teal)
          }),
    );
  }
}
