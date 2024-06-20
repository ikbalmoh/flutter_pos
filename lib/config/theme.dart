import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.teal,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal,
      primary: Colors.teal,
      surface: Colors.white,
      error: Colors.red,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      elevation: 0,
      surfaceTintColor: Colors.white,
      scrolledUnderElevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: Colors.teal.shade400,
      titleTextStyle: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
      actionsIconTheme: const IconThemeData(
        color: Colors.white,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.teal.shade400,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      centerTitle: false
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      bodyMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      bodySmall: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
      labelLarge: TextStyle(fontWeight: FontWeight.w600),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(999)),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(999)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.resolveWith<Size>(
            (states) => const Size.fromHeight(50)),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => Colors.white,
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.teal.shade400.withOpacity(0.7);
            } else if (states.contains(WidgetState.disabled)) {
              return Colors.grey.shade400;
            }
            return Colors.teal.shade400;
          },
        ),
        shape: WidgetStateProperty.resolveWith<RoundedRectangleBorder>(
          (state) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        textStyle: WidgetStateProperty.resolveWith<TextStyle>(
          (states) => const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.resolveWith<Size>(
            (states) => const Size.fromHeight(50)),
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => Colors.teal,
        ),
        side: WidgetStateProperty.resolveWith<BorderSide>(
          (states) => const BorderSide(color: Colors.teal),
        ),
        shape: WidgetStateProperty.resolveWith<RoundedRectangleBorder>(
          (state) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        textStyle: WidgetStateProperty.resolveWith<TextStyle>(
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
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: SlidePageTransition(),
        TargetPlatform.iOS: SlidePageTransition(),
      },
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      surfaceTintColor: Colors.white,
    ),
    cardTheme: const CardTheme(
      surfaceTintColor: Colors.white,
    ),
    popupMenuTheme: const PopupMenuThemeData(
      surfaceTintColor: Colors.white,
    ),
    dialogBackgroundColor: Colors.white,
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.white,
    ),
  );
}

class SlidePageTransition extends PageTransitionsBuilder {
  const SlidePageTransition();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}
