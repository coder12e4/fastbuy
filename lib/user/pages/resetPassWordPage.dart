import 'package:fastbuy/user/pages/loginpage.dart';
import 'package:fastbuy/user/userCubit/loginCubit/login_user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class resetPassWord extends StatefulWidget {
  const resetPassWord({super.key});

  @override
  State<resetPassWord> createState() => _resetPassWordState();
}

class _resetPassWordState extends State<resetPassWord> {
  final emailtxtController = TextEditingController();
  final passwordtxtController = TextEditingController();

  late LoginUserCubit loginUserCubit;

  @override
  void initState() {
    loginUserCubit = LoginUserCubit();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginUserCubit>(
        create: (context) => LoginUserCubit(),
        child: BlocListener<LoginUserCubit, LoginUserState>(
          bloc: loginUserCubit,
          listener: (context, state) {
            if (state is LoginUserInitial) {
            } else if (state is LoginUserLoading) {
            } else if (state is LoginUserSuccess) {
            } else if (state is LoginUserFail) {}
          },
          child: BlocBuilder<LoginUserCubit, LoginUserState>(
            bloc: loginUserCubit,
            builder: (context, state) {
              if (state is LoginUserInitial) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Change password",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextField(
                        controller: emailtxtController,
                        decoration:
                            const InputDecoration(label: Text("E mail")),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              loginUserCubit
                                  .resetPassword(emailtxtController.text);
                            });
                          },
                          child: const Center(
                            child: Text("Change Password"),
                          ))
                    ],
                  ),
                );
              } else if (state is LoginUserLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is LoginUserSuccess) {
                return Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                    },
                    child: Text(
                      "Reset link sent To your main,click here to login",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                );
              } else if (state is LoginUserFail) {
                return Center(
                  child: Text(
                    "change password failed",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
