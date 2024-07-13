import 'package:fastbuy/core/constants.dart';
import 'package:fastbuy/core/fbtheme.dart';
import 'package:fastbuy/screens/homepage.dart';
import 'package:fastbuy/screens/registerationpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class login extends ConsumerStatefulWidget {
  const login({super.key});

  @override
  _loginState createState() => _loginState();
}

class _loginState extends ConsumerState {
  final email = TextEditingController();
  final password = TextEditingController();

  final textFieldFocusNode = FocusNode();
  bool _obscured = false;
  final _formKey = GlobalKey<FormState>();
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
                  "fastbuy",
                  style: fbTextTheme.lightTxttheme.headlineLarge,
                ),
              ],
            ),
            SizedBox(
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
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: "Enter your email",
                          prefixIcon: Icon(Icons.person)),
                    ),
                    SizedBox(
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
                  ],
                )),
            SizedBox(
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
            SizedBox(
              height: 18,
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    child: Text(
                      "Login",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )),
            ),
            SizedBox(
              height: 18,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Registration()));
              },
              child: Text(
                "Not Registered Yet? SignUp here",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            )
          ],
        ),
      ),
    );
  }
}
