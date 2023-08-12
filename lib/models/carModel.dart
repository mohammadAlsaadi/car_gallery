// ignore_for_file: file_names

class CarInfo {
  String carName;
  String carPrice;
  String carDate;
  String userID;
  String carImage;
  String carType;
  String? carColor;
  int? colorSelected;
  int? typeSelected;

  CarInfo(
      {required this.carName,
      required this.carPrice,
      required this.carDate,
      required this.userID,
      required this.carImage,
      required this.carType,
      required this.carColor,
      required this.colorSelected,
      required this.typeSelected});

  Map<String, dynamic> toJson() {
    return {
      'carName': carName,
      'carPrice': carPrice,
      'carDate': carDate,
      'uid': userID,
      'carImage': carImage,
      'carType': carType,
      'color': carColor,
      'colorSelected': colorSelected,
      'typeSelected': typeSelected,
    };
  }

  factory CarInfo.fromJson(Map<String, dynamic> json) {
    return CarInfo(
      carName: json['carName'],
      carPrice: json['carPrice'],
      carDate: json['carDate'],
      userID: json['uid'],
      carImage: json['carImage'],
      carType: (json['carType']),
      carColor: (json['carColor']),
      typeSelected: (json['typeSelected']),
      colorSelected: (json['colorSelected']),
    );
  }
}
