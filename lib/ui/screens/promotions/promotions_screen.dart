import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/promotion.dart';
import 'package:selleri/providers/promotion/promotion_list_provider.dart';
import 'package:selleri/providers/promotion/promotions_provider.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/components/generic/date_picker.dart';
import 'package:selleri/ui/components/generic/item_list_skeleton.dart';
import 'package:selleri/ui/components/promotions/promotion_date.dart';
import 'package:selleri/ui/components/promotions/promotion_days.dart';
import 'package:selleri/ui/components/promotions/promotion_policy.dart';
import 'package:selleri/ui/components/promotions/promotion_type_badge.dart';
import 'package:selleri/ui/components/search_app_bar.dart';
import 'package:selleri/ui/screens/promotions/promotion_type_filter.dart';
import 'package:selleri/ui/widgets/loading_widget.dart';
import 'package:selleri/utils/formater.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
  PickerDateRange? range;

  int type = 0;

  void onSearchPromotions({String? query, int? type}) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchQuery = query ?? '';
        type = type ?? 0;
      });
    });
  }

  void showTypeFilter() async {
    final int? selectedType = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return PromotionTypeFilter(selected: type);
        });

    if (selectedType != null) {
      log('selected Type: $selectedType');
      setState(() {
        searchQuery = searchQuery;
        type = selectedType;
      });
    }
  }

  void onShowDatePicker() async {
    final List<DateTime?>? selectedRange = await showModalBottomSheet(
        backgroundColor: Colors.white,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return DatePicker(
            initialForm: range?.startDate,
            initialTo: range?.endDate,
            allowFuture: true,
          );
        });
    log('selected date: $selectedRange');
    setState(() {
      searchQuery = searchQuery;
      type = type;
      range = selectedRange == null
          ? null
          : PickerDateRange(selectedRange[0], selectedRange[1]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final promotions = ref.watch(promotionListProvider(
      search: _searchController.text,
      type: type > 0 ? type : null,
      range: range,
    ));

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
              onChanged: (q) => onSearchPromotions(query: q),
            )
          : AppBar(
              title: Text('promotions'.tr()),
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
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: ActionChip(
                      onPressed: showTypeFilter,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      label: Row(
                        children: [
                          Text(PromotionType.filter()
                              .firstWhere((t) => t.id == type)
                              .name),
                          const SizedBox(
                            width: 15,
                          ),
                          const Icon(CupertinoIcons.chevron_down, size: 16)
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: ActionChip(
                      onPressed: onShowDatePicker,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      label: Row(
                        children: [
                          const Icon(CupertinoIcons.calendar, size: 16),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(range == null
                              ? 'All Date'
                              : [
                                  DateTimeFormater.dateToString(
                                      range!.startDate!,
                                      format: 'dd MMM y'),
                                  DateTimeFormater.dateToString(range!.endDate!,
                                      format: 'dd MMM y')
                                ].join(' - ')),
                          const SizedBox(
                            width: 15,
                          ),
                          const Icon(CupertinoIcons.chevron_down, size: 16)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
                onRefresh: () =>
                    ref.read(promotionsProvider.notifier).loadPromotions(),
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
                              tileColor: isActive
                                  ? Colors.white
                                  : Colors.grey.shade100,
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Wrap(
                                    direction: Axis.horizontal,
                                    spacing: 10,
                                    runSpacing: 3,
                                    children: [
                                      PromotionPolicy(policy: promo.policy),
                                      PromotionDate(
                                          allTime: promo.allTime,
                                          startDate: promo.startDate,
                                          endDate: promo.endDate),
                                      PromotionDays(days: promo.days),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  promo.description != null
                                      ? Text(
                                          promo.description!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                  color: Colors.grey.shade600),
                                        )
                                      : Container()
                                ],
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  PromotionTypeBadge(type: promo.type)
                                ],
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
          ),
        ],
      ),
    );
  }
}
