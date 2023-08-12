import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:task1/ColorsAndFont/fontStyle.dart';
import 'package:task1/utilis/constans.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ColorsAndFont/colorTheme.dart';
import '../models/carModel.dart';

class AddEditPage extends StatefulWidget {
  final bool isEdit;
  final CarInfo? car;
  final String? currentUserID;

  const AddEditPage(
      {Key? key, required this.isEdit, this.car, this.currentUserID})
      : super(key: key);

  @override
  _AddEditPageState createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  bool isLoading = true;
  List<String> imageUrls = [];
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _carNameController;
  late TextEditingController _priceController;
  late TextEditingController _dateController;

  late String type;
  late String? colorCar;
  late int selectCarColor;
  late int selectCarType;
  @override
  void initState() {
    if (widget.isEdit) {
      _carNameController = TextEditingController(text: widget.car!.carName);
      _priceController = TextEditingController(text: widget.car!.carPrice);
      _dateController = TextEditingController(text: widget.car!.carDate);
      carImage = widget.car!.carImage;
      type = widget.car!.carType;
      colorCar = widget.car!.carColor;
      selectedIndexForcolor = widget.car!.colorSelected!;
      selectedIndexForType = widget.car!.typeSelected!;
      typeSelect = true;
      colorSelect = true;
      fetchCarImages();
    } else {
      _carNameController = TextEditingController();
      _priceController = TextEditingController();
      _dateController = TextEditingController();
    }
    super.initState();
  }

