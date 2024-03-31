import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.teal,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal,
      primary: Colors.teal,
      background: Colors.white,
      error: Colors.red,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      scrolledUnderElevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: Colors.teal.shade400,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 20
      ),
      actionsIconTheme: const IconThemeData(
        color: Colors.white,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.teal.shade400,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontWeight: FontWeight.w200, fontSize: 14),
      labelLarge: TextStyle(fontWeight: FontWeight.w600),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(999))
      )
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.resolveWith<Size>(
            (states) => const Size.fromHeight(50)),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) => Colors.white,
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.teal.shade400.withOpacity(0.7);
            } else if (states.contains(MaterialState.disabled)) {
              return Colors.grey.shade400;
            }
            return Colors.teal.shade400;
          },
        ),
        shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
          (state) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (states) => const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        borderSide: BorderSide(
          width: 1,
          color: Colors.grey.shade400,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        borderSide: BorderSide(
          width: 1,
          color: Colors.teal.shade400,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        borderSide: BorderSide(
          width: 1,
          color: Colors.red.shade400,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        borderSide: BorderSide(
          width: 1,
          color: Colors.teal.shade400,
        ),
      ),
      labelStyle: TextStyle(
        color: Colors.grey.shade500,
        fontWeight: FontWeight.normal,
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
    ),
  );
}
