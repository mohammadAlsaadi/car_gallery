import 'package:flutter/material.dart';
import 'package:task1/screens/addPage.dart';
import 'package:task1/screens/auth/login_page.dart';
import 'package:task1/screens/getStarted.dart';
import 'package:task1/screens/homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/HomePage',
      routes: {
        '/GetStarted': (context) => const GetStarted(),
        '/HomePage': (context) => const HomePage(),
        '/AddPage': (context) => const AddPage(),
        '/Login': (context) => const Login(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/AddPage') {
          return MaterialPageRoute(
            builder: (context) => const AddPage(),
          );
        }
        return null;
      },
    );
  }
}
