// ignore_for_file: file_names
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CarInfo {
  String carName;
  String carPrice;
  String carDate;
  String userID;

  CarInfo(
      {required this.carName,
      required this.carPrice,
      required this.carDate,
      required this.userID});

  Map<String, dynamic> toJson() {
    return {
      'carName': carName,
      'carPrice': carPrice,
      'carDate': carDate,
      'uid': userID,
    };
  }

  // Create a CarInfo object from a JSON representation
  factory CarInfo.fromJson(Map<String, dynamic> json) {
    return CarInfo(
      carName: json['carName'],
      carPrice: json['carPrice'],
      carDate: json['carDate'],
      userID: json['uid'],
    );
  }

  static Future<List<CarInfo>> fetchCarListForUser(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonCars = prefs.getString('cars_$uid') ?? '[]';
    List<dynamic> carData = jsonDecode(jsonCars);
    List<CarInfo> cars = carData.map((car) => CarInfo.fromJson(car)).toList();
    return cars;
  }
}

const String carImage = "images/carImage.jpeg";
