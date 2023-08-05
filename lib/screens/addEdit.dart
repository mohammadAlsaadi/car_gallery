import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task1/utilis/constans.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

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
    String collectionId = 'ylm1c89';
    String apiUrl =
        'https://api.pexels.com/v1/collections/$collectionId/?page=1&per_page=10';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': apiKey},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
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
                padding: const EdgeInsets.only(right: 200, top: 30, bottom: 10),
                child: Text(
                  "Select car image :",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 120,
                child:
                    //  isLoading
                    //     ? Center(
                    //         child: CircularProgressIndicator(),
                    //       )
                    //     :
                    ListView.builder(
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
                        child: Image.network(imageUrls[index]),
                      ),
                    );
                  },
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
                    labelText: "Car Date",
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
                          carImage: img);

                      Navigator.pop(context, newCar);

                      // if (widget.isEdit) {
                      //   // Editing an existing car
                      // } else {
                      //   // Adding a new car
                      //   Navigator.pop(context);
                      // }

                      //  snackBar = SnackBar(
                      //   content: Text(widget.isEdit ? 'Car edited!' : 'Car added!'),
                      // );
                      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
