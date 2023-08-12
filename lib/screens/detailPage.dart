// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:task1/ColorsAndFont/colorTheme.dart';
import 'package:task1/ColorsAndFont/fontStyle.dart';
import 'package:task1/models/carModel.dart';

class DetailPage extends StatefulWidget {
  final CarInfo car;
  const DetailPage({super.key, required this.car});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    double pageWidth = MediaQuery.of(context).size.width;
    double pageHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: backgroundColor,
      //   title: Padding(
      //     padding: EdgeInsets.only(left: cardWidth * 0.25),
      //     child: Text(
      //       widget.car.carName,
      //       style: appBarFont,
      //     ),
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Container(
          color: backgroundColor,
          child: Column(
            children: [
              Hero(
                tag: 'carImage_${widget.car.carImage}',
                createRectTween: (Rect? begin, Rect? end) {
                  return MaterialRectCenterArcTween(begin: begin, end: end);
                },
                child: Material(
                  child: Stack(
                    children: [
                      Image.network(widget.car.carImage),
                      Positioned(
                        top: pageHeight * 0.35,
                        left: pageWidth * 0.09,
                        right: pageWidth * 0.09,
                        child: SizedBox(
                          width: pageWidth * 0.22,
                          height: pageHeight * 0.06,
                          child: Image.asset(
                            "images/${widget.car.carType}.png",
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                            top: pageHeight * 0.3,
                            // left: pageWidth * 0.04,
                            // right: pageWidth * 0.04
                          ),
                          child: Stack(
                            children: [
                              Container(
                                width: pageWidth,
                                height: pageHeight * 0.65,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      topRight: Radius.circular(40)),
                                  color: white,
                                ),
                              ),
                              Positioned(
                                top: pageHeight * 0.14,
                                left: pageWidth * 0.15,
                                child: Text(
                                  widget.car.carType,
                                  style: typeOfCarFont,
                                ),
                              ),
                              Positioned(
                                top: pageHeight * 0.06,
                                left: pageWidth * 0.7,
                                child: Text(
                                  "${widget.car.carPrice} \$",
                                  style: priceOfCarFont,
                                ),
                              ),
                              Positioned(
                                  top: pageHeight * 0.18,
                                  left: pageWidth * 0.15,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: widget.car.carName,
                                          style: subTypeOfCarFont,
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    '   ${widget.car.carDate}',
                                                style: modelOfCarDetailFont),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: pageHeight * 0.04,
                                      ),
                                      Text(
                                        "The Renaul Arkana is a compact \n (C-segment) crossover",
                                        style: infoOfCarDetailFont,
                                      )
                                    ],
                                  )),
                              // Positioned(
                              //   top: pageHeight * 0.21,
                              //   left: pageWidth * 0.28,
                              //   child: Text(
                              //     widget.car.carDate,
                              //     style: modelOfCarDetailFont,
                              //   ),
                              // ),
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                            top: pageHeight * 0.35,
                            left: pageWidth * 0.09,
                            right: pageWidth * 0.09),
                        child: SizedBox(
                          width: pageWidth * 0.22,
                          height: pageHeight * 0.06,
                          child: Image.asset(
                            "images/${widget.car.carType}.png",
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: pageHeight * 0.8,
                            left: pageWidth * 0.1,
                            right: pageWidth * 0.05),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(appBarColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Text(
                              "Back to Home Page",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ), // Display the car image
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Row(
//                           children: [
//                             SizedBox(width: 20),
//                             Text(
//                               'Price: ${widget.car.carPrice}',
//                               style: priceOfCarFont,
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 70),
//                         Row(
//                           children: [
//                             SizedBox(width: 20),
//                             Text(
//                               'Date: ${widget.car.carDate}',
//                               style: modelOfCarFont,
//                             ),
//                           ],
//                         ),
