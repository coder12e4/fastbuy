import 'package:fastbuy/core/constants.dart';
import 'package:fastbuy/core/fbtheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Registration extends ConsumerStatefulWidget {
  const Registration({super.key});

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends ConsumerState {
  final username = TextEditingController();
  final mobileNumber = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmpassword = TextEditingController();
  final textFieldFocusNode = FocusNode();
  bool _obscured = false;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
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
            SizedBox(
              height: 18,
            ),
//user name
            TextField(
              controller: username,
              maxLines: 1,
              maxLength: 100,
              decoration: InputDecoration(
                  labelText: "Enter your email",
                  prefixIcon: Icon(Icons.person)),
            ),
            SizedBox(
              height: 8,
            ),
            //mobile number
            TextField(
              controller: mobileNumber,
              maxLines: 1,
              maxLength: 100,
              decoration: InputDecoration(
                  labelText: "Enter your email",
                  prefixIcon: Icon(Icons.person)),
            ),

            SizedBox(
              height: 18,
            ),
            TextField(
              controller: email,
              maxLines: 1,
              maxLength: 100,
              decoration: InputDecoration(
                  labelText: "Enter your email",
                  prefixIcon: Icon(Icons.person)),
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
                obscureText: _obscured,
                controller: password,
                maxLines: 1,
                maxLength: 100,
                decoration: InputDecoration(
                    labelText: "Enter your password",
                    prefixIcon: Icon(
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
            SizedBox(
              height: 8,
            ),
            TextField(
                obscureText: _obscured,
                controller: password,
                maxLines: 1,
                maxLength: 100,
                decoration: InputDecoration(
                    labelText: "Confirm password",
                    prefixIcon: Icon(
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

            SizedBox(
              height: 8,
            ),

            Container(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {},
                  child: Container(
                    child: Text(
                      "Register",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
