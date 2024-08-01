import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:selleri/data/models/outlet_config.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/utils/formater.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ReceiptHeader extends ConsumerWidget {
  const ReceiptHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outletState = ref.watch(outletNotifierProvider).value;
    if (outletState is OutletSelected) {
      final outlet = outletState.outlet;
      final AttributeReceipts? attributeReceipts =
          outletState.config.attributeReceipts;

      var outletName = Text(
        outlet.outletName,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w700),
      );

      return attributeReceipts != null
          ? Column(
              children: [
                attributeReceipts.imagePath != null
                    ? CachedNetworkImage(
                        imageUrl: attributeReceipts.imagePath!,
                        height: 60,
                        fit: BoxFit.contain,
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/icon.png',
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                      )
                    : Container(),
                const SizedBox(height: 5),
                outletName,
                attributeReceipts.headers != null
                    ? Text(GeneralFormater.stripHtmlIfNeeded(
                        attributeReceipts.headers ?? ''))
                    : Container()
              ],
            )
          : outletName;
    }
    return Container();
  }
}

class ReceiptFooter extends ConsumerWidget {
  const ReceiptFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outletState = ref.watch(outletNotifierProvider).value;
    if (outletState is OutletSelected) {
      final AttributeReceipts? attributeReceipts =
          outletState.config.attributeReceipts;
      return attributeReceipts?.footers != null
          ? Text(
              GeneralFormater.stripHtmlIfNeeded(
                  attributeReceipts!.footers ?? ''),
              textAlign: TextAlign.center,
            )
          : Container();
    }
    return Container();
  }
}
