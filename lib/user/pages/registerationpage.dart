import 'package:fastbuy/user/Models/UserModel.dart';
import 'package:fastbuy/user/userCubit/loginCubit/login_user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../admin/adminModels/regmodel.dart';
import 'loginpage.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  RegistrationState createState() => RegistrationState();
}

class RegistrationState extends State {
  late LoginUserCubit auth_cubit;
  final usernameTxtController = TextEditingController();
  final passwordTxtController = TextEditingController();
  final confirmpasswordTxtController = TextEditingController();
  final homeNameTxtController = TextEditingController();
  final homeNoTxtController = TextEditingController();
  final locationTxtController = TextEditingController();
  final districtTxtController = TextEditingController();
  final pinTxtController = TextEditingController();
  final whatsApp1 = TextEditingController();
  final whatsApp2 = TextEditingController();
  final mobileNumber = TextEditingController();
  final email = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? lat = "";
  String? long = "";

  String? street;
  String? subLocality;
  String? locality;
  String? country;

  final textFieldFocusNode = FocusNode();
  bool _obscured = false;
  late shopModel objshopModel;
  List<shopModel> shopModelList = [];

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
    auth_cubit = LoginUserCubit();
    auth_cubit.getAllsellers();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
        child: BlocProvider<LoginUserCubit>(
          create: (context) => auth_cubit,
          child: BlocListener<LoginUserCubit, LoginUserState>(
            listener: (context, state) {
              if (state is LoginUserInitial) {
              } else if (state is LoginUserShopLoading) {
              } else if (state is LoginUserShopSucess) {
                shopModelList = state.shopModelList;
                objshopModel = shopModelList[0];
              } else if (state is LoginUserShopFail) {
              } else if (state is LoginUserLoading) {
              } else if (state is LoginUserSuccess) {
                Future.delayed(Duration(seconds: 5));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "Registration Success,Confirmation sent to your mail id"),
                  backgroundColor: Colors.green,
                ));

                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              } else if (state is LoginUserFail) {
              } else if (state is loadingdeleveryLocation) {
              } else if (state is loadingdeleverySuceess) {
                lat = state.latitude;
                long = state.longitude;
                street = state.street;
                subLocality = state.subLocality;
                locality = state.locality;
                country = state.country;
              } else if (state is loadingdeleveryFailed) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              } else {}
            },
            child: BlocBuilder<LoginUserCubit, LoginUserState>(
              builder: (context, state) {
                if (state is LoginUserInitial) {
                  return Container();
                }
                if (state is LoginUserShopLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  );
                } else if (state is LoginUserShopSucess) {
                  return SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
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
                                  color: Colors.green,
                                ),
                                Text(
                                  "Register",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            // Username
                            TextFormField(
                              controller: usernameTxtController,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: const InputDecoration(
                                labelText: "Enter your email",
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // Password
                            TextFormField(
                              obscureText: _obscured,
                              controller: passwordTxtController,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: InputDecoration(
                                labelText: "Enter your password",
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: GestureDetector(
                                    onTap: _toggleObscured,
                                    child: Icon(
                                      _obscured
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off_rounded,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // Confirm Password
                            TextFormField(
                              obscureText: _obscured,
                              controller: confirmpasswordTxtController,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: InputDecoration(
                                labelText: "Confirm password",
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: GestureDetector(
                                    onTap: _toggleObscured,
                                    child: Icon(
                                      _obscured
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off_rounded,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != passwordTxtController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // Home Name
                            TextFormField(
                              controller: homeNameTxtController,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: const InputDecoration(
                                labelText: "House name",
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your house name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: homeNoTxtController,
                                    maxLines: 1,
                                    maxLength: 100,
                                    decoration: const InputDecoration(
                                      labelText: "House Number",
                                      prefixIcon: Icon(Icons.person),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your house number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 18,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: locationTxtController,
                                    maxLines: 1,
                                    maxLength: 100,
                                    decoration: const InputDecoration(
                                      labelText: "House location",
                                      prefixIcon: Icon(Icons.person),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your house location';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Select your seller",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<shopModel>(
                                  style: const TextStyle(color: Colors.black),
                                  value: shopModelList[0],
                                  isExpanded: true,
                                  hint: const Text("Select Seller"),
                                  elevation: 4,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  dropdownColor: Colors.blueAccent[50],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  items: shopModelList.map((shopModel items) {
                                    return DropdownMenuItem<shopModel>(
                                      value: items,
                                      child: Container(
                                        height: 60,
                                        width: 250,
                                        alignment: Alignment.center,
                                        child: Text(items.name!),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (shopModel? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        objshopModel = newValue;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              controller: whatsApp1,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: const InputDecoration(
                                labelText: "Contact number 1",
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your contact number';
                                }
                                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                  return 'Please enter a valid contact number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: whatsApp2,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: const InputDecoration(
                                labelText: "Contact number 2",
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your contact number';
                                }
                                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                  return 'Please enter a valid contact number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Add your Exact delivery location",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 45,
                                  width: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                  ),
                                  child: Text("latitude"),
                                ),
                                Container(
                                  height: 45,
                                  width: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                  ),
                                  child: Text("logitude"),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    auth_cubit.getCurrentLocationDetails();
                                  },
                                  child: SizedBox(
                                    width: 100,
                                    height: 25,
                                    child: Center(child: Text("Add Location")),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (lat == "") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Please add location")));
                                  } else {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      auth_cubit.RegisterUser(UserModel(
                                        usernameTxtController.text,
                                        passwordTxtController.text,
                                        homeNameTxtController.text,
                                        homeNoTxtController.text,
                                        locationTxtController.text,
                                        "malappuram",
                                        objshopModel,
                                        pinTxtController.text,
                                        whatsApp1.text,
                                        whatsApp2.text,
                                        street!,
                                        subLocality!,
                                        locality!,
                                        country!,
                                        lat!,
                                        long!,
                                      ));
                                    }
                                  }
                                },
                                child: Text(
                                  "Register",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (state is LoginUserFail) {
                  return Center(
                    child: Text("Something went wrong"),
                  );
                } else if (state is LoginUserLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is LoginUserSuccess) {
                  return const Center(
                    child: Text("Register Success "),
                  );
                } else if (state is LoginUserFail) {
                  return const Center(
                    child: Text("Login failed"),
                  );
                } else if (state is loadingdeleveryLocation) {
                  return SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
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
                                  color: Colors.green,
                                ),
                                Text(
                                  "Register",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            // Username
                            TextFormField(
                              controller: usernameTxtController,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: const InputDecoration(
                                labelText: "Enter your email",
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // Password
                            TextFormField(
                              obscureText: _obscured,
                              controller: passwordTxtController,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: InputDecoration(
                                labelText: "Enter your password",
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: GestureDetector(
                                    onTap: _toggleObscured,
                                    child: Icon(
                                      _obscured
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off_rounded,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // Confirm Password
                            TextFormField(
                              obscureText: _obscured,
                              controller: confirmpasswordTxtController,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: InputDecoration(
                                labelText: "Confirm password",
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: GestureDetector(
                                    onTap: _toggleObscured,
                                    child: Icon(
                                      _obscured
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off_rounded,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != passwordTxtController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // Home Name
                            TextFormField(
                              controller: homeNameTxtController,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: const InputDecoration(
                                labelText: "House name",
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your house name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: homeNoTxtController,
                                    maxLines: 1,
                                    maxLength: 100,
                                    decoration: const InputDecoration(
                                      labelText: "House Number",
                                      prefixIcon: Icon(Icons.person),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your house number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 18,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: locationTxtController,
                                    maxLines: 1,
                                    maxLength: 100,
                                    decoration: const InputDecoration(
                                      labelText: "House location",
                                      prefixIcon: Icon(Icons.person),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your house location';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const SizedBox(
                              width: 13,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Select your seller",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<shopModel>(
                                  style: const TextStyle(color: Colors.black),
                                  value: shopModelList[0],
                                  isExpanded: true,
                                  hint: const Text("Select District"),
                                  elevation: 4,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  dropdownColor: Colors.blueAccent[50],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  items: shopModelList.map((shopModel items) {
                                    return DropdownMenuItem<shopModel>(
                                      value: items,
                                      child: Container(
                                        height: 60,
                                        width: 250,
                                        alignment: Alignment.center,
                                        child: Text(items.name!),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (shopModel? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        objshopModel = newValue;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              controller: whatsApp1,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: const InputDecoration(
                                labelText: "Contact number 1",
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your contact number';
                                }
                                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                  return 'Please enter a valid contact number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: whatsApp2,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: const InputDecoration(
                                labelText: "Contact number 2",
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your contact number';
                                }
                                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                  return 'Please enter a valid contact number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Add your Exact delivery location",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 45,
                                  width: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                  ),
                                  child: Text("latitude"),
                                ),
                                Container(
                                  height: 45,
                                  width: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                  ),
                                  child: Text("logitude"),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    auth_cubit.getCurrentLocationDetails();
                                  },
                                  child: SizedBox(
                                    width: 100,
                                    height: 28,
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: Colors.white,
                                    )),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (lat == "") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Please add location")));
                                  } else {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      auth_cubit.RegisterUser(UserModel(
                                        usernameTxtController.text,
                                        passwordTxtController.text,
                                        homeNameTxtController.text,
                                        homeNoTxtController.text,
                                        locationTxtController.text,
                                        "malappuram",
                                        objshopModel,
                                        pinTxtController.text,
                                        whatsApp1.text,
                                        whatsApp2.text,
                                        street!,
                                        subLocality!,
                                        locality!,
                                        country!,
                                        lat!,
                                        long!,
                                      ));
                                    }
                                  }
                                },
                                child: Text(
                                  "Register",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (state is loadingdeleverySuceess) {
                  return SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
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
                                  color: Colors.green,
                                ),
                                Text(
                                  "Register",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            // Username
                            TextFormField(
                              controller: usernameTxtController,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: const InputDecoration(
                                labelText: "Enter your email",
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // Password
                            TextFormField(
                              obscureText: _obscured,
                              controller: passwordTxtController,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: InputDecoration(
                                labelText: "Enter your password",
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: GestureDetector(
                                    onTap: _toggleObscured,
                                    child: Icon(
                                      _obscured
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off_rounded,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // Confirm Password
                            TextFormField(
                              obscureText: _obscured,
                              controller: confirmpasswordTxtController,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: InputDecoration(
                                labelText: "Confirm password",
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: GestureDetector(
                                    onTap: _toggleObscured,
                                    child: Icon(
                                      _obscured
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off_rounded,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != passwordTxtController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // Home Name
                            TextFormField(
                              controller: homeNameTxtController,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: const InputDecoration(
                                labelText: "House name",
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your house name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: homeNoTxtController,
                                    maxLines: 1,
                                    maxLength: 100,
                                    decoration: const InputDecoration(
                                      labelText: "House Number",
                                      prefixIcon: Icon(Icons.person),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your house number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 18,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: locationTxtController,
                                    maxLines: 1,
                                    maxLength: 100,
                                    decoration: const InputDecoration(
                                      labelText: "House location",
                                      prefixIcon: Icon(Icons.person),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your house location';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Select your seller",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<shopModel>(
                                  style: const TextStyle(color: Colors.black),
                                  value: shopModelList[0],
                                  isExpanded: true,
                                  hint: const Text("Select District"),
                                  elevation: 4,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  dropdownColor: Colors.blueAccent[50],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  items: shopModelList.map((shopModel items) {
                                    return DropdownMenuItem<shopModel>(
                                      value: items,
                                      child: Container(
                                        height: 60,
                                        width: 250,
                                        alignment: Alignment.center,
                                        child: Text(items.name!),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (shopModel? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        objshopModel = newValue;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              controller: whatsApp1,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: const InputDecoration(
                                labelText: "Contact number 1",
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your contact number';
                                }
                                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                  return 'Please enter a valid contact number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: whatsApp2,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: const InputDecoration(
                                labelText: "Contact number 2",
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your contact number';
                                }
                                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                  return 'Please enter a valid contact number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Add your Exact delivery location",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 45,
                                  width: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                  ),
                                  child: Text(state.latitude),
                                ),
                                Container(
                                  height: 45,
                                  width: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                  ),
                                  child: Text(state.longitude),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    auth_cubit.getCurrentLocationDetails();
                                  },
                                  child: SizedBox(
                                    width: 100,
                                    height: 25,
                                    child: Center(child: Text("Add Location")),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (lat == "") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Please add location")));
                                  } else {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      auth_cubit.RegisterUser(UserModel(
                                        usernameTxtController.text,
                                        passwordTxtController.text,
                                        homeNameTxtController.text,
                                        homeNoTxtController.text,
                                        locationTxtController.text,
                                        "malappuram",
                                        objshopModel,
                                        pinTxtController.text,
                                        whatsApp1.text,
                                        whatsApp2.text,
                                        street!,
                                        subLocality!,
                                        locality!,
                                        country!,
                                        lat!,
                                        long!,
                                      ));
                                    }
                                  }
                                },
                                child: Text(
                                  "Register",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (state is loadingdeleveryFailed) {
                  return SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
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
                                  color: Colors.green,
                                ),
                                Text(
                                  "Register",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            // Username
                            TextFormField(
                              controller: usernameTxtController,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: const InputDecoration(
                                labelText: "Enter your email",
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // Password
                            TextFormField(
                              obscureText: _obscured,
                              controller: passwordTxtController,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: InputDecoration(
                                labelText: "Enter your password",
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: GestureDetector(
                                    onTap: _toggleObscured,
                                    child: Icon(
                                      _obscured
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off_rounded,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // Confirm Password
                            TextFormField(
                              obscureText: _obscured,
                              controller: confirmpasswordTxtController,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: InputDecoration(
                                labelText: "Confirm password",
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: GestureDetector(
                                    onTap: _toggleObscured,
                                    child: Icon(
                                      _obscured
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off_rounded,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != passwordTxtController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // Home Name
                            TextFormField(
                              controller: homeNameTxtController,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: const InputDecoration(
                                labelText: "House name",
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your house name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: homeNoTxtController,
                                    maxLines: 1,
                                    maxLength: 100,
                                    decoration: const InputDecoration(
                                      labelText: "House Number",
                                      prefixIcon: Icon(Icons.person),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your house number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 18,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: locationTxtController,
                                    maxLines: 1,
                                    maxLength: 100,
                                    decoration: const InputDecoration(
                                      labelText: "House location",
                                      prefixIcon: Icon(Icons.person),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your house location';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Text("Select your seller"),
                            const SizedBox(
                              width: 30,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<shopModel>(
                                  style: const TextStyle(color: Colors.black),
                                  value: shopModelList[0],
                                  isExpanded: true,
                                  hint: const Text("Select District"),
                                  elevation: 4,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  dropdownColor: Colors.blueAccent[50],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  items: shopModelList.map((shopModel items) {
                                    return DropdownMenuItem<shopModel>(
                                      value: items,
                                      child: Container(
                                        height: 60,
                                        width: 250,
                                        alignment: Alignment.center,
                                        child: Text(items.name!),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (shopModel? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        objshopModel = newValue;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              controller: whatsApp1,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: const InputDecoration(
                                labelText: "Contact number 1",
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your contact number';
                                }
                                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                  return 'Please enter a valid contact number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: whatsApp2,
                              maxLines: 1,
                              maxLength: 100,
                              decoration: const InputDecoration(
                                labelText: "Contact number 2",
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your contact number';
                                }
                                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                  return 'Please enter a valid contact number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text("Add your Exact delivery location"),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 45,
                                  width: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                  ),
                                  child: Text("latitude"),
                                ),
                                Container(
                                  height: 45,
                                  width: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                  ),
                                  child: Text("logitude"),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    auth_cubit.getCurrentLocationDetails();
                                  },
                                  child: SizedBox(
                                    width: 100,
                                    height: 25,
                                    child: Center(child: Text("try again")),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (lat == "") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Please add location")));
                                  } else {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      auth_cubit.RegisterUser(UserModel(
                                        usernameTxtController.text,
                                        passwordTxtController.text,
                                        homeNameTxtController.text,
                                        homeNoTxtController.text,
                                        locationTxtController.text,
                                        "malappuram",
                                        objshopModel,
                                        pinTxtController.text,
                                        whatsApp1.text,
                                        whatsApp2.text,
                                        street!,
                                        subLocality!,
                                        locality!,
                                        country!,
                                        lat!,
                                        long!,
                                      ));
                                    }
                                  }
                                },
                                child: Text(
                                  "Register",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

///todo location addded or not
