import 'package:flutter/material.dart';

class FbTheme {
  FbTheme._();

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      textTheme: fbTextTheme.lightTxttheme,
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: fbelevatedbuttontheme.lightthem,
      inputDecorationTheme: FbTxtfieldTheme.lightinputDecorationTheme,
      cardTheme: const CardTheme(color: Colors.white));
  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      textTheme: fbTextTheme.darkTxttheme,
      scaffoldBackgroundColor: Colors.black,
      elevatedButtonTheme: fbelevatedbuttontheme.Darkthem,
      inputDecorationTheme: FbTxtfieldTheme.darkinputDecorationTheme,
      cardTheme: const CardTheme(color: Colors.black));
}

class fbTextTheme {
  fbTextTheme._();

  static TextTheme lightTxttheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: "bold"),
    headlineMedium: const TextStyle().copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: "bold"),
    headlineSmall: const TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: "bold"),
    titleLarge: const TextStyle().copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontFamily: "bold"),
    titleMedium: const TextStyle().copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: "bold"),
    titleSmall: const TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontFamily: "bold"),
    bodyLarge: const TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.black,
        fontFamily: "bold"),
    bodySmall: const TextStyle().copyWith(
        fontSize: 8,
        //  decoration: TextDecoration.lineThrough,
        fontWeight: FontWeight.normal,
        color: Colors.red.withOpacity(0.3),
        fontFamily: "regular"),
    bodyMedium: const TextStyle().copyWith(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        color: Colors.white,
        fontFamily: "regular"),
    labelMedium: const TextStyle().copyWith(
        fontSize: 8,
        fontWeight: FontWeight.normal,
        color: Colors.black,
        fontFamily: "regular"),
  );

  static TextTheme darkTxttheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: "bold"),
    headlineMedium: const TextStyle().copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: "bold"),
    headlineSmall: const TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: "bold"),
    titleLarge: const TextStyle().copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: "bold"),
    titleMedium: const TextStyle().copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontFamily: "bold"),
    titleSmall: const TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: "bold"),
    bodyLarge: const TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.white,
        fontFamily: "bord"),
    bodySmall: const TextStyle().copyWith(
        fontSize: 8,
        fontWeight: FontWeight.normal,
        //decoration: TextDecoration.lineThrough,
        color: Colors.red.withOpacity(0.3),
        fontFamily: "regular"),
    bodyMedium: const TextStyle().copyWith(
        fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white),
    labelMedium: const TextStyle().copyWith(
        fontSize: 8,
        fontWeight: FontWeight.normal,
        color: Colors.white,
        fontFamily: "regular"),
  );
}

class fbelevatedbuttontheme {
  fbelevatedbuttontheme._();
  static final lightthem = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          disabledBackgroundColor: Colors.grey,
          disabledForegroundColor: Colors.grey,
          side: const BorderSide(color: Colors.blue),
          padding: const EdgeInsets.symmetric(vertical: 10),
          textStyle: const TextStyle().copyWith(
              fontSize: 8, fontWeight: FontWeight.normal, color: Colors.white),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));

  static final Darkthem = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          disabledBackgroundColor: Colors.grey,
          disabledForegroundColor: Colors.grey,
          side: const BorderSide(color: Colors.blue),
          padding: const EdgeInsets.symmetric(vertical: 10),
          textStyle: const TextStyle().copyWith(
              fontSize: 8, fontWeight: FontWeight.normal, color: Colors.white),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
}

class fbAppBartheme {
  fbAppBartheme._();

  static final lighttheme = AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.black, size: 24),
      actionsIconTheme: const IconThemeData(color: Colors.black, size: 24),
      titleTextStyle: const TextStyle().copyWith(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black));

  static final darttheme = AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.black, size: 24),
      actionsIconTheme: const IconThemeData(color: Colors.white, size: 24),
      titleTextStyle: const TextStyle().copyWith(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white));
}

class FbTxtfieldTheme {
  FbTxtfieldTheme._();
  static InputDecorationTheme lightinputDecorationTheme = InputDecorationTheme(
      errorMaxLines: 3,
      prefixIconColor: Colors.white,
      suffixIconColor: Colors.white,
      labelStyle: const TextStyle().copyWith(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black),
      hintStyle: const TextStyle().copyWith(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black),
      errorStyle: const TextStyle().copyWith(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.red),
      border: const OutlineInputBorder().copyWith(
          borderSide: const BorderSide(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(14)),
      enabledBorder: const OutlineInputBorder().copyWith(
          borderSide: const BorderSide(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(14)),
      focusedBorder: const OutlineInputBorder().copyWith(
          borderSide: const BorderSide(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(14)),
      errorBorder: const OutlineInputBorder().copyWith(
          borderSide: const BorderSide(width: 1, color: Colors.red),
          borderRadius: BorderRadius.circular(14)),
      focusedErrorBorder: const OutlineInputBorder().copyWith(
          borderSide: const BorderSide(width: 1, color: Colors.orange),
          borderRadius: BorderRadius.circular(14)));

  static InputDecorationTheme darkinputDecorationTheme = InputDecorationTheme(
      errorMaxLines: 3,
      prefixIconColor: Colors.grey,
      suffixIconColor: Colors.grey,
      labelStyle: const TextStyle().copyWith(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white),
      hintStyle: const TextStyle().copyWith(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white),
      errorStyle: const TextStyle().copyWith(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.red),
      border: const OutlineInputBorder().copyWith(
          borderSide: const BorderSide(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(14)),
      enabledBorder: const OutlineInputBorder().copyWith(
          borderSide: const BorderSide(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(14)),
      focusedBorder: const OutlineInputBorder().copyWith(
          borderSide: const BorderSide(width: 1, color: Colors.white),
          borderRadius: BorderRadius.circular(14)),
      errorBorder: const OutlineInputBorder().copyWith(
          borderSide: const BorderSide(width: 1, color: Colors.red),
          borderRadius: BorderRadius.circular(14)),
      focusedErrorBorder: const OutlineInputBorder().copyWith(
          borderSide: const BorderSide(width: 1, color: Colors.orange),
          borderRadius: BorderRadius.circular(14)));
}
