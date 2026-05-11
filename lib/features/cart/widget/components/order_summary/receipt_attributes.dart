import 'package:flutter/material.dart';
import 'package:selleri/features/outlet/model/outlet.dart' as model;
import 'package:selleri/features/outlet/model/outlet_config.dart';
import 'package:selleri/shared/utils/formater.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ReceiptHeader extends StatelessWidget {
  const ReceiptHeader(
      {required this.outlet,
      super.key,
      this.asReceipt,
      this.attributeReceipts});

  final model.Outlet outlet;
  final bool? asReceipt;
  final AttributeReceipts? attributeReceipts;

  @override
  Widget build(BuildContext context) {
    var outletName = Text(
      outlet.outletName,
      style: asReceipt == true
          ? TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700)
          : Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
    );

    return attributeReceipts != null
        ? Column(
            children: [
              attributeReceipts?.imagePath != null
                  ? CachedNetworkImage(
                      imageUrl: attributeReceipts!.imagePath!,
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
              attributeReceipts!.headers != null
                  ? Text(
                      GeneralFormater.stripHtmlIfNeeded(
                          attributeReceipts!.headers ?? ''),
                      style: asReceipt == true
                          ? TextStyle(fontSize: 20, color: Colors.black)
                          : null,
                    )
                  : Container()
            ],
          )
        : outletName;
  }
}

class ReceiptFooter extends StatelessWidget {
  final AttributeReceipts attributeReceipts;
  const ReceiptFooter({required this.attributeReceipts, super.key});

  @override
  Widget build(BuildContext context) {
    return attributeReceipts.footers != null
        ? Center(
            child: Text(
              GeneralFormater.stripHtmlIfNeeded(
                  attributeReceipts.footers ?? ''),
              textAlign: TextAlign.center,
            ),
          )
        : Container();
  }
}
