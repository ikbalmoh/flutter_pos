import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/receiving/receiving_detail.dart';
import 'package:selleri/ui/screens/receiving/components/receiving_status_badge.dart';
import 'package:selleri/utils/formater.dart';

class ReceivingPreview extends ConsumerWidget {
  const ReceivingPreview({super.key, required this.receiving, this.asWidget});

  final ReceivingDetail receiving;
  final bool? asWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(receiving.receiveNumber),
        iconTheme: const IconThemeData(color: Colors.black87),
        automaticallyImplyLeading: asWidget != true,
        titleTextStyle: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12.5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  receiving.type == 1 ? CupertinoIcons.cart_badge_plus : CupertinoIcons.arrow_right_arrow_left_circle,
                                  size: 16,
                                ),
                                const SizedBox(width: 10),
                                Text(receiving.typeName ?? '-'),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.calendar,
                                  size: 16,
                                ),
                                const SizedBox(width: 10),
                                Text(DateTimeFormater.dateToString(
                                    receiving.receiveDate,
                                    format: 'd MMM y')),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.person_crop_circle,
                                  size: 16,
                                ),
                                const SizedBox(width: 10),
                                Text(receiving.createdName ?? '-'),
                              ],
                            ),
                            const SizedBox(height: 3),
                            receiving.descriptions != null &&
                                    receiving.descriptions != ''
                                ? Row(
                                    children: [
                                      const Icon(
                                        CupertinoIcons.text_quote,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        receiving.descriptions!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.black54),
                                      )
                                    ],
                                  )
                                : Container()
                          ],
                        ),
                        ReceivingStatusBadge(status: receiving.status),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      color: Colors.blueGrey.shade50,
                    ),
                    const SizedBox(height: 10),
                    receiving.items.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final item = receiving.items[index];
                              return Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                  width: 1,
                                  color: Colors.grey.shade100,
                                ))),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.itemName,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                              Text(
                                                item.skuNumber ?? '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: Colors
                                                          .blueGrey.shade600,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 7.5, vertical: 5),
                                          child: Text(
                                            CurrencyFormat.currency(
                                              item.qtyReceive,
                                              symbol: false,
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "${'request'.tr()}: ${CurrencyFormat.currency(item.qtyRequest, symbol: false)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: Colors.black54,
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: receiving.items.length,
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 80,
                              horizontal: 20,
                            ),
                            child: Center(
                              child: Text(
                                'no_items'.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.black54,
                                    ),
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
