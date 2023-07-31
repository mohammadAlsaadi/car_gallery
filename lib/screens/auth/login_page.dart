// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

import '../../Colors/colorTheme.dart';
import '../homePage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<Map<String, dynamic>?> loadSignUpData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? signUpJson = prefs.getString('signUpData');
    if (signUpJson != null) {
      return json.decode(signUpJson);
    }
    return null;
  }

  String? _validateEmail(var value) {
    if (value.isEmpty) {
      return 'Email required';
    }

    // Check if the email contains the "@gmail.com" domain
    if (!value.contains("@gmail.com")) {
      return 'Invalid email format. It must be like XX@XX.com';
    }

    return null; // Return null if the email is valid
  }

  //_________________pass reqexp

  bool isPasswordValid(String password) {
    // Password must contain at least one uppercase letter, one special character, and one digit.
    RegExp regex = RegExp(r'^(?=.*[A-Z])(?=.*[!@#$%^&*])(?=.*[0-9]).{8,}$');
    return regex.hasMatch(password);
  }

  //___________________________________
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObsecure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 90),
              child: Text(
                "Login",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 70,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    validator: _validateEmail,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: "Email",
                      labelStyle: const TextStyle(
                        color: appBarColor,
                      ),
                      isDense: true,
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: appBarColor,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSaved: (value) {
                      _emailController.text = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _isObsecure,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'required ,Please enter a password';
                      }
                      if (!isPasswordValid(value)) {
                        return 'Password must contain at least one uppercase letter,\n one special character, and one digit.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: "Password",
                      labelStyle: const TextStyle(
                        color: appBarColor,
                      ),
                      isDense: true,
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObsecure = !_isObsecure;
                            });
                          },
                          icon: Icon(!_isObsecure
                              ? Icons.visibility
                              : Icons.visibility_off)),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.visiblePassword,
                    onSaved: (value) {
                      _passwordController.text = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0, top: 70),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(appBarColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        Map<String, dynamic>? signUpData =
                            await loadSignUpData();
                        if (signUpData != null &&
                            signUpData['email'] == _emailController.text &&
                            signUpData['password'] ==
                                _passwordController.text) {
                          // Login successful, navigate to the home page
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                            (route) => false,
                          );
                        } else {
                          // Login failed, show an error message
                          const snackBar = SnackBar(
                            content: Text(
                                'Invalid credentials. Please check your email and password.'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}




/*
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        // String userEmail = _emailController.text;
                        // String userPassword = _passwordController.text;
                        // String userName = _nameController.text;

                        // UserAuth newUserSignup = UserAuth(
                        //     email: userEmail,
                        //     password: userPassword,
                        //     name: userName);

                        //Navigator.pop(context, newUserSignup);

                        //print(newUserSignup);
                        const snackBar = SnackBar(
                          content: Text('sign up  seccessed'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      }
                      */