import 'package:flutter/material.dart';

import '../Colors/colorTheme.dart';
import '../models/carModel.dart';

class AddEditPage extends StatefulWidget {
  final bool isEdit;
  final CarInfo? car;

  AddEditPage({required this.isEdit, this.car});

  @override
  _AddEditPageState createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _carNameController;
  late TextEditingController _priceController;
  late TextEditingController _dateController;

  @override
  @override
  Widget build(BuildContext context) {
    if (widget.isEdit) {
      // Editing an existing car
      _carNameController = TextEditingController(text: widget.car!.carName);
      _priceController = TextEditingController(text: widget.car!.carPrice);
      _dateController = TextEditingController(text: widget.car!.carDate);
    } else {
      // Adding a new car
      _carNameController = TextEditingController();
      _priceController = TextEditingController();
      _dateController = TextEditingController();
    }
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
                    _priceController.text = value!;
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
                      String carPrice = _priceController.text;
                      String carDate = _dateController.text;

                      CarInfo newCar = CarInfo(
                        carName: carName,
                        carPrice: carPrice,
                        carDate: carDate,
                      );

                      if (widget.isEdit) {
                        // Editing an existing car
                        Navigator.pop(context, newCar);
                      } else {
                        // Adding a new car
                        Navigator.pop(context);
                      }

                      //  snackBar = SnackBar(
                      //   content: Text(widget.isEdit ? 'Car edited!' : 'Car added!'),
                      // );
                      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
            ],
          ),
        ),
      ),
    );
  }
}