  Future<void> fetchCarImages() async {
    String searchQuery = typeImages[selectedIndexForType];
    String color = lstOfColors[selectedIndexForcolor];
    String orientation = 'landscape';
    String size = 'small';
    String apiUrl =
        'https://api.pexels.com/v1/search?query=$searchQuery&color=$color&size=$size&orientation=$orientation';

    try {
      final dio = Dio();
      final response = await dio.get(
        apiUrl,
        options: Options(headers: {
          'Authorization':
              '01ZYe2V35f8AeXLuqfaY6lsBWwizI6EONg5bJszNiYtlqbWFb6r81d65',
        }),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        List<String> fetchedImageUrls = [];
        for (var photo in data['photos']) {
          String imageUrl = photo['src']['original'];
          fetchedImageUrls.add(imageUrl);
        }
        setState(() {
          imageUrls = fetchedImageUrls;
          isLoading = false;
        });
      } else {
        print('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  late String carImage = '';

  // Save the selected image URL to shared_preferences
  Future<void> saveSelectedImage(String imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selected_image', imageUrl);
  }

  //_______________save all car info
  Future<void> saveCarList(List<CarInfo> cars) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final encodedCars = cars.map((car) => car.toJson()).toList();
    prefs.setString('car_list', json.encode(encodedCars));
  }

  Future<List<CarInfo>> loadCarList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final carListJson = prefs.getString('car_list');
    if (carListJson != null) {
      final decodedCars = json.decode(carListJson) as List<dynamic>;
      final carList = decodedCars.map((car) => CarInfo.fromJson(car)).toList();
      return carList;
    }
    return [];
  }

  int selectedIndexForType = -1;
  List<String> typeImages = [
    'Mercedes',
    'bmw',
    'audi',
    'Dodge',
    'ford',
  ];
  int selectedIndexForcolor = -1;
  List<Color> carColors = [
    const Color(0xffFF9800),
    const Color(0xffFFFFFF),
    const Color(0xff673AB7),
    const Color(0xff9E9E9E),
    const Color(0xff9C27B0),
    const Color(0xff000000),
  ];

  List<String> lstOfColors = [
    "FF9800", // orange
    'FFFFFF', // White;
    '673AB7', // blue
    '9E9E9E', // grey
    '9C27B0', // pink
    '000000', // blak
  ];

  bool typeSelect = false;
  bool colorSelect = false;

  @override
  Widget build(BuildContext context) {
    final double labelText = MediaQuery.of(context).size.width - 300;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Center(
          child:
              Text(widget.isEdit ? "Edit Car" : "Add Car", style: appBarFont),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  maxLines: 1,
                  softWrap: false,
                  "Select type of car",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 75,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: typeImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndexForType = index;
                            if (selectedIndexForcolor != -1) {
                              fetchCarImages();
                            }
                            type = typeImages[selectedIndexForType];
                          });
                          typeSelect = true;
                        },
                        child: selectedIndexForType == index
                            ? Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    width: 90,
                                    height: 90,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Center(
                                      child: Image.asset(
                                        'images/${typeImages[index]}.png',
                                        fit: BoxFit.cover,
                                        width: 70,
                                        height: 70,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      right: 20,
                                      bottom: 45,
                                      child: SizedBox(
                                        width: 20,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.green,
                                          child: Icon(Icons.check,
                                              size: 20, color: Colors.white),
                                        ),
                                      )),
                                ],
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                width: 80,
                                height: 80,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Center(
                                  child: Image.asset(
                                    'images/${typeImages[index]}.png',
                                    fit: BoxFit.cover,
                                    width: 73,
                                    height: 73,
                                  ),
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  maxLines: 1,
                  softWrap: false,
                  "Select color ",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 65,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: carColors.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndexForcolor = index;
                              if (selectedIndexForType != -1) {
                                fetchCarImages();
                              }
                              colorCar =
                                  lstOfColors[selectedIndexForcolor].toString();
                            });
                            colorSelect = true;
                          },
                          child: selectedIndexForcolor == index
                              ? Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            shape: BoxShape.circle,
                                            color: carColors[index]),
                                      ),
                                    ),
                                    Positioned(
                                        right: 20,
                                        bottom: 35,
                                        child: SizedBox(
                                          width: 20,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.green,
                                            child: Icon(Icons.check,
                                                size: 20, color: Colors.white),
                                          ),
                                        )),
                                  ],
                                )
                              : Container(
                                  width: 100,
                                  height: 100,
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      shape: BoxShape.circle,
                                      color: carColors[index],
                                    ),
                                  ),
                                ));
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Visibility(
                visible: typeSelect && colorSelect,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    maxLines: 1,
                    softWrap: false,
                    "Select car image",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Visibility(
                visible: typeSelect && colorSelect,
                child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        bool isSelected = carImage == imageUrls[index];
                        return Container(
                          width: 160,
                          height: 100,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                carImage = isSelected ? '' : imageUrls[index];
                              });
                              saveSelectedImage(
                                  isSelected ? '' : imageUrls[index]);
                              print(carImage);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 160,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.green
                                        : Colors.transparent,
                                    width: 5.0,
                                  ),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: imageUrls[index],
                                  placeholder: (context, url) => Center(
                                    child: Container(
                                      height: 100,
                                      width: 150,
                                      child: Shimmer.fromColors(
                                        baseColor: const Color.fromARGB(
                                            255, 212, 212, 212),
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          color: Colors.white,
                                          width: 100,
                                          height: 160,
                                        ),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: _carNameController,
                  validator: (value) =>
                      value!.isEmpty ? "Enter a car name!" : null,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: appBarColor), //<-- SEE HERE
                    ),
                    labelText: "Car Name",
                    labelStyle: TextStyle(
                      color: white,
                    ),
                    isDense: true,
                    prefixIcon: Icon(
                      Icons.car_crash,
                      color: white,
                    ),
                  ),
                  keyboardType: TextInputType.name,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (value) {
                    _carNameController.text = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: _priceController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the description of your vehicle';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: appBarColor), //<-- SEE HERE
                    ),
                    labelText: "Car Price",
                    labelStyle: TextStyle(
                      color: white,
                    ),
                    isDense: true,
                    prefixIcon: Icon(
                      Icons.attach_money_rounded,
                      color: white,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (value) {
                    _priceController.text = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: _dateController,
                  validator: (value) => value!.isEmpty ? "Enter a date!" : null,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: appBarColor), //<-- SEE HERE
                    ),
                    labelText: "Car Model",
                    labelStyle: TextStyle(
                      color: white,
                    ),
                    isDense: true,
                    prefixIcon: Icon(
                      Icons.date_range,
                      color: white,
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (value) {
                    _dateController.text = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 150),
                child: ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(appBarColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      String carName = _carNameController.text;
                      String carPrice = _priceController.text;
                      String carDate = _dateController.text;
                      String currentUserId = shardUserId!;
                      String img = carImage;

                      CarInfo newCar = CarInfo(
                          userID: currentUserId,
                          carName: carName,
                          carPrice: carPrice,
                          carDate: carDate,
                          carImage: img,
                          carType: type,
                          carColor: colorCar,
                          colorSelected: selectedIndexForcolor,
                          typeSelected: selectedIndexForType);
                      print("_________________________$selectedIndexForType");

                      List<CarInfo> existingCars = await loadCarList();
                      existingCars.add(newCar);

                      await saveCarList(existingCars);

                      Navigator.pop(context, newCar);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Text(widget.isEdit ? "Edit Car" : "Add Car"),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
