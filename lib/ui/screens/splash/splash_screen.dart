import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/providers/app_start/app_start_provider.dart';
import 'package:selleri/ui/screens/home/home_screen.dart';
import 'package:selleri/ui/screens/login/login_screen.dart';
import 'package:selleri/ui/screens/select_outlet/select_outlet_screen.dart';
import 'package:selleri/ui/widgets/loading_widget.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStartNotifierProvider);

    print("APP STATE: $state");
    return state.when(
      data: (data) {
        return data.maybeWhen(
          initializing: () => const LoadingWidget(withScaffold: true),
          authenticated: () => const SelectOutletScreen(),
          outletSelected: () => const HomeScreen(),
          unauthenticated: () => const LoginScreen(),
          orElse: () => const LoadingWidget(withScaffold: true),
        );
      },
      error: (e, st) => const LoadingWidget(withScaffold: true),
      loading: () => const LoadingWidget(withScaffold: true),
    );
  }
}
