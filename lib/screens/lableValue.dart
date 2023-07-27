// ignore: file_names
import 'package:flutter/material.dart';

class LabelValueWidget extends StatelessWidget {
  final String label;
  final String value;

  const LabelValueWidget({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 70,
            ),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(width: 100),
            Text(
              value,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        )
      ],
    );
  }
}
