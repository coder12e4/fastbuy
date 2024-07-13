import 'package:flutter/material.dart';

class fbtheme {
  fbtheme._();

  static ThemeData lighttheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      textTheme: fbTextTheme.lightTxttheme,
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: fbelevatedbuttontheme.lightthem,
      inputDecorationTheme: fbtxtfieldtheme.lightinputDecorationTheme,
      cardTheme: CardTheme(color: Colors.white));
  static ThemeData Darktheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      textTheme: fbTextTheme.darkTxttheme,
      scaffoldBackgroundColor: Colors.black,
      elevatedButtonTheme: fbelevatedbuttontheme.Darkthem,
      inputDecorationTheme: fbtxtfieldtheme.darkinputDecorationTheme,
      cardTheme: CardTheme(color: Colors.black));
}

class fbTextTheme {
  fbTextTheme._();

  static TextTheme lightTxttheme = TextTheme(
    headlineLarge: TextStyle().copyWith(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: "bold"),
    headlineMedium: TextStyle().copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: "bold"),
    headlineSmall: TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: "bold"),
    titleLarge: TextStyle().copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontFamily: "bold"),
    titleMedium: TextStyle().copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: "bold"),
    titleSmall: TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontFamily: "bold"),
    bodyLarge: TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.black,
        fontFamily: "bold"),
    bodySmall: TextStyle().copyWith(
        fontSize: 8,
        //  decoration: TextDecoration.lineThrough,
        fontWeight: FontWeight.normal,
        color: Colors.red.withOpacity(0.3),
        fontFamily: "regular"),
    bodyMedium: TextStyle().copyWith(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        color: Colors.white,
        fontFamily: "regular"),
    labelMedium: TextStyle().copyWith(
        fontSize: 8,
        fontWeight: FontWeight.normal,
        color: Colors.black,
        fontFamily: "regular"),
  );

  static TextTheme darkTxttheme = TextTheme(
    headlineLarge: TextStyle().copyWith(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: "bold"),
    headlineMedium: TextStyle().copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: "bold"),
    headlineSmall: TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: "bold"),
    titleLarge: TextStyle().copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: "bold"),
    titleMedium: TextStyle().copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontFamily: "bold"),
    titleSmall: TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: "bold"),
    bodyLarge: TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.white,
        fontFamily: "bord"),
    bodySmall: TextStyle().copyWith(
        fontSize: 8,
        fontWeight: FontWeight.normal,
        //decoration: TextDecoration.lineThrough,
        color: Colors.red.withOpacity(0.3),
        fontFamily: "regular"),
    bodyMedium: TextStyle().copyWith(
        fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white),
    labelMedium: TextStyle().copyWith(
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
          side: BorderSide(color: Colors.blue),
          padding: EdgeInsets.symmetric(vertical: 10),
          textStyle: TextStyle().copyWith(
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
          side: BorderSide(color: Colors.blue),
          padding: EdgeInsets.symmetric(vertical: 10),
          textStyle: TextStyle().copyWith(
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
      iconTheme: IconThemeData(color: Colors.black, size: 24),
      actionsIconTheme: IconThemeData(color: Colors.black, size: 24),
      titleTextStyle: TextStyle().copyWith(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black));

  static final darttheme = AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black, size: 24),
      actionsIconTheme: IconThemeData(color: Colors.white, size: 24),
      titleTextStyle: TextStyle().copyWith(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white));
}

class fbtxtfieldtheme {
  fbtxtfieldtheme._();
  static InputDecorationTheme lightinputDecorationTheme = InputDecorationTheme(
      errorMaxLines: 3,
      prefixIconColor: Colors.white,
      suffixIconColor: Colors.white,
      labelStyle: TextStyle().copyWith(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black),
      hintStyle: TextStyle().copyWith(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black),
      errorStyle: TextStyle().copyWith(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.red),
      border: const OutlineInputBorder().copyWith(
          borderSide: BorderSide(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(14)),
      enabledBorder: const OutlineInputBorder().copyWith(
          borderSide: BorderSide(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(14)),
      focusedBorder: const OutlineInputBorder().copyWith(
          borderSide: BorderSide(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(14)),
      errorBorder: const OutlineInputBorder().copyWith(
          borderSide: BorderSide(width: 1, color: Colors.red),
          borderRadius: BorderRadius.circular(14)),
      focusedErrorBorder: const OutlineInputBorder().copyWith(
          borderSide: BorderSide(width: 1, color: Colors.orange),
          borderRadius: BorderRadius.circular(14)));

  static InputDecorationTheme darkinputDecorationTheme = InputDecorationTheme(
      errorMaxLines: 3,
      prefixIconColor: Colors.grey,
      suffixIconColor: Colors.grey,
      labelStyle: TextStyle().copyWith(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white),
      hintStyle: TextStyle().copyWith(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white),
      errorStyle: TextStyle().copyWith(
          fontSize: 12, fontWeight: FontWeight.normal, color: Colors.red),
      border: const OutlineInputBorder().copyWith(
          borderSide: BorderSide(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(14)),
      enabledBorder: const OutlineInputBorder().copyWith(
          borderSide: BorderSide(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(14)),
      focusedBorder: const OutlineInputBorder().copyWith(
          borderSide: BorderSide(width: 1, color: Colors.white),
          borderRadius: BorderRadius.circular(14)),
      errorBorder: const OutlineInputBorder().copyWith(
          borderSide: BorderSide(width: 1, color: Colors.red),
          borderRadius: BorderRadius.circular(14)),
      focusedErrorBorder: const OutlineInputBorder().copyWith(
          borderSide: BorderSide(width: 1, color: Colors.orange),
          borderRadius: BorderRadius.circular(14)));
}
