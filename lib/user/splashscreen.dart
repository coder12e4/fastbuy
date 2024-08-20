import 'package:fastbuy/user/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../admin/pages/loginAdmin.dart';
import '../core/fbtheme.dart';
import 'homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    animationController.forward();

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (true) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => AdminLogin(),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Login(),
            ),
          );
        }
      }
    });
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
