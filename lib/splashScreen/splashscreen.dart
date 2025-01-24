import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastbuy/admin/cubit/auth_cubit.dart';
import 'package:fastbuy/admin/pages/homePage/homePageAdmin.dart';
import 'package:fastbuy/splashScreen/spash_cubit.dart';
import 'package:fastbuy/user/pages/loginpage.dart';
import 'package:fastbuy/user/userCubit/loginCubit/login_user_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../admin/pages/loginAdmin.dart';
import '../admin/repository/adminAuthRepository.dart';
import '../core/fbtheme.dart';
import '../service/get_serverkey.dart';
import '../user/pages/homepage.dart';
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
  late LoginUserCubit loginUserCubit;
  late SpashCubit _spashCubit;

  bool? islogins = false;

  @override
  void initState() {
    super.initState();
    authCubit = AuthCubit(adminAuthRepo(), AuthInitial());
    loginUserCubit = LoginUserCubit();
    _spashCubit = SpashCubit();
    _spashCubit.screenDirection();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<SpashCubit>(
        create: (context) => SpashCubit(),
        child: BlocListener<SpashCubit, SpashState>(
          bloc: _spashCubit,
          listener: (context, state) {
            if (state is SpashInitial) {
            } else if (state is SpashLoding) {
            } else if (state is SpashSuccess) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HomePageUser(
                      userId: state.userId, sellerId: state.sellerId),
                ),
              );
            } else if (state is SpashAdminSuccess) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Homepageadmin(
                    userId: state.sellerId,
                  ),
                ),
              );
            } else if (state is SpashError) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
              );
            }
          },
          child: BlocBuilder<SpashCubit, SpashState>(
            bloc: _spashCubit,
            builder: (context, state) {
              return Center(
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
