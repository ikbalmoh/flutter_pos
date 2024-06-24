import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/ui/components/app_drawer/app_drawer.dart';
import 'package:selleri/ui/screens/shift/current_shift_screen.dart';
import 'package:selleri/ui/screens/shift/shift_history_screen.dart';

class ShiftScreen extends ConsumerStatefulWidget {
  const ShiftScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShiftScreenState();
}

class _ShiftScreenState extends ConsumerState<ShiftScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('shift'.tr()),
          automaticallyImplyLeading: false,
          leading: Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu));
          }),
          bottom: TabBar(tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.list_bullet_below_rectangle),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('current'.tr())
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.calendar),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('history'.tr())
                ],
              ),
            ),
          ]),
        ),
        drawer: const AppDrawer(),
        body: const TabBarView(
            children: [CurrentShiftScreen(), ShiftHistoryScreen()]),
      ),
    );
  }
}
