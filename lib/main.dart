import 'package:fastbuy/admin/cubit/addProducts/subcategorycubit.dart';
import 'package:fastbuy/admin/cubit/auth_cubit.dart';
import 'package:fastbuy/admin/repository/adminAuthRepository.dart';
import 'package:fastbuy/core/fbtheme.dart';
import 'package:fastbuy/user/homepage.dart';
import 'package:fastbuy/user/kartpage.dart';
import 'package:fastbuy/user/loginpage.dart';
import 'package:fastbuy/user/productview.dart';
import 'package:fastbuy/user/registerationpage.dart';
import 'package:fastbuy/user/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'admin/add_products.dart';
import 'admin/addproducts.dart';
import 'admin/cubit/addProducts/productCubit.dart';
import 'admin/pageAdminRegistration.dart';
import 'admin/pages/homePage/homePageAdmin.dart';
import 'admin/pages/loginAdmin.dart';
import 'admin/pages/shopRegistrationPage.dart';
import 'admin/product_listpage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'localisation/app_localizations.dart';
import 'localisation/cubit/locale_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBi-lX5Qe0a7dquyxqzIJcvz7vBCCNiYBs",
        appId: "1:868906482031:android:a5fc441b5ecc8a3d46509a",
        messagingSenderId: "868906482031",
        projectId: "fastbuy-55678",
        storageBucket: "com.zeocodes.fastbuy"),
  );

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocaleCubit()..getSavedLanguage(),
        ),
        BlocProvider(
          create: (context) => SubcategoryCubit(),
        ),
        BlocProvider(
          create: (context) => ProductCubit(),
        ),
        BlocProvider(
            create: (context) => AuthCubit(adminAuthRepo(), AuthInitial()))
      ],
      child: BlocBuilder<LocaleCubit, ChangeLocaleState>(
        builder: (context, state) {
          return MaterialApp(
            locale: state.locale,
            title: 'FastBuy',
            darkTheme: FbTheme.darkTheme,
            theme: FbTheme.lightTheme,
            themeMode: ThemeMode.system,
            supportedLocales: const [Locale('en'), Locale('es')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            localeResolutionCallback: (deviceLocale, supportedLocales) {
              for (var locale in supportedLocales) {
                if (deviceLocale != null &&
                    deviceLocale.languageCode == locale.languageCode) {
                  return deviceLocale;
                }
              }
              return supportedLocales.first;
            },
            debugShowCheckedModeBanner: false,
            home: const Registration(),
          );
        },
      ),
    );
  }
}
