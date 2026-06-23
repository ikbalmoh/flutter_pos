import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/app/widget/app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:selleri/shared/utils/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initServices();

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('id', 'ID')],
        path: 'assets/translations',
        fallbackLocale: const Locale('id', 'ID'),
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: const App(),
        ),
      ),
    ),
  );
}
