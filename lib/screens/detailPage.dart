// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:task1/ColorsAndFont/colorTheme.dart';
import 'package:task1/ColorsAndFont/fontStyle.dart';
import 'package:task1/models/carModel.dart';
import 'package:shimmer/shimmer.dart';

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: white,
            child: Hero(
              tag: 'carImage_${widget.car.carImage}',
              child: Stack(
                children: [
                  GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (details.primaryDelta! > 15) {
                        Navigator.pop(context);
                      }
                    },
                    child: Positioned(
                      child: SizedBox(
                        width: pageWidth,
                        height: pageHeight * 0.4,
                        child: CachedNetworkImage(
                          imageUrl: widget.car.carImage,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: pageWidth,
                              height: pageHeight * 0.4,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: pageHeight * 0.3,
                    ),
                    child: Container(
                      width: pageWidth,
                      height: pageHeight * 0.65,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                        color: white,
                      ),
                      child: Stack(
                        children: [
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: widget.car.carName,
                                      style: subTypeOfCarFont,
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: '   ${widget.car.carDate}',
                                            style: modelOfCarDetailFont),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: pageHeight * 0.04,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "The Renaul Arkana is a compact \n (C-segment) crossover",
                                        style: infoOfCarDetailFont,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: pageHeight * 0.03),
                                        child: Row(
                                          children: [
                                            Text(
                                              "GVM :",
                                              style: carInformationLable,
                                            ),
                                            SizedBox(
                                              width: pageWidth * 0.1,
                                            ),
                                            Text(
                                              "5 Tons",
                                              style: carInformationValue,
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: pageHeight * 0.03),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Number of previous owner :",
                                              style: carInformationLable,
                                            ),
                                            SizedBox(
                                              width: pageWidth * 0.1,
                                            ),
                                            Text(
                                              "3",
                                              style: carInformationValue,
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: pageHeight * 0.03),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Odometer :",
                                              style: carInformationLable,
                                            ),
                                            SizedBox(
                                              width: pageWidth * 0.1,
                                            ),
                                            Text(
                                              "52,315 miles",
                                              style: carInformationValue,
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: pageHeight * 0.03),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Seating :",
                                              style: carInformationLable,
                                            ),
                                            SizedBox(
                                              width: pageWidth * 0.1,
                                            ),
                                            Text(
                                              "5 seats",
                                              style: carInformationValue,
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: pageHeight * 0.03),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Drivetain :",
                                              style: carInformationLable,
                                            ),
                                            SizedBox(
                                              width: pageWidth * 0.1,
                                            ),
                                            Text(
                                              "Four wheel drive",
                                              style: carInformationValue,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                top: pageHeight * 0.04,
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
                        ],
                      ),
                    ),
                  ),

                  // Positioned(
                  //   top: pageHeight * 0.21,
                  //   left: pageWidth * 0.28,
                  //   child: Text(
                  //     widget.car.carDate,
                  //     style: modelOfCarDetailFont,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
