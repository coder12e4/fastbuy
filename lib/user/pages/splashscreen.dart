import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastbuy/admin/cubit/auth_cubit.dart';
import 'package:fastbuy/admin/pages/homePage/homePageAdmin.dart';
import 'package:fastbuy/user/pages/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../admin/pages/loginAdmin.dart';
import '../../admin/repository/adminAuthRepository.dart';
import '../../core/fbtheme.dart';
import '../../service/get_serverkey.dart';
import 'homepage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  late AuthCubit authCubit;
  bool? islogins;

  getServerkey() async {
    print("serverkey loading");
    Serverkey serverkey = Serverkey();
    final key = await serverkey.getServerToken();
    print(key);
    print("serverkey complet");
  }

  @override
  void initState() {
    super.initState();
    // getServerkey();
    authCubit = AuthCubit(adminAuthRepo(), AuthInitial());

    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    animationController.forward();

    animationController.addStatusListener((status) {
      print("fire base token");

      if (status == AnimationStatus.completed) {
        screenDirrection();
      }
    });
  }

  void screenDirrection() async {
    try {
      islogins = await authCubit.getBool('islogin');
      if (islogins!) {
        //check which user
        bool? userType = await authCubit.getBool('userType');
        String? userId = await authCubit.getUserId();
        String? sellerId = await authCubit.getSellerId();

        // true for user
        if (userType!) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HomePageUser(
                userId: userId!,
                sellerId: sellerId!,
              ),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Homepageadmin(
                userId: userId!,
              ),
            ),
          );
        }
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: animation,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_shopping_cart_sharp,
                size: 28,
                color: Colors.blue,
              ),
              Text(
                "fastbuy",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ],
          ), // Replace with your app logo
        ),
      ),
    );
  }
}
