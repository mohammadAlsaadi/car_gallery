// ignore_for_file: file_names
// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:task1/Colors/colorTheme.dart';
// import 'package:task1/models/carModel.dart';

// class EditPage extends StatefulWidget {
//   final CarInfo car;

//   const EditPage({super.key, required this.car});

//   @override
//   // ignore: library_private_types_in_public_api
//   _EditPageState createState() => _EditPageState();
// }

// class _EditPageState extends State<EditPage> {
//   final _formKey = GlobalKey<FormState>();

//   late TextEditingController _carNameController;
//   late TextEditingController _priceController;
//   late TextEditingController _dateController;

//   @override
//   void initState() {
//     super.initState();
//     _carNameController = TextEditingController(text: widget.car.carName);
//     _priceController = TextEditingController(text: widget.car.carPrice);
//     _dateController = TextEditingController(text: widget.car.carDate);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: appBarColor,
//         title: const Text('Edit Car Details'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(
//                 height: 100,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(22),
//                 child: TextFormField(
//                   controller: _carNameController,
//                   validator: (value) =>
//                       value!.isEmpty ? "Enter a car name!" : null,
//                   decoration: const InputDecoration(labelText: "Car Name"),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(22),
//                 child: TextFormField(
//                   controller: _priceController,
//                   validator: (value) =>
//                       value!.isEmpty ? "Enter the car price!" : null,
//                   decoration: const InputDecoration(labelText: "Car Price"),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(22),
//                 child: TextFormField(
//                   controller: _dateController,
//                   validator: (value) => value!.isEmpty ? "Enter a date!" : null,
//                   decoration: const InputDecoration(labelText: "Car Date"),
//                 ),
//               ),
//               ElevatedButton(
//                 style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(appBarColor),
//                     textStyle: MaterialStateProperty.all(
//                         const TextStyle(fontSize: 20))),
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     // Update car data and pop the EditPage
//                     CarInfo updatedCar = CarInfo(
//                       carName: _carNameController.text,
//                       carPrice: _priceController.text,
//                       carDate: _dateController.text,
//                     );
//                     Navigator.pop(context, updatedCar);
//                   }
//                 },
//                 child: const Text(
//                   'Save',
//                   style: TextStyle(color: backgroundColor),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
