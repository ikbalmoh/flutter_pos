import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/data/models/shift.dart';
import 'package:selleri/providers/shift/shift_list_provider.dart';
import 'package:selleri/router/routes.dart';
import 'package:selleri/ui/components/error_handler.dart';
import 'package:selleri/ui/components/generic/item_list_skeleton.dart';
import 'package:selleri/ui/screens/shift/shift_history_detail.dart';
import 'package:selleri/ui/widgets/loading_widget.dart';
import 'package:selleri/utils/formater.dart';

class ShiftHistoryScreen extends ConsumerStatefulWidget {
  const ShiftHistoryScreen({super.key});

  @override
  ConsumerState<ShiftHistoryScreen> createState() => _ShiftHistoryScreenState();
}

class _ShiftHistoryScreenState extends ConsumerState<ShiftHistoryScreen>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool searchVisible = false;
  Timer? _debounce;
  Shift? viewShift;

  @override
  void initState() {
    _searchController.addListener(() => onSearchItems(_searchController.text));
    _scrollController.addListener(loadMore);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void onSearchItems(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref
          .read(shiftListNotifierProvider.notifier)
          .loadShifts(page: 1, search: query);
    });
  }

  void loadMore() {
    final pagination = ref.read(shiftListNotifierProvider).asData?.value;
    if (pagination == null ||
        pagination.to == null ||
        (pagination.to != null && pagination.currentPage >= pagination.to!)) {
      return;
    }

    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !(pagination.loading ?? false)) {
      log('Load shifts... ${pagination.currentPage}/${pagination.to}');
      ref.read(shiftListNotifierProvider.notifier).loadShifts(
            page: pagination.currentPage + 1,
            search: _searchController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final isTablet = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: ref.watch(shiftListNotifierProvider).when(
            data: (data) => RefreshIndicator(
              onRefresh: () => ref
                  .read(shiftListNotifierProvider.notifier)
                  .loadShifts(page: 1),
              child: data.data!.isNotEmpty
                  ? Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 0,
                            margin: const EdgeInsets.all(0),
                            color: Colors.white,
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _scrollController,
                              itemBuilder: (context, idx) {
                                if (idx + 1 > data.data!.length) {
                                  if (data.currentPage >= data.lastPage) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 10),
                                      child: Center(
                                        child: Text(
                                          'x_data_displayed'.tr(
                                            args: [data.total.toString()],
                                          ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Colors.grey.shade600,
                                              ),
                                        ),
                                      ),
                                    );
                                  }
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 10),
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: LoadingIndicator(
                                            color: Colors.teal),
                                      ),
                                    ),
                                  );
                                }
                                Shift shift = data.data![idx];
                                return ListTile(
                                  tileColor: viewShift?.id == shift.id
                                      ? Colors.grey.shade100
                                      : Colors.white,
                                  title: Text(shift.codeShift ?? shift.id),
                                  trailing: Text(
                                    CurrencyFormat.currency(
                                      shift.closeAmount,
                                      symbol: true,
                                    ),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  shape: Border(
                                    bottom: BorderSide(
                                      width: 0.5,
                                      color: Colors.blueGrey.shade50,
                                    ),
                                  ),
                                  titleTextStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                  subtitleTextStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey.shade600),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.play_arrow,
                                            size: 12,
                                            color: Colors.green,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(DateTimeFormater.dateToString(
                                              shift.startShift,
                                              format: 'dd/MM/y HH:mm')),
                                        ],
                                      ),
                                      shift.closeShift != null
                                          ? Row(
                                              children: [
                                                const Icon(
                                                  Icons.stop,
                                                  size: 12,
                                                  color: Colors.red,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(DateTimeFormater
                                                    .dateToString(
                                                        shift.closeShift!,
                                                        format:
                                                            'dd/MM/y HH:mm')),
                                              ],
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      viewShift = shift;
                                    });
                                    if (!isTablet) {
                                      context.pushNamed(Routes.shiftDetail,
                                          pathParameters: {"id": shift.id});
                                    }
                                  },
                                );
                              },
                              itemCount: data.data!.length + 1,
                            ),
                          ),
                        ),
                        isTablet
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width - 325,
                                child: viewShift != null
                                    ? ShiftHistoryDetailScreen(
                                        shiftId: viewShift!.id,
                                        asWidget: true,
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'select_x'.tr(args: ['shift'.tr()]),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                    color: Colors
                                                        .blueGrey.shade300),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                              )
                            : Container()
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'no_data'.tr(args: ['customer'.tr()]),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey),
                          )
                        ],
                      ),
                    ),
            ),
            error: (e, stack) => ErrorHandler(
              error: e.toString(),
              stackTrace: stack.toString(),
            ),
            loading: () => ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => const ItemListSkeleton(
                leading: false,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
            skipError: true,
          ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
