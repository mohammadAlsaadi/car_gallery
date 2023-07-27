import 'package:flutter/material.dart';
import 'package:task1/Colors/colorTheme.dart';
import 'package:task1/models/carModel.dart';
import 'package:task1/screens/lableValue.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // CarInfo car = CarInfo();
  // ColorsTheme color = new ColorsTheme();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 50),
              child: Text(""),
            )
          ],
        ),
      ),
      body: Container(
        color: backgroundColor,
        child: Align(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Image.asset(carImage),
              ),
              const SizedBox(
                height: 70,
              ),
              Row(
                children: [
                  LabelValueWidget(
                    label: '',
                    value: '29,000.00 JD',
                  ),
                ],
              ),
              const SizedBox(
                height: 70,
              ),
              Row(
                children: [
                  LabelValueWidget(
                    label: 'Date :',
                    value: '2010',
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
