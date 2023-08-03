// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:task1/trash/addPage.dart';
import 'package:task1/screens/getStarted.dart';
import 'package:task1/screens/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/utilis/constans.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MyApp({Key? key});
  Future<String> getUUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = prefs.getString('currentUserId') ?? "";
    return uuid;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<String>(
        future: getUUID(),
        builder: (context, snapshot) {
          String? currentUserId = snapshot.data;
          if (currentUserId != null && currentUserId.isNotEmpty) {
            // If the currentUserId is not null or empty, show the HomePage
            shardUserId = currentUserId;
            return HomePage(currentUserID: currentUserId);
          } else if (currentUserId == null) {
            // If the currentUserId is null or empty, show the GetStarted page
            return const Center(child: CircularProgressIndicator());
          } else {
            return const GetStarted();
          }
        },
      ),
    );
  }
}

/*

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurrentUser(), // Provide the CurrentUser instance
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/GetStarted',
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
      ),
    );
  }
}
*/