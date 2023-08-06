// ignore_for_file: file_names
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum CarType {
  Mersedes,
  Audi,
  BMW,
  Dodge,
  ford,
}

extension CarTypeExtension on CarType {
  int get id {
    switch (this) {
      case CarType.Mersedes:
        return 1;
      case CarType.Audi:
        return 2;
      case CarType.BMW:
        return 3;
      case CarType.Dodge:
        return 4;
      case CarType.ford:
        return 5;
      // Add more cases here
    }
  }
}

CarType carTypeFromId(int id) {
  switch (id) {
    case 1:
      return CarType.Mersedes;
    case 2:
      return CarType.Audi;
    case 3:
      return CarType.BMW;
    case 4:
      return CarType.Dodge;
    case 5:
      return CarType.ford;
    // Add more cases here
    default:
      throw Exception('Invalid car type id: $id');
  }
}

enum CarColor {
  Red,
  Blue,
  Green,
  White,
  Pink,
  Grey,
  Orange,
}

extension CarColorExtension on CarColor {
  String get hexValue {
    switch (this) {
      case CarColor.Red:
        return 'FF0000';
      case CarColor.Blue:
        return '0000FF';
      case CarColor.Green:
        return '00FF00';
      case CarColor.White:
        return 'FFFFFF';
      case CarColor.Pink:
        return 'FFC0CB';
      case CarColor.Grey:
        return '808080';
      case CarColor.Orange:
        return 'FFA500';
    }
  }
}

CarColor carColorFromHexValue(String hexValue) {
  switch (hexValue) {
    case 'FF0000':
      return CarColor.Red;
    case '0000FF':
      return CarColor.Blue;
    case '00FF00':
      return CarColor.Green;
    case 'FFFFFF':
      return CarColor.White;
    case 'FFC0CB':
      return CarColor.Pink;
    case '808080':
      return CarColor.Grey;
    case 'FFA500':
      return CarColor.Orange;

    default:
      throw Exception('Invalid car color hex value: $hexValue');
  }
}

class CarInfo {
  String carName;
  String carPrice;
  String carDate;
  String userID;
  String carImage;
  // CarType carType;
  // CarColor color;

  CarInfo({
    required this.carName,
    required this.carPrice,
    required this.carDate,
    required this.userID,
    required this.carImage,
    // required this.carType,
    // required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'carName': carName,
      'carPrice': carPrice,
      'carDate': carDate,
      'uid': userID,
      'carImage': carImage,
      // 'carType': carType.id,
      // 'color': color.hexValue,
    };
  }

  factory CarInfo.fromJson(Map<String, dynamic> json) {
    return CarInfo(
      carName: json['carName'],
      carPrice: json['carPrice'],
      carDate: json['carDate'],
      userID: json['uid'],
      carImage: json['carImage'],
      // carType: carTypeFromId(json['carType']),
      // color: carColorFromHexValue(json['color']),
    );
  }
}
