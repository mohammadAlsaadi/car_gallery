// ignore_for_file: depend_on_referenced_packages, file_names

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/carModel.dart';

import '../screens/getStarted.dart';
import '../utilis/constans.dart';

enum SortOption {
  date,
  name,
  price,
}

List<CarInfo> carList = [];
bool isLoadingUserData = true;
bool isLoadingCarData = true;

class SharedFunction {
  static void handleLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const GetStarted(),
      ),
      (route) => false,
    );
  }

  static Future<void> loadCarData(String? userId) async {
    if (userId == null) {
      isLoadingCarData = false;
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonCars = prefs.getString('cars_$userId') ?? '[]';
    List<dynamic> carData = jsonDecode(jsonCars);
    List<CarInfo> cars = carData.map((car) => CarInfo.fromJson(car)).toList();

    carList = cars;
    isLoadingCarData = false;
  }

  static void saveCars() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonCars = jsonEncode(carList);
    prefs.setString('cars_$shardUserId', jsonCars);
  }
}
