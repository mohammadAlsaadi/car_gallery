
                  
                    // leading: _isLoading
                    //     ? Shimmer.fromColors(
                    //         baseColor: Color.fromARGB(255, 24, 24, 24)!,
                    //         highlightColor: Colors.grey[100]!,
                    //         child: Container(
                    //           width: 90,
                    //           height: 110,
                    //           color: const Color.fromARGB(255, 100, 100, 100),
                    //         ),
                    //       )
                    //     : Stack(
                    //         children: [
                    //           Image.network(
                    //             _carList[index].carImage,
                    //             width: 90,
                    //             height: 110,
                    //             loadingBuilder: (BuildContext context,
                    //                 Widget child,
                    //                 ImageChunkEvent? loadingProgress) {
                    //               if (loadingProgress == null) {
                    //                 return child;
                    //               } else {
                    //                 return Shimmer.fromColors(
                    //                   baseColor: appBarColor,
                    //                   highlightColor:
                    //                       Color.fromARGB(255, 117, 117, 117),
                    //                   child: Container(
                    //                     width: 90,
                    //                     height: 110,
                    //                     color: const Color.fromARGB(
                    //                         255, 84, 84, 84),
                    //                   ),
                    //                 );
                    //               }
                    //             },
                    //           ),
                    //         ],
                    //       ),
                    // //title: Text(_carList[index].carName),
                    // subtitle: Row(
                    //   children: [
                    //     Stack(
                    //       children: [
                    //         Positioned(
                    //           right: 5,
                    //           top: 10,
                    //           child: Container(
                    //             width: 35,
                    //             height: 40,
                    //             child: Image.asset(
                    //                 "images/${_carList[index].carType}.png"),
                    //           ),
                    //         ),
                    //         Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: Text(_carList[index].carName,
                    //                   style: const TextStyle(
                    //                       color: backgroundColor)),
                    //             ),
                    //             Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: Text(
                    //                 'Model : ${_carList[index].carDate}',
                    //                 style:
                    //                     const TextStyle(color: backgroundColor),
                    //               ),
                    //             ),
                    //             Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: Text(
                    //                   'Price : ${_carList[index].carPrice}',
                    //                   style: const TextStyle(
                    //                       color: backgroundColor)),
                    //             ),
                    //           ],
                    //         ),
                    //         Padding(
                    //           padding:
                    //               const EdgeInsets.only(top: 70, left: 130),
                    //           child: Stack(
                    //             children: [
                    //               Padding(
                    //                 padding:
                    //                     const EdgeInsets.only(left: 20, top: 5),
                    //                 child: TextButton(
                    //                     onPressed: () => _navigateToEditPage1(
                    //                         context, _carList[index]),
                    //                     child: const Text(
                    //                       "Edit",
                    //                       style: TextStyle(
                    //                           fontSize: 14,
                    //                           fontWeight: FontWeight.bold,
                    //                           color: button),
                    //                       selectionColor: button,
                    //                     )),
                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.only(left: 70),
                    //                 child: IconButton(
                    //                   onPressed: () => _removeCar(index),
                    //                   icon: const Icon(
                    //                     Icons.delete,
                    //                     color: button,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    // onTap: () =>
                    //     _navigateToDetailPage(context, _carList[index])









                    //     Padding(
                    //                         padding: const EdgeInsets.only(
                    //                             top: 70, left: 130),
                    //                         child: Stack(
                    //                           children: [
                    //                             Padding(
                    //                               padding:
                    //                                   const EdgeInsets.only(
                    //                                       left: 20, top: 5),
                    //                               child: TextButton(
                    //                                   onPressed: () =>
                    //                                       _navigateToEditPage1(
                    //                                           context,
                    //                                           _carList[index]),
                    //                                   child: const Text(
                    //                                     "Edit",
                    //                                     style: TextStyle(
                    //                                         fontSize: 14,
                    //                                         fontWeight:
                    //                                             FontWeight.bold,
                    //                                         color: button),
                    //                                     selectionColor: button,
                    //                                   )),
                    //                             ),
                    //                             Padding(
                    //                               padding:
                    //                                   const EdgeInsets.only(
                    //                                       left: 70),
                    //                               child: IconButton(
                    //                                 onPressed: () =>
                    //                                     _removeCar(index),
                    //                                 icon: const Icon(
                    //                                   Icons.delete,
                    //                                   color: button,
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),

                      // loadingBuilder: (BuildContext context,
                      //               Widget child,
                      //               ImageChunkEvent? loadingProgress) {
                      //             if (loadingProgress == null) {
                      //               return child;
                      //             } else {
                      //               return Padding(
                      //                 padding: const EdgeInsets.only(left: 5),
                      //                 child: Shimmer.fromColors(
                      //                   baseColor: skeltonColor,
                      //                   highlightColor:
                      //                       Color.fromARGB(255, 117, 117, 117),
                      //                   child: Container(
                      //                     width: cardWidth - 67,
                      //                     height: cardHeight,
                      //                     color: const Color.fromARGB(
                      //                         255, 84, 84, 84),
                      //                   ),
                      //                 ),
                      //               );
                      //             }
                      //           },




                      // only(
                      //   top: pageHeight * 0.07,
                      //   left: pageWidth * 0.04,
                      //   right: pageWidth * 0.04)