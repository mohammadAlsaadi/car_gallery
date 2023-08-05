// ignore_for_file: file_names
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CarInfo {
  String carName;
  String carPrice;
  String carDate;
  String userID;
  String carImage;

  CarInfo(
      {required this.carName,
      required this.carPrice,
      required this.carDate,
      required this.userID,
      required this.carImage});

  Map<String, dynamic> toJson() {
    return {
      'carName': carName,
      'carPrice': carPrice,
      'carDate': carDate,
      'uid': userID,
      'carImage': carImage
    };
  }

  // Create a CarInfo object from a JSON representation
  factory CarInfo.fromJson(Map<String, dynamic> json) {
    return CarInfo(
      carName: json['carName'],
      carPrice: json['carPrice'],
      carDate: json['carDate'],
      userID: json['uid'],
      carImage: json['carImage'],
    );
  }
}

const String carImage = "images/carImage.jpeg";
