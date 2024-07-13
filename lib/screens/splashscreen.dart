import 'package:fastbuy/screens/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/fbtheme.dart';
import '../providers/user_persistance/auth_provider.dart';
import 'homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
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
        final authState = ref.read(authProvider);

        if (authState.isLoggedIn) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => login(),
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
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_shopping_cart_sharp,
                  size: 28,
                  color: Colors.blue,
                ),
                Text(
                  "fastbuy",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          ), // Replace with your app logo
        ),
      ),
    );
  }
}
