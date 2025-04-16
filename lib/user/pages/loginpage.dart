import 'package:fastbuy/core/constants.dart';
import 'package:fastbuy/core/fbtheme.dart';
import 'package:fastbuy/user/pages/homepage.dart';
import 'package:fastbuy/user/pages/registerationpage.dart';
import 'package:fastbuy/user/pages/resetPassWordPage.dart';
import 'package:fastbuy/user/userCubit/loginCubit/login_user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../admin/pages/loginAdmin.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  final email = TextEditingController();
  final password = TextEditingController();
  late LoginUserCubit loginUserCubit;

  final textFieldFocusNode = FocusNode();
  bool _obscured = false;
  final _formKey = GlobalKey<FormState>();

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return; // If focus is on text field, dont unfocus
      }
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    loginUserCubit = LoginUserCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider<LoginUserCubit>(
          create: (context) => loginUserCubit,
          child: BlocListener<LoginUserCubit, LoginUserState>(
            listener: (context, state) {
              if (state is LoginUserInitial) {
              } else if (state is LoginUserLoading) {
              } else if (state is LoginUserSuccess) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomePageUser(
                      userId: state.userId,
                      sellerId: state.sellerId,
                    ),
                  ),
                );
              } else if (state is LoginUserFail) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text("Somethig is wrong try again " + state.error)));
              } else {}
            },
            child: BlocBuilder<LoginUserCubit, LoginUserState>(
              builder: (context, state) {
                if (state is LoginUserInitial) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: SizedBox()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_shopping_cart_sharp,
                              size: 28,
                              color: FbColors.primaryColor,
                            ),
                            Text(
                              "Fastbuy",
                              style: fbTextTheme.lightTxttheme.headlineLarge,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: email,
                                  maxLines: 1,
                                  maxLength: 100,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                        .hasMatch(value)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      labelText: "Enter your email",
                                      prefixIcon: Icon(Icons.person)),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                    obscureText: _obscured,
                                    controller: password,
                                    maxLines: 1,
                                    maxLength: 100,
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value.length < 7) {
                                        return 'Please enter password with 8 letters';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: "Enter your password",
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                        ),
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 4, 0),
                                          child: GestureDetector(
                                            onTap: _toggleObscured,
                                            child: Icon(
                                              _obscured
                                                  ? Icons.visibility_rounded
                                                  : Icons
                                                      .visibility_off_rounded,
                                              size: 24,
                                            ),
                                          ),
                                        ))),
                              ],
                            )),
                        const SizedBox(
                          height: 18,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => resetPassWord()));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Forgot password",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                loginUserCubit.userLogin(
                                    email.text, password.text);
                              },
                              child: Text(
                                "Login",
                                style: Theme.of(context).textTheme.bodyMedium,
                              )),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Registration()));
                          },
                          child: Text(
                            "Not Registered Yet? SignUp here",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(child: SizedBox()),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminLogin()));
                          },
                          child: Text(
                            "Login as a seller",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                } else if (state is LoginUserLoading) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: SizedBox()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_shopping_cart_sharp,
                              size: 28,
                              color: FbColors.primaryColor,
                            ),
                            Text(
                              "Fastbuy",
                              style: fbTextTheme.lightTxttheme.headlineLarge,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: email,
                                  maxLines: 1,
                                  maxLength: 100,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                        .hasMatch(value)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      labelText: "Enter your email",
                                      prefixIcon: Icon(Icons.person)),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                    obscureText: _obscured,
                                    controller: password,
                                    maxLines: 1,
                                    maxLength: 100,
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value.length < 7) {
                                        return 'Please enter password with 8 letters';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: "Enter your password",
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                        ),
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 4, 0),
                                          child: GestureDetector(
                                            onTap: _toggleObscured,
                                            child: Icon(
                                              _obscured
                                                  ? Icons.visibility_rounded
                                                  : Icons
                                                      .visibility_off_rounded,
                                              size: 24,
                                            ),
                                          ),
                                        ))),
                              ],
                            )),
                        const SizedBox(
                          height: 18,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => resetPassWord()));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Forgot password",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                /*     if (_formKey.currentState!.validate()) {
                                  FirebaseMessaging.instance
                                      .getToken()
                                      .then((fcmtoken) {
                                    loginUserCubit.userLogin(
                                        email.text, password.text, fcmtoken!);
                                  });
                                }*/
                              },
                              child: SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Registration()));
                          },
                          child: Text(
                            "Not Registered Yet? SignUp here",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(child: SizedBox()),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminLogin()));
                          },
                          child: Text(
                            "Login as a seller",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                } else if (state is LoginUserSuccess) {
                  return Container();
                } else if (state is LoginUserFail) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: SizedBox()),
                        Row(
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
                              style: fbTextTheme.lightTxttheme.headlineLarge,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: email,
                                  maxLines: 1,
                                  maxLength: 100,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                        .hasMatch(value)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      labelText: "Enter your email",
                                      prefixIcon: Icon(Icons.person)),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                    obscureText: _obscured,
                                    controller: password,
                                    maxLines: 1,
                                    maxLength: 100,
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value.length < 7) {
                                        return 'Please enter password with 8 letters';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: "Enter your password",
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                        ),
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 4, 0),
                                          child: GestureDetector(
                                            onTap: _toggleObscured,
                                            child: Icon(
                                              _obscured
                                                  ? Icons.visibility_rounded
                                                  : Icons
                                                      .visibility_off_rounded,
                                              size: 24,
                                            ),
                                          ),
                                        ))),
                              ],
                            )),
                        const SizedBox(
                          height: 18,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => resetPassWord()));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Forgot password",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                loginUserCubit.userLogin(
                                    email.text, password.text);
                              },
                              child: Text(
                                "Login",
                                style: Theme.of(context).textTheme.bodyMedium,
                              )),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Registration()));
                          },
                          child: Text(
                            "Not Registered Yet? SignUp here",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(child: SizedBox()),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminLogin()));
                          },
                          child: Text(
                            "Login as a seller",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Text(
                    "something went wrong",
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
