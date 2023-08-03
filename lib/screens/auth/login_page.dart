// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/service/currentUser.dart';
import 'package:task1/utilis/constans.dart';

import '../../Colors/colorTheme.dart';
import '../../models/userAuthModel.dart';
import '../homePage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<UserAuth> signUpData = [];

  @override
  void initState() {
    super.initState();
    _loadSignUpData();
  }

  Future<void> _loadSignUpData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonUsers = prefs.getString('users') ?? '[]';
    List<dynamic> userData = jsonDecode(jsonUsers);
    signUpData = userData.map((user) => UserAuth.fromJson(user)).toList();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email required';
    }

    if (!value.contains("@gmail.com")) {
      return 'Invalid email format. It must be like XX@XX.com';
    }

    return null;
  }

  bool isPasswordValid(String password) {
    RegExp regex = RegExp(r'^(?=.*[A-Z])(?=.*[!@#$%^&*])(?=.*[0-9]).{8,}$');
    return regex.hasMatch(password);
  }

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
                    controller: _emailController,
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
                        _handleLogin();
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

  void _handleLogin() {
    String email = _emailController.text;
    String password = _passwordController.text;

    UserAuth? currentUser;
    for (var user in signUpData) {
      if (user.email == email && user.password == password) {
        currentUser = user;
        break;
      }
    }

    if (currentUser != null) {
      // Login successful, navigate to the home page
      CurrentUser().signUpCurrent(currentUser.uid!);
      setState(() {
        shardUserId = currentUser!.uid;
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(currentUserID: shardUserId),
        ),
        (route) => false,
      );
    } else {
      // Login failed, show an error message
      const snackBar = SnackBar(
        content:
            Text('Invalid credentials. Please check your email and password.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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