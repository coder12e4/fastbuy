import 'dart:ui';
import 'package:fastbuy/admin/pages/products/productPage.dart';
import 'package:fastbuy/splashScreen/splashscreen.dart';
import 'package:fastbuy/user/userCubit/loginCubit/login_user_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'admin/cubit/addProducts/productCubit/product_cubit.dart';
import 'admin/cubit/addProducts/subCategoryCubit/subcategory_cubit.dart';
import 'admin/cubit/auth_cubit.dart';
import 'admin/pages/homePage/homePageAdmin.dart';
import 'admin/repository/adminAuthRepository.dart';
import 'core/fbtheme.dart';
import 'localisation/app_localizations.dart';
import 'localisation/cubit/locale_cubit.dart';
import 'notification/notification.dart';
import 'splashScreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));

  try {
    await Firebase.initializeApp(
      name: "fastbuy",
      options: const FirebaseOptions(
        apiKey: "AIzaSyBi-lX5Qe0a7dquyxqzIJcvz7vBCCNiYBs",
        appId: "1:868906482031:android:a5fc441b5ecc8a3d46509a",
        messagingSenderId: "868906482031",
        projectId: "fastbuy-55678",
        storageBucket: "com.zeocodes.fastbuy",
      ),
    );
    await FirebaseApi().initNotifications();
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  runApp(
    const MyApp(),
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
            create: (context) => AuthCubit(adminAuthRepo(), AuthInitial())),
        BlocProvider(create: (context) => LoginUserCubit())
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
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
