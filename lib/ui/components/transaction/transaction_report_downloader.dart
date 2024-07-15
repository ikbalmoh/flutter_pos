import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selleri/config/api_url.dart';
import 'package:selleri/providers/outlet/outlet_provider.dart';
import 'package:selleri/utils/app_alert.dart';
import 'package:selleri/utils/formater.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:selleri/utils/file_download.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionReportDownloader extends ConsumerStatefulWidget {
  const TransactionReportDownloader({super.key});

  @override
  ConsumerState<TransactionReportDownloader> createState() =>
      _TransactionReportDownloaderState();
}

class _TransactionReportDownloaderState
    extends ConsumerState<TransactionReportDownloader> {
  bool downloading = false;
  double progress = 0;

  DateTime? from;
  DateTime? to;

  FileDownload downloader = FileDownload();

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    log('${args.value}');
    PickerDateRange range = args.value;
    setState(() {
      from = range.startDate;
      to = range.endDate;
    });
  }

  void onDownload() async {
    if (from == null || to == null) {
      return;
    }
    try {
      setState(() {
        downloading = true;
        progress = 0;
      });
      final fromDate = DateTimeFormater.dateToString(from!, format: 'y-MM-dd');
      final toDate = DateTimeFormater.dateToString(to!, format: 'y-MM-dd');
      String fileName = 'sales-report($fromDate-$toDate).xlsx';
      Map<String, dynamic> params = {
        "from": fromDate,
        "to": toDate,
        "type": "export",
        "id_outlet": ref.read(outletNotifierProvider).value is OutletSelected
            ? (ref.read(outletNotifierProvider).value as OutletSelected)
                .outlet
                .idOutlet
            : ''
      };
      String path = await downloader.download(
        ApiUrl.reportSales,
        openAfterDownload: true,
        fileName: fileName,
        params: params,
        callback: (received) {
          setState(() {
            progress = received;
          });
        },
      );
      setState(() {
        downloading = false;
      });
      AppAlert.toast('stored_at'.tr(args: [path]));
      // ignore: use_build_context_synchronously
      context.pop();
    } catch (e) {
      setState(() {
        downloading = false;
      });
      AppAlert.toast(e.toString(), backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !downloading,
      child: Padding(
        padding: EdgeInsets.only(
          top: 10,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 0.5,
                    color: Colors.blueGrey.shade100,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'download_n'.tr(args: ['sales_report'.tr()]),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  !downloading
                      ? GestureDetector(
                          onTap: () => context.pop(),
                          child: const Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 18,
                          ),
                        )
                      : Container()
                ],
              ),
            ),
            const SizedBox(height: 20),
            SfDateRangePicker(
              backgroundColor: Colors.white,
              headerStyle: const DateRangePickerHeaderStyle(
                  backgroundColor: Colors.white),
              view: DateRangePickerView.month,
              enableMultiView: false,
              selectionMode: DateRangePickerSelectionMode.extendableRange,
              maxDate: DateTime.now(),
              onSelectionChanged: _onSelectionChanged,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: from != null && to != null && !downloading
                  ? onDownload
                  : null,
              label: Text(downloading ? '$progress %' : 'download'.tr()),
              icon: downloading
                  ? const SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 1),
                    )
                  : const Icon(Icons.file_download_outlined),
            )
          ],
        ),
      ),
    );
  }
}
