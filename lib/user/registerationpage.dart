import 'package:fastbuy/core/constants.dart';
import 'package:fastbuy/core/fbtheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../admin/adminModels/regmodel.dart';

class Registration extends ConsumerStatefulWidget {
  const Registration({super.key});

  @override
  RegistrationState createState() => RegistrationState();
}

class RegistrationState extends ConsumerState {
/*
  "userName": userModel.UserName,
  "password": userModel.Password,
  'houseName': userModel.HouseName,
  'homeNo': userModel.HomeNo,
  'location': userModel.location,
  'district': userModel.District,
  'pin': userModel.District,
  'whatsAppNo': userModel.whatsAppNo,
  'contactNo2': userModel.ContactNo2,

  */

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

  final textFieldFocusNode = FocusNode();
  bool _obscured = false;
  String dropDownString = "Malappuram";

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                    "Register",
                    style: fbTextTheme.lightTxttheme.headlineMedium,
                  ),
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              //user name
              TextField(
                controller: usernameTxtController,
                maxLines: 1,
                maxLength: 100,
                decoration: const InputDecoration(
                    labelText: "Enter your email",
                    prefixIcon: Icon(Icons.person)),
              ),

              const SizedBox(
                height: 8,
              ),
              TextField(
                  obscureText: _obscured,
                  controller: passwordTxtController,
                  maxLines: 1,
                  maxLength: 100,
                  decoration: InputDecoration(
                      labelText: "Enter your password",
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
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
              const SizedBox(
                height: 8,
              ),
              TextField(
                  obscureText: _obscured,
                  controller: confirmpasswordTxtController,
                  maxLines: 1,
                  maxLength: 100,
                  decoration: InputDecoration(
                      labelText: "Confirm password",
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
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

              const SizedBox(
                height: 8,
              ),

              //mobile number
              TextField(
                controller: homeNameTxtController,
                maxLines: 1,
                maxLength: 100,
                decoration: const InputDecoration(
                    labelText: "House name", prefixIcon: Icon(Icons.person)),
              ),

              const SizedBox(
                height: 8,
              ),

              //mobile number

              TextField(
                controller: homeNameTxtController,
                maxLines: 1,
                maxLength: 100,
                decoration: const InputDecoration(
                    labelText: "House Number", prefixIcon: Icon(Icons.person)),
              ),

              const SizedBox(
                height: 8,
              ),

              /*
          final locationTxtController = TextEditingController();
          final districtTxtController = TextEditingController();
          final pinTxtController = TextEditingController();
          final whatsApp1 = TextEditingController();
          final whatsApp2 = TextEditingController();
        
        * */

              TextField(
                controller: locationTxtController,
                maxLines: 1,
                maxLength: 100,
                decoration: const InputDecoration(
                    labelText: "House location",
                    prefixIcon: Icon(Icons.person)),
              ),

              const SizedBox(
                height: 8,
              ),

              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  style: TextStyle(color: Colors.black),
                  value: dropDownString,
                  isExpanded: true,
                  hint: Text("Select District"),
                  elevation: 4,

                  icon: const Icon(Icons.keyboard_arrow_down),
                  dropdownColor: Colors.blueAccent[50],
                  // Background color for the dropdown list
                  borderRadius: BorderRadius.all(Radius.circular(10)),

                  items: ['Malappuram', 'Kozhikode', 'Vayanadu']
                      .map((String items) {
                    return DropdownMenuItem<String>(
                      value: items,
                      child: Container(
                        height: 60,
                        width: 100,
                        alignment: Alignment.center,
                        child: Text(items),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        dropDownString = newValue;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),

              TextField(
                controller: whatsApp1,
                maxLines: 1,
                maxLength: 100,
                decoration: const InputDecoration(
                    labelText: "Contact app nunber 1",
                    prefixIcon: Icon(Icons.person)),
              ),

              const SizedBox(
                height: 8,
              ),

              TextField(
                controller: whatsApp2,
                maxLines: 1,
                maxLength: 100,
                decoration: const InputDecoration(
                    labelText: "Contact app nunber 2",
                    prefixIcon: Icon(Icons.person)),
              ),

              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {},
                    child: Text(
                      "Register",
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
