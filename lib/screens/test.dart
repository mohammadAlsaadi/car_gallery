// ignore_for_file: unnecessary_import, constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RadioGroupWidget extends StatefulWidget {
  const RadioGroupWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RadioGroupWidgetState createState() => _RadioGroupWidgetState();
}

enum RadioOptions { Option1, Option2, Option3 }

class _RadioGroupWidgetState extends State<RadioGroupWidget> {
  RadioOptions _selectedOption = RadioOptions.Option1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Option 1'),
          leading: Radio<RadioOptions>(
            value: RadioOptions.Option1,
            groupValue: _selectedOption,
            onChanged: (RadioOptions? value) {
              setState(() {
                _selectedOption = value!;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Option 2'),
          leading: Radio<RadioOptions>(
            value: RadioOptions.Option2,
            groupValue: _selectedOption,
            onChanged: (RadioOptions? value) {
              setState(() {
                _selectedOption = value!;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Option 3'),
          leading: Radio<RadioOptions>(
            value: RadioOptions.Option3,
            groupValue: _selectedOption,
            onChanged: (RadioOptions? value) {
              setState(() {
                _selectedOption = value!;
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Selected Option: $_selectedOption',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
