// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:task1/Colors/colorTheme.dart';
import 'package:task1/models/carModel.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _carNameController = TextEditingController();
  final TextEditingController _PriceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: appBarColor, title: const Text("Edit page ")),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    validator: (value) =>
                        value!.isEmpty ? "Enter a car name ! " : null,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      labelText: "name car",
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
                      labelText: "car price",
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
                      _PriceController.text = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    validator: (value) =>
                        value!.isEmpty ? "Enter an date ! " : null,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      labelText: " car date ",
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
                        String carPrice = _PriceController.text;
                        String carDate = _dateController.text;

                        CarInfo newCar = CarInfo(
                            carName: carName,
                            carPrice: carPrice,
                            carDate: carDate);

                        Navigator.pop(context, newCar);

                        // print(newCar);
                        const snackBar = SnackBar(
                          content: Text('Car added!'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: Text(
                        "Add car ",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                // Container(
                //   child: ListView.builder(
                //     itemCount: _cardList.length,
                //     itemBuilder: (context, index) {
                //       return Card(
                //         elevation: 4.0,
                //         child: ListTile(
                //           leading: Image.asset(carImage),
                //           title: Text(_cardList[index].carName),
                //           subtitle: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(_cardList[index].carPrice),
                //               Text(_cardList[index].carDate),
                //             ],
                //           ),
                //           trailing: IconButton(
                //             onPressed: () {
                //               Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) =>
                //                         const DetailPage()),
                //               );
                //             },
                //             icon: const Icon(Icons.arrow_forward_ios),
                //           ),
                //           onTap: () {
                //             // Handle card tap
                //             print('Card tapped!');
                //           },
                //         ),
                //       );
                //     },
                //   ),
                // )
              ],
            ),
          )),
    );
  }
}
