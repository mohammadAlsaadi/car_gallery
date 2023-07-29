import 'package:flutter/material.dart';
import 'package:task1/Colors/colorTheme.dart';
import 'package:task1/models/carModel.dart';

import 'editPage.dart';

class DetailPage extends StatefulWidget {
  CarInfo car;
  DetailPage({super.key, required this.car});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
//CarInfo car = CarInfo(car);
  // ColorsTheme color = new ColorsTheme();

  @override
  Widget build(BuildContext context) {
//________________________________________
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double labelText = MediaQuery.of(context).size.width - 300;
    final double fontSize = screenSize.width * 0.04;
    double imageWidth =
        screenWidth > 600 ? screenWidth * 0.6 : screenWidth * 0.8;
    final fontStyleApp =
        TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Text(
                widget.car.carName,
                style: TextStyle(fontSize: fontSize),
              ),
            )
          ],
        ),
      ),
      body: Container(
        color: backgroundColor,
        child: Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Image.asset(
                  "images/car.png",
                  width: imageWidth,
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              Row(
                children: [
                  SizedBox(
                    width: labelText,
                  ),
                  Text(
                    'price :    ${widget.car.carPrice}',
                    style: fontStyleApp,
                  )
                ],
              ),
              const SizedBox(
                height: 70,
              ),
              Row(
                children: [
                  SizedBox(
                    width: labelText,
                  ),
                  Text(
                    'Date :    ${widget.car.carDate}',
                    style: fontStyleApp,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
