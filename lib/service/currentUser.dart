// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:shared_preferences/shared_preferences.dart';

class CurrentUser {
  String? currentUserId;

  Future<void> signUpCurrent(String newUid) async {
    currentUserId = newUid;

    // Save the currentUserId in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentUserId', currentUserId!);
  }

  void logout() {
    currentUserId = null;

    // Remove the currentUserId from shared preferences
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('currentUserId');
    });
  }
}
