import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/data/models/shift.dart';
import 'package:selleri/providers/shift/shift_provider.dart';
import 'package:selleri/ui/components/app_drawer/app_drawer.dart';
import 'package:selleri/ui/screens/shift/components/shift_active.dart';
import 'package:selleri/ui/screens/shift/components/shift_inactive.dart';
import 'components/shift_summary_card.dart';

class ShiftScreen extends ConsumerStatefulWidget {
  const ShiftScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShiftScreenState();
}

class _ShiftScreenState extends ConsumerState<ShiftScreen> {
  @override
  Widget build(BuildContext context) {
    final Shift? shift = ref.watch(shiftNotifierProvider).value;

    final color =
        shift == null ? Colors.red.shade100 : Colors.lightGreen.shade100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        iconTheme: const IconThemeData(color: Colors.black87),
        actionsIconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        elevation: 0,
        title: Text('shift'.tr()),
        automaticallyImplyLeading: false,
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu));
        }),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: color,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: shift != null
              ? [const ShiftActive(), const ShiftSummaryCards()]
              : [const ShiftInactive()],
        ),
      ),
    );
  }
}
