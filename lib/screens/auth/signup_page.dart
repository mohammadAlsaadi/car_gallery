// ignore_for_file: avoid_print, unused_field, depend_on_referenced_packages, use_build_context_synchronously
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:task1/screens/homePage.dart';
import 'package:task1/utilis/constans.dart';
import 'package:uuid/uuid.dart';
import '../../ColorsAndFont/colorTheme.dart';
import '../../models/userAuthModel.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../service/currentUser.dart';

FocusNode passwordFocusNode = FocusNode();

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FocusNode focusNode = FocusNode();
//___________________------
  Future<void> saveSignUpData(UserAuth newUserSignup) async {
    List<UserAuth> users = await _loadUsers();
    users.add(newUserSignup);

    final signUpData = users.map((user) => user.toJson()).toList();
    final signUpJson = json.encode(signUpData);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('users', signUpJson);
  }

  Future<List<UserAuth>> _loadUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonUsers = prefs.getString('users') ?? '[]';
    List<dynamic> userData = jsonDecode(jsonUsers);
    List<UserAuth> users =
        userData.map((user) => UserAuth.fromJson(user)).toList();
    return users;
  }

  //_______________________
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confpasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool phoneHasError = false;

  //_____________________________validation Bool __________________________________
  bool _isPasswordValid = true;
  bool capitalLetterValid = false;
  bool specialCharacterValid = false;
  bool numberValid = false;
//_______________________________pass case
  bool isPasswordValid(String password) {
    RegExp uppercaseRegex = RegExp(r'[A-Z]');
    RegExp specialCharRegex = RegExp(r'[!@#$%^&*]');
    RegExp digitRegex = RegExp(r'\d');

    capitalLetterValid = uppercaseRegex.hasMatch(password);
    specialCharacterValid = specialCharRegex.hasMatch(password);
    numberValid = digitRegex.hasMatch(password);

    return capitalLetterValid && specialCharacterValid && numberValid;
  }

  final TextEditingController _nameController = TextEditingController();
  bool _isObsecure = true;
  bool _isObsecure2 = true;

  //____________________vadidate email_________________________________
  String? _validateEmail(var value) {
    if (value.isEmpty) {
      return 'Email required';
    }

    if (!value.contains("@gmail.com")) {
      return 'Invalid email format. It must be like XX@XX.com';
    }

    return null;
  }

  String generateUID() {
    const uuid = Uuid();
    return uuid.v4();
  }

  @override
  Widget build(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    double pageHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 70),
              child: Text(
                "Sign Up",
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
                SizedBox(
                  height: pageHeight * 0.03,
                ),
                Padding(
                  padding: EdgeInsets.all(pageWidth * 0.05),
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
                  padding: EdgeInsets.all(pageWidth * 0.05),
                  child: TextFormField(
                    controller: _passwordController,
                    focusNode: passwordFocusNode,
                    obscureText: _isObsecure,
                    onChanged: (value) {
                      setState(() {
                        _isPasswordValid = isPasswordValid(value);
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty ||
                          capitalLetterValid == false ||
                          specialCharacterValid == false ||
                          numberValid == false) {
                        return 'This feild is required, must contain : ';
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
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: appBarColor,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObsecure = !_isObsecure;
                            });
                          },
                          icon: Icon(
                              !_isObsecure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: appBarColor)),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.visiblePassword,
                    onSaved: (value) {
                      _passwordController.text = value!;
                    },
                  ),
                ),
                passwordFocusNode.hasFocus
                    ? Padding(
                        padding: EdgeInsets.only(
                            left: pageWidth * 0.06, right: pageWidth * 0.06),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 236, 236, 236),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: pageWidth * 0.05),
                          child: Padding(
                            padding: EdgeInsets.all(pageWidth * 0.01),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'A - Z, at least one uppercase letter',
                                    style: TextStyle(
                                      color: capitalLetterValid
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    '# \$ @ ! % * ^ &, at least one special character',
                                    style: TextStyle(
                                      color: specialCharacterValid
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    '0 1 ... 8 9, at least one digit number',
                                    style: TextStyle(
                                      color: numberValid
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Padding(
                  padding: EdgeInsets.all(pageWidth * 0.05),
                  child: TextFormField(
                    controller: _confpasswordController,
                    obscureText: _isObsecure2,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'required ,Please enter a password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
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
                      labelText: "confirm Password",
                      labelStyle: const TextStyle(
                        color: appBarColor,
                      ),
                      isDense: true,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: appBarColor,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObsecure2 = !_isObsecure2;
                            });
                          },
                          icon: Icon(
                            !_isObsecure2
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: appBarColor,
                          )),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.visiblePassword,
                    onSaved: (value) {
                      _confpasswordController.text = value!;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(pageWidth * 0.05),
                  child: TextFormField(
                    controller: _nameController,
                    validator: (value) =>
                        value!.isEmpty ? " name required  " : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: " User name ",
                      labelStyle: const TextStyle(
                        color: appBarColor,
                      ),
                      isDense: true,
                      prefixIcon: const Icon(
                        Icons.person_2_rounded,
                        color: appBarColor,
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSaved: (value) {
                      _nameController.text = value!;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(pageWidth * 0.05),
                  child: IntlPhoneField(
                    dropdownIcon: const Icon(
                      Icons.arrow_drop_down,
                      color: appBarColor,
                    ),
                    controller: _phoneNumberController,
                    validator: (value) {
                      if (value == null || value.toString().isEmpty) {
                        setState(() {
                          phoneHasError = true;
                        });
                      } else {
                        setState(() {
                          phoneHasError = false;
                        });
                      }
                      return null;
                    },
                    initialCountryCode: "JO",
                    focusNode: focusNode,
                    cursorColor: appBarColor,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: appBarColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: phoneHasError ? Colors.red : Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: phoneHasError ? Colors.red : Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: phoneHasError ? Colors.red : Colors.grey),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: 'Phone Number',
                    ),
                    languageCode: "en",
                    onCountryChanged: (country) {
                      print('Country changed to: ${country.name}');
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: pageHeight * 0.01),
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
                      if (_phoneNumberController.text.isNotEmpty) {
                        setState(() {
                          phoneHasError = false;
                        });
                      }
                      if (_phoneNumberController.text.isEmpty &&
                          _formKey.currentState!.validate() == false) {
                        setState(() {
                          phoneHasError = true;
                        });
                      }
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        String userUID = generateUID();

                        UserAuth newUserSignup = UserAuth(
                          uid: userUID,
                          email: _emailController.text,
                          password: _passwordController.text,
                          name: _nameController.text,
                          phoneNumber: _phoneNumberController.text,
                        );

                        await saveSignUpData(newUserSignup);

                        CurrentUser currentUser = CurrentUser();
                        currentUser.signUpCurrent(userUID);

                        const snackBar = SnackBar(
                          content: Text('Sign up successful'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        setState(() {
                          shardUserId = userUID;
                          print(shardUserId);
                        });
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(
                                currentUserID: shardUserId,
                                userName: newUserSignup.name,
                                phone: newUserSignup.phoneNumber),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: Text(
                        "Sign Up",
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
