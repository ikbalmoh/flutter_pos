import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selleri/providers/adjustment/adjustment_items_provider.dart';
import 'package:selleri/providers/adjustment/adjustment_provider.dart';
import 'package:selleri/router/routes.dart';
import 'package:selleri/ui/components/app_drawer/app_drawer.dart';
import 'package:selleri/ui/components/barcode_scanner/barcode_scanner.dart';
import 'package:selleri/ui/components/search_app_bar.dart';
import 'package:selleri/ui/screens/adjustments/components/adjustment_cart.dart';
import 'package:selleri/ui/screens/adjustments/components/fast_moving_item_banner.dart';
import 'package:selleri/ui/screens/adjustments/components/item_container.dart';
import 'package:selleri/ui/screens/home/components/item_categories.dart';
import 'package:selleri/utils/formater.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';

class AdjustmentScreen extends ConsumerStatefulWidget {
  const AdjustmentScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdjustmentScreenState();
}

class _AdjustmentScreenState extends ConsumerState<AdjustmentScreen> {
  final _scrollController = ScrollController();

  bool searchVisible = false;
  bool itemLayoutGrid = false;
  String idCategory = '';
  String search = '';

  Timer? _debounce;
  bool canListenBarcode = false;
  TextEditingController textSearchController = TextEditingController();
  FocusNode focusSearch = FocusNode();

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    _scrollController.addListener(loadMore);
  }

  @override
  void dispose() {
    _scrollController.removeListener(loadMore);
    super.dispose();
  }

  void loadItems({int? page = 1}) {
    DateTime pickedDate = ref.read(adjustmentProvider).date;
    ref.read(adjustmentItemsProvider.notifier).loadItems(
          page: page ?? 1,
          idCategory: idCategory,
          search: textSearchController.text,
          date: pickedDate,
        );
  }

  void loadMore() {
    final pagination = ref.read(adjustmentItemsProvider).asData?.value;
    if (pagination == null ||
        pagination.to == null ||
        (pagination.to != null && pagination.currentPage >= pagination.to!)) {
      return;
    }

    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !(pagination.loading ?? false)) {
      log('Load adjustment items... ${pagination.currentPage}/${pagination.to}');
      loadItems(page: pagination.currentPage + 1);
    }
  }

  void onSearchItems(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        search = value;
      });
      loadItems(page: 1);
      if (_scrollController.hasClients) {
        _scrollController.animateTo(0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      }
    });
  }

  void onBarcodeScanned(barcode) {
    if (!canListenBarcode) return;
    log('barcode scanned: $barcode');
    textSearchController.text = barcode;
    onSearchItems(barcode);
  }

  void onChangeCategory(String id) {
    setState(() {
      idCategory = id;
    });
    loadItems(page: 1);
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  void pickAdjustmentDate() async {
    DateTime date = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: date.subtract(const Duration(days: 180)),
      lastDate: DateTime.now(),
      initialDate: date,
    );
    if (pickedDate != null) {
      ref.read(adjustmentProvider.notifier).setDate(pickedDate);
      loadItems(page: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    var itemContainer = VisibilityDetector(
      onVisibilityChanged: (info) {
        if (context.mounted) {
          setState(() {
            canListenBarcode = info.visibleFraction > 0;
          });
        }
      },
      key: const Key('adjustment-visible-detector-key'),
      child: BarcodeKeyboardListener(
        bufferDuration: const Duration(milliseconds: 200),
        onBarcodeScanned: onBarcodeScanned,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isTablet
                ? Container()
                : Material(
                    color: Colors.teal.shade50,
                    child: InkWell(
                      onTap: pickAdjustmentDate,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.calendar,
                                color: Colors.teal.shade600),
                            const SizedBox(width: 10),
                            Text(
                              DateTimeFormater.dateToString(
                                  ref.watch(adjustmentProvider).date,
                                  format: 'd MMM y'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.teal.shade600,
                                  ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
            const FastMovingItemBanner(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              height: searchVisible ? 0 : 56,
              child: ItemCategories(
                active: idCategory,
                onChange: onChangeCategory,
              ),
            ),
            Expanded(
              child: ItemContainer(
                scrollController: _scrollController,
                idCategory: idCategory,
                search: search,
                clearSearch: () {
                  setState(() {
                    search = '';
                    textSearchController.text = '';
                  });
                  focusSearch.requestFocus();
                },
                itemLayoutGrid: itemLayoutGrid,
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: searchVisible
          ? SearchAppBar(
              onBack: () {
                setState(
                  () {
                    searchVisible = false;
                    textSearchController.text = '';
                    search = '';
                  },
                );
                onSearchItems('');
              },
              onChanged: onSearchItems,
              controller: textSearchController,
              actions: [
                IconButton(
                  onPressed: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return BarcodeScanner(
                            onCaptured: (barcode, cb) {
                              context.pop();
                              textSearchController.text = barcode;
                              onSearchItems(barcode);
                            },
                          );
                        });
                  },
                  icon: const Icon(CupertinoIcons.barcode_viewfinder),
                ),
              ],
            )
          : AppBar(
              title: Text('stock_adjustments'.tr()),
              automaticallyImplyLeading: false,
              elevation: 1,
              leading: Builder(builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.menu),
                );
              }),
              actions: [
                IconButton(
                  tooltip: 'search'.tr(),
                  onPressed: () {
                    setState(() {
                      searchVisible = true;
                    });
                    focusSearch.requestFocus();
                  },
                  icon: const Icon(CupertinoIcons.search),
                ),
                isTablet
                    ? TextButton.icon(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.teal.shade50),
                        onPressed: pickAdjustmentDate,
                        label: Text(DateTimeFormater.dateToString(
                            ref.watch(adjustmentProvider).date,
                            format: 'd MMM y')),
                        icon: const Icon(CupertinoIcons.calendar),
                      )
                    : Container(),
                MenuAnchor(
                  style: MenuStyle(backgroundColor:
                      WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                    return Colors.white;
                  })),
                  builder: (BuildContext context, MenuController controller,
                      Widget? child) {
                    return IconButton(
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      icon: const Icon(Icons.more_vert),
                      tooltip: 'show_menu'.tr(),
                    );
                  },
                  menuChildren: [
                    MenuItemButton(
                      leadingIcon: const Icon(CupertinoIcons.square_list),
                      onPressed: () => context.push(Routes.adjustmentsHistory),
                      child: Text('adjustment_history'.tr()),
                    ),
                    const PopupMenuDivider(),
                    MenuItemButton(
                      leadingIcon: Icon(itemLayoutGrid
                          ? CupertinoIcons.rectangle_grid_1x2
                          : CupertinoIcons.square_grid_2x2_fill),
                      onPressed: () => setState(() {
                        itemLayoutGrid = !itemLayoutGrid;
                      }),
                      child: Text(
                          itemLayoutGrid ? 'list_view'.tr() : 'grid_view'.tr()),
                    )
                  ],
                )
              ],
            ),
      body: Row(
        children: [
          Expanded(child: itemContainer),
          isTablet
              ? Container(
                  width: ResponsiveBreakpoints.of(context).largerThan(TABLET)
                      ? 400
                      : MediaQuery.of(context).size.width * 0.5,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border(
                      left: BorderSide(
                        width: 1,
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: const AdjustmentCart(
                        asWidget: true,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
      floatingActionButton: !isTablet &&
              ref.watch(adjustmentProvider).items.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => showCupertinoModalPopup(
                  context: context,
                  builder: (context) => const AdjustmentCart()),
              label: Text('cart'.tr()),
              icon: Badge(
                label:
                    Text(ref.watch(adjustmentProvider).items.length.toString()),
                child: const Icon(CupertinoIcons.cart_fill),
              ))
          : null,
    );
  }
}
