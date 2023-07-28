import 'package:flutter/material.dart';
import 'package:task1/screens/addPage.dart';
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
        '/HomePage': (context) => HomePage(),
        '/AddPage': (context) => const AddPage(),
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
