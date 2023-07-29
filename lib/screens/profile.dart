import 'package:flutter/material.dart';
import 'package:task1/Colors/colorTheme.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Padding(
          padding: const EdgeInsets.only(left: 70),
          child: Text("User Profile"),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            ClipOval(
              child: Image.asset(
                "images/moalsaadi.jpg",
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                " Mohammad alsaadi",
                style: TextStyle(fontWeight: FontWeight.bold, color: button),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(white),
                backgroundColor: MaterialStateProperty.all<Color>(button),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              onPressed: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => null(),
                //     ),
                //   );
              },
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 70, right: 70, top: 10, bottom: 10),
                child: Text(
                  "Edit profile",
                  style: TextStyle(
                      fontSize: 18,
                      color: appBarColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(white),
                backgroundColor: MaterialStateProperty.all<Color>(button),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              onPressed: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => null(),
                //     ),
                //   );
              },
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 90, right: 90, top: 10, bottom: 10),
                child: Text(
                  "setting",
                  style: TextStyle(
                      fontSize: 18,
                      color: appBarColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(white),
                backgroundColor: MaterialStateProperty.all<Color>(button),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              onPressed: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => null(),
                //     ),
                //   );
              },
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 90, right: 90, top: 10, bottom: 10),
                child: Text(
                  "logout",
                  style: TextStyle(
                      fontSize: 18,
                      color: appBarColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
