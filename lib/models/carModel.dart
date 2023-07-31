// ignore_for_file: file_names

class CarInfo {
  String carName;
  String carPrice;
  String carDate;

  CarInfo(
      {required this.carName, required this.carPrice, required this.carDate});

  Map<String, dynamic> toJson() {
    return {
      'carName': carName,
      'carPrice': carPrice,
      'carDate': carDate,
    };
  }

  // Create a CarInfo object from a JSON representation
  factory CarInfo.fromJson(Map<String, dynamic> json) {
    return CarInfo(
      carName: json['carName'],
      carPrice: json['carPrice'],
      carDate: json['carDate'],
    );
  }
}

const String carImage = "images/carImage.jpeg";
