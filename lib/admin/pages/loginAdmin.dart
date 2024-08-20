import 'package:fastbuy/admin/pages/shopRegistrationPage.dart';
import 'package:fastbuy/admin/repository/adminAuthRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/fbtheme.dart';
import '../../user/homepage.dart';
import '../../user/registerationpage.dart';
import '../cubit/auth_cubit.dart';
import 'homePage/homePageAdmin.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  late AuthCubit authCubit;

  final email = TextEditingController();
  final password = TextEditingController();

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
    authCubit = AuthCubit(adminAuthRepo(), AuthLoginInitial());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<AuthCubit>(
        create: (context) => authCubit,
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLoginInitial) {}
            if (state is AuthLoginLoading) {
            } else if (state is AuthLoginSucees) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Homepageadmin(),
                ),
              );
            } else if (state is AuthLoginFail) {}
          },
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthLoginInitial) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                                                : Icons.visibility_off_rounded,
                                            size: 24,
                                          ),
                                        ),
                                      ))),
                            ],
                          )),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Forgot password",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                authCubit.getLoginYourShop(
                                    email.text, password.text);
                              }
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
                                      const registerShopPage()));
                        },
                        child: Text(
                          "Not Registered Yet? SignUp here",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      )
                    ],
                  ),
                );
              }
              if (state is AuthLoginLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is AuthLoginSucees) {
                return Container();
              } else if (state is AuthLoginFail) {
                return Container(
                  alignment: Alignment.center,
                  child: Text("Login failed,please enter valid credentials"),
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
