import 'package:fastbuy/core/fbtheme.dart';
import 'package:fastbuy/screens/homepage.dart';
import 'package:fastbuy/screens/kartpage.dart';
import 'package:fastbuy/screens/loginpage.dart';
import 'package:fastbuy/screens/productview.dart';
import 'package:fastbuy/screens/splashscreen.dart';
import 'package:fastbuy/screens/tabs/tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: fbtheme.Darktheme,
      theme: fbtheme.lighttheme,
      themeMode: ThemeMode.system,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
