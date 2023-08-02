import 'package:flutter/material.dart';
import 'package:task1/screens/addPage.dart';
import 'package:task1/screens/auth/login_page.dart';
import 'package:task1/screens/getStarted.dart';
import 'package:task1/screens/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            // Handle the error case here
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else {
            String? currentUserId = snapshot.data;
            if (currentUserId != null && currentUserId.isNotEmpty) {
              // If the currentUserId is not null or empty, show the HomePage
              return HomePage(currentUserID: currentUserId);
            } else {
              // If the currentUserId is null or empty, show the GetStarted page
              return GetStarted();
            }
          }
        },
      ),
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