import 'package:flutter/material.dart';
import 'package:task1/Colors/colorTheme.dart';
import 'package:task1/models/carModel.dart';

class DetailPage extends StatelessWidget {
  final CarInfo car;
  const DetailPage({super.key, required this.car});

//CarInfo car = CarInfo(car);
  @override
  Widget build(BuildContext context) {
//________________________________________
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double labelText = MediaQuery.of(context).size.width - 300;
    final double fontSize = screenSize.width * 0.04;
    double imageWidth =
        screenWidth > 600 ? screenWidth * 0.6 : screenWidth * 0.8;
    // final fontStyleApp =
    //     TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold);
    final fontStyleApp2 = TextStyle(
        fontSize: fontSize, fontWeight: FontWeight.bold, color: button);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Text(
                car.carName,
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
              Padding(
                padding: const EdgeInsets.all(30),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: appBarColor),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100, bottom: 100),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: labelText,
                            ),
                            Text(
                              'price :    ${car.carPrice}',
                              style: fontStyleApp2,
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
                              'Date :    ${car.carDate}',
                              style: fontStyleApp2,
                            ),
                          ],
                        ),
                      ],
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
