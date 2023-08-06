import 'dart:convert';
import 'package:shimmer/shimmer.dart';

import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:task1/utilis/constans.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Colors/colorTheme.dart';
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

  @override
  void initState() {
    if (widget.isEdit) {
      _carNameController = TextEditingController(text: widget.car!.carName);
      _priceController = TextEditingController(text: widget.car!.carPrice);
      _dateController = TextEditingController(text: widget.car!.carDate);
    } else {
      _carNameController = TextEditingController();
      _priceController = TextEditingController();
      _dateController = TextEditingController();
    }
    super.initState();
    fetchCarImages();
  }

  Future<void> fetchCarImages() async {
    String apiKey = '01ZYe2V35f8AeXLuqfaY6lsBWwizI6EONg5bJszNiYtlqbWFb6r81d65';
    String searchQuery = typeImages[selectedIndexForType];
    String color = lstOfColors[selectedIndexForcolor];
    String orientation = 'landscape';
    String size = 'small';

    String apiUrl =
        'https://api.pexels.com/v1/search?query=$searchQuery&color=$color&orientation=$orientation&size=$size&page=1&per_page=10';

    try {
      final dio = Dio();
      final response = await dio.get(
        apiUrl,
        options: Options(headers: {'Authorization': apiKey}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        List<String> fetchedImageUrls = [];
        for (var photo in data['media']) {
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
    const Color(0xffFF0000),
    const Color(0xff0000FF),
    const Color(0xff00FF00),
    const Color(0xffffffff),
    const Color(0xffFFC0CB),
    const Color(0xff808080),
    const Color(0xffFFA500),
  ];

  List<String> lstOfColors = [
    "FF0000", // red
    '0000FF', // Blue;
    '00FF00', // Green;
    'FFFFFF', //White;
    'FFC0CB', //Pink;
    '808080', //Grey;
    'FFA500' // orange;
  ];

  bool typeSelect = false;
  bool colorSelect = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(widget.isEdit ? "Edit Car" : "Add Car"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20, right: 190),
                child: Text(
                  "Select type of car : ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: CarType.values.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndexForType = index;
                            print(
                                "__________________________$selectedIndexForType");
                          });
                          typeSelect = true;
                        },
                        child: selectedIndexForType == index
                            ? Stack(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.green, width: 4),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'images/${typeImages[index]}.png',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const Positioned(
                                      right: 17,
                                      child: Icon(Icons.check_circle,
                                          color: Colors.green)),
                                ],
                              )
                            : Container(
                                width: 100,
                                height: 100,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'images/${typeImages[index]}.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20, right: 200),
                child: Text(
                  "Select color : ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: carColors.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndexForcolor = index;
                            });
                            colorSelect = true;
                          },
                          child: selectedIndexForcolor == index
                              ? Stack(
                                  children: [
                                    const Positioned(
                                        right: 11,
                                        child: Icon(Icons.check_circle,
                                            color: Colors.green)),
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
              Visibility(
                visible: typeSelect && colorSelect,
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 200, top: 20, bottom: 10),
                  child: Text(
                    "Select car image :",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
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
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            carImage = imageUrls[index];
                          });
                          saveSelectedImage(imageUrls[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CachedNetworkImage(
                            imageUrl: imageUrls[index],
                            placeholder: (context, url) => Center(
                              child: Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(255, 212, 212, 212),
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  color: Colors.white,
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: _carNameController,
                  validator: (value) =>
                      value!.isEmpty ? "Enter a car name!" : null,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    labelText: "Car Name",
                    labelStyle: TextStyle(
                      color: appBarColor,
                    ),
                    isDense: true,
                    prefixIcon: Icon(
                      Icons.car_crash,
                      color: appBarColor,
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    labelText: "Car Price",
                    labelStyle: TextStyle(
                      color: appBarColor,
                    ),
                    isDense: true,
                    prefixIcon: Icon(
                      Icons.attach_money_rounded,
                      color: appBarColor,
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    labelText: "Car Model",
                    labelStyle: TextStyle(
                      color: appBarColor,
                    ),
                    isDense: true,
                    prefixIcon: Icon(
                      Icons.date_range,
                      color: appBarColor,
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
                padding: const EdgeInsets.only(left: 0),
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
                      );

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
            ],
          ),
        ),
      ),
    );
  }
}
