import 'package:fastbuy/admin/pages/loginAdmin.dart';
import 'package:fastbuy/admin/repository/adminAuthRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';

class registerShopPage extends StatefulWidget {
  const registerShopPage({super.key});

  @override
  State<registerShopPage> createState() => _registerShopPageState();
}

class _registerShopPageState extends State<registerShopPage> {
  late AuthCubit authCubit;

  @override
  void initState() {
    authCubit = AuthCubit(adminAuthRepo(), AuthInitial());
    super.initState();
  }

  final TextEditingController textEditingController_name =
      TextEditingController();

  final TextEditingController textEditingController_email =
      TextEditingController();
  final TextEditingController textEditingController_password =
      TextEditingController();
  final TextEditingController textEditingController_address =
      TextEditingController();
  final TextEditingController textEditingController_whatsappno =
      TextEditingController();
  final TextEditingController textEditingController_vehicleNo =
      TextEditingController();
  final TextEditingController textEditingController_shopAddress =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<AuthCubit>(
        create: (context) => authCubit,
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthInitial) {
            } else if (state is AuthRegistrationLoading) {
            } else if (state is AuthRegitrationSucees) {
            } else if (state is AuthRegitrationFail) {
            } else {}
          },
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthInitial) {
                return Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Register Shop"),
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: textEditingController_name,
                                decoration: InputDecoration(
                                    label: Text("Enter your name")),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                controller: textEditingController_email,
                                decoration: InputDecoration(
                                    label: Text("Enter Your email")),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                controller: textEditingController_password,
                                decoration:
                                    InputDecoration(label: Text("Password")),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                controller: textEditingController_address,
                                decoration: const InputDecoration(
                                    label: Text("Enter Address")),
                                maxLines: 1,
                                maxLength: 100,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 4) {
                                    return 'Please enter Address';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                controller: textEditingController_whatsappno,
                                decoration: const InputDecoration(
                                    label: Text("Enter Your Whats app no")),
                                maxLines: 1,
                                maxLength: 100,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 10) {
                                    return 'Please enter whats app no';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                controller: textEditingController_vehicleNo,
                                decoration: const InputDecoration(
                                    label: Text("Enter Your Vehicle no")),
                                maxLines: 1,
                                maxLength: 100,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 4) {
                                    return 'Please enter vehocle no';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                controller: textEditingController_shopAddress,
                                decoration: const InputDecoration(
                                    label: Text("Enter Shop Address")),
                                maxLines: 1,
                                maxLength: 100,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 7) {
                                    return 'Please enter shop Address';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              authCubit.getRegisterYourShop(AuthParams(
                                  textEditingController_email.text,
                                  textEditingController_password.text,
                                  textEditingController_name.text,
                                  true,
                                  textEditingController_address.text,
                                  textEditingController_whatsappno.text,
                                  textEditingController_vehicleNo.text,
                                  textEditingController_shopAddress.text,
                                  ""));
                            }
                          },
                          child: Center(
                            child: Text("Register"),
                          ))
                    ],
                  ),
                );
              } else if (state is AuthRegistrationLoading) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Loading"),
                          SizedBox(
                            width: 10,
                          ),
                          CircularProgressIndicator()
                        ],
                      )
                    ],
                  ),
                );
              } else if (state is AuthRegitrationSucees) {
                return Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 90,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminLogin()));
                        },
                        child: const Text(
                            "Congratulations, Registration Success\n \n click here to login"),
                      )
                    ],
                  ),
                );
              } else if (state is AuthRegitrationFail) {
                return Container();
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
