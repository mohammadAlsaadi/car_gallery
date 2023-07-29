import 'package:flutter/material.dart';
import 'package:task1/Colors/colorTheme.dart';
import 'package:task1/models/carModel.dart';

class EditPage extends StatefulWidget {
  CarInfo car;

  EditPage({required this.car});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _carNameController;
  late TextEditingController _priceController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _carNameController = TextEditingController(text: widget.car.carName);
    _priceController = TextEditingController(text: widget.car.carPrice);
    _dateController = TextEditingController(text: widget.car.carDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text('Edit Car Details'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: TextFormField(
                  controller: _carNameController,
                  validator: (value) =>
                      value!.isEmpty ? "Enter a car name!" : null,
                  decoration: InputDecoration(labelText: "Car Name"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: TextFormField(
                  controller: _priceController,
                  validator: (value) =>
                      value!.isEmpty ? "Enter the car price!" : null,
                  decoration: InputDecoration(labelText: "Car Price"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: TextFormField(
                  controller: _dateController,
                  validator: (value) => value!.isEmpty ? "Enter a date!" : null,
                  decoration: InputDecoration(labelText: "Car Date"),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(appBarColor),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 20))),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Update car data and pop the EditPage
                    CarInfo updatedCar = CarInfo(
                      carName: _carNameController.text,
                      carPrice: _priceController.text,
                      carDate: _dateController.text,
                    );
                    Navigator.pop(context, updatedCar);
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
