// ignore_for_file: avoid_print, file_names, depend_on_referenced_packages, must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/models/carModel.dart';
import 'package:task1/screens/addEdit.dart';
import 'package:task1/screens/detailPage.dart';
import 'package:task1/ColorsAndFont/colorTheme.dart';
import 'package:task1/screens/profile.dart';
import 'package:task1/utilis/constans.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../ColorsAndFont/fontStyle.dart';
import '../models/userAuthModel.dart';
import '../service/currentUser.dart';
import '../service/homePageFunctionality.dart';

class HomePage extends StatefulWidget {
  final String? currentUserID;
  String? userName;
  String? phone;
  CarInfo? car;
  HomePage(
      {super.key, this.currentUserID, this.userName, this.phone, this.car});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadUserData2();
  }

  Future<void> _loadCarData() async {
    if (shardUserId != null) {
      _loadUser(shardUserId);
      await _loadCars(shardUserId);
      setState(() {
        isLoadingCarData = false;
      });
    } else {
      setState(() {
        isLoadingCarData = true;
      });
    }
  }

  void _loadUser(String? userId) async {
    if (userId == null) {
      setState(() {
        isLoadingUserData = true;
      });
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonUsers = prefs.getString('users') ?? '[]';
    List<dynamic> userData = jsonDecode(jsonUsers);
    List<UserAuth> users =
        userData.map((user) => UserAuth.fromJson(user)).toList();

    UserAuth? currentUser;
    for (var user in users) {
      if (user.uid == userId) {
        currentUser = user;
        break;
      }
    }

    if (currentUser != null) {
      setState(() {
        widget.userName = currentUser?.name;
        widget.phone = currentUser?.phoneNumber;
        isLoadingUserData = false;
      });
    } else {
      setState(() {
        isLoadingUserData = true;
      });
    }
  }

  void _loadUserData2() async {
    if (widget.currentUserID != null) {
      _loadUser(widget.currentUserID);
    } else {
      setState(() {
        isLoadingUserData = false;
      });
    }
  }

  Future<void> _loadCars(String? userId) async {
    if (userId == null) {
      setState(() {
        isLoadingCarData = false;
      });
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonCars = prefs.getString('cars_$userId') ?? '[]';
    List<dynamic> carData = jsonDecode(jsonCars);
    List<CarInfo> cars = carData.map((car) => CarInfo.fromJson(car)).toList();

    setState(() {
      carList = cars;
      isLoadingCarData = false;
    });
  }

  void _saveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonUsers = prefs.getString('users') ?? '[]';
    List<dynamic> userData = jsonDecode(jsonUsers);
    List<UserAuth> users =
        userData.map((user) => UserAuth.fromJson(user)).toList();

    int index = users.indexWhere((user) => user.uid == shardUserId);
    if (index != -1) {
      users[index].name = widget.userName ?? '';
      users[index].phoneNumber = widget.phone ?? '';
      String updatedUsersJson = jsonEncode(users);
      prefs.setString('users', updatedUsersJson);
    }
  }

  void _removeCar(int index) {
    setState(() {
      carList.removeAt(index);
    });
    SharedFunction.saveCars();
  }

  void _navigateToDetailPage(BuildContext context, CarInfo car) async {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return DetailPage(car: car);
      },
      transitionDuration: const Duration(milliseconds: 850),
    ));
  }

  SortOption? selectedOption = SortOption.date;

  void _sortCards() {
    if (selectedOption == SortOption.date) {
      setState(() {
        carList.sort((a, b) => a.carDate.compareTo(b.carDate));
      });
    } else if (selectedOption == SortOption.name) {
      setState(() {
        carList.sort((a, b) => a.carName.compareTo(b.carName));
      });
    } else if (selectedOption == SortOption.price) {
      setState(() {
        carList.sort((a, b) => a.carPrice.compareTo(b.carPrice));
      });
    }
  }

  void _showCardOptionsDialog(BuildContext context, CarInfo car, int index) {
    showModalBottomSheet(
      backgroundColor: backgroundColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20), bottom: Radius.circular(30)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            color: white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(7)),
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        _navigateToEditPage1(context, car);
                      },
                      title: Center(
                        child: Text("Edit", style: cardOption),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: backgroundColor,
                  height: 10,
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _removeCar(index);
                  },
                  title: Center(
                    child: Text("Delete", style: cardOption),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //__________________++++++++++++++___________________
  void _showSortDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: appBarColor,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          'Choose One',
                          style: TextStyle(color: buttonWhite, fontSize: 17),
                        ),
                      ),
                    ),
                    RadioListTile<SortOption>(
                      title: const Text(
                        'by Date',
                        style: TextStyle(color: buttonWhite),
                      ),
                      value: SortOption.date,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                      activeColor: buttonWhite,
                    ),
                    RadioListTile<SortOption>(
                      title: const Text(
                        'by Car Name',
                        style: TextStyle(color: buttonWhite),
                      ),
                      value: SortOption.name,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                      activeColor: buttonWhite,
                    ),
                    RadioListTile<SortOption>(
                      title: const Text(
                        'by Price',
                        style: TextStyle(color: buttonWhite),
                      ),
                      value: SortOption.price,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                      activeColor: buttonWhite,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: buttonWhite),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(white),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(buttonWhite),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                            onPressed: selectedOption != null
                                ? () {
                                    Navigator.of(context).pop();
                                    _sortCards();
                                  }
                                : null,
                            child: const Padding(
                              padding: EdgeInsets.only(
                                  left: 0, right: 10, top: 5, bottom: 5),
                              child: Text(
                                "Sort",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: appBarColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ));
      },
    );
  }

  void _navigateToAddEditCard() async {
    final newCar = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddEditPage(isEdit: false, currentUserID: shardUserId),
      ),
    );

    if (newCar != null && newCar is CarInfo) {
      setState(() {
        carList.add(newCar);
      });
      SharedFunction.saveCars();
      _saveUser(); // Save the user information when adding a new car
    }
  }

  void _navigateToEditPage1(BuildContext context, CarInfo car) async {
    final updatedCar = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddEditPage(isEdit: true, car: car, currentUserID: shardUserId),
      ),
    );

    if (updatedCar != null && updatedCar is CarInfo) {
      // Update the car in the list
      setState(() {
        int index = carList.indexWhere((element) => element == car);
        if (index != -1) {
          carList[index] = updatedCar;
          SharedFunction.saveCars(); // Save the updated list of cars to storage
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.97;
    double cardHeight = MediaQuery.of(context).size.height * 0.26;
    // final currentUser = Provider.of<CurrentUser>(context);
    double containerImageWidth = cardWidth - 70.5;

    double containerImageHeight = cardHeight - 11;
    double fogContainerHeight = containerImageHeight * 0.4;

    return Scaffold(
      // bottomSheet: Text(
      //   'Current User: ${widget.currentUserID ?? "Not logged in"}',
      //   style: const TextStyle(fontSize: 18),
      // ),
      drawer: Drawer(
        // shadowColor: appBarColor,
        // backgroundColor: appBarColor,

        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment(0, -2),
                end: Alignment(0, 0.5),
                colors: [
                  Color(0xff4a6741),
                  Color(0xff3f5a36),
                  Color(0xff374f2f),
                  Color(0xff304529),
                  Color(0xff22311d),
                ]),
          ),
          child: ListView(children: [
            DrawerHeader(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      "images/moalsaadi.jpg",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, left: 20),
                    child: Column(
                      children: [
                        Text(
                          "${widget.userName}",
                          style: const TextStyle(color: buttonWhite),
                        ),
                        Text("${widget.phone}",
                            style: const TextStyle(color: buttonWhite)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(
                    Icons.person,
                    color: buttonWhite,
                  ),
                  Text("My Profile", style: TextStyle(color: buttonWhite)),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Profile(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.logout_outlined, color: buttonWhite),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Logout", style: TextStyle(color: buttonWhite)),
                ],
              ),
              onTap: () {
                SharedFunction.handleLogout(context);
                CurrentUser currentUser = CurrentUser();
                currentUser.logout();
              },
            )
          ]),
        ),
      ),
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: cardWidth * 0.17),
              child: Text("Antique Jo", style: appBarFont),
            ),
            SizedBox(
              width: cardWidth * 0.12,
            ),

            FloatingActionButton(
              heroTag: "button1",
              elevation: 0,
              backgroundColor: appBarColor,
              onPressed: () {
                _showSortDialog();
              },
              child: const Icon(
                Icons.sort,
                color: buttonWhite,
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 85),
            //   child: TextButton(
            //     onPressed: _sortCardsByPrice,
            //     child: const Text(
            //       "Sort",
            //       style: TextStyle(color: button, fontSize: 15),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 28),
        child: FutureBuilder(
          future: _loadCarData(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: carList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: cardHeight,
                    width: cardWidth,
                    child: GestureDetector(
                      onLongPress: () => _showCardOptionsDialog(
                          context, carList[index], index),
                      onTap: () =>
                          _navigateToDetailPage(context, carList[index]),
                      child: Card(
                        color: backgroundColor,
                        child: Stack(children: [
                          // TextButton(
                          //     onPressed: () => _navigateToEditPage1(
                          //         context, _carList[index]),
                          //     child: const Text(
                          //       "Edit",
                          //       style: TextStyle(
                          //           fontSize: 14,
                          //           fontWeight: FontWeight.bold,
                          //           color: button),
                          //       selectionColor: button,
                          //     )),
                          SizedBox(
                            width: containerImageWidth,
                            height: containerImageHeight,
                            child: Stack(
                              children: [
                                Hero(
                                  tag: 'carImage_${carList[index].carImage}',
                                  child: CachedNetworkImage(
                                    imageUrl: carList[index].carImage,
                                    width: containerImageWidth,
                                    height: containerImageHeight,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      baseColor: const Color.fromARGB(
                                          255, 177, 177, 177),
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: containerImageWidth,
                                        height: containerImageHeight,
                                        color: Colors.white,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: containerImageWidth,
                                    height: fogContainerHeight,
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: <Color>[
                                          const Color.fromARGB(255, 71, 71, 71)
                                              .withAlpha(210),
                                          const Color.fromARGB(31, 79, 79, 79)
                                              .withAlpha(210),
                                          const Color.fromARGB(179, 88, 88, 88)
                                              .withAlpha(210),
                                        ],
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          right: containerImageWidth * 0.85,
                                          top: fogContainerHeight * 0.03,
                                          bottom: 50,
                                          child: SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Image.asset(
                                                "images/${carList[index].carType}.png"),
                                          ),
                                        ),
                                        Positioned(
                                            right: containerImageWidth * 0.55,
                                            top: fogContainerHeight * 0.07,
                                            child: Align(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(carList[index].carName,
                                                      style: nameOfCarFont),
                                                  Text(carList[index].carDate,
                                                      style: modelOfCarFont),
                                                ],
                                              ),
                                            )),
                                        Positioned(
                                          right: containerImageWidth * 0.05,
                                          top: fogContainerHeight * 0.03,
                                          child: Text(
                                              '${carList[index].carPrice} \$',
                                              style: priceOfCarFont),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 0.4, right: 0.5),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                          ),
                                          color: white),
                                      width: 85,
                                      height: 30,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: cardWidth * 0.02),
                                              child: Text("Details",
                                                  style: detailButtonFont),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: cardWidth * 0.02),
                                              child: const Icon(
                                                Icons.arrow_forward_ios,
                                                color: appBarColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: CircleAvatar(
        maxRadius: Checkbox.width + 11,
        backgroundColor: backgroundColor,
        child: FloatingActionButton(
          elevation: 30,
          hoverColor: backgroundColor,
          heroTag: "button2",
          backgroundColor: appBarColor,
          onPressed: _navigateToAddEditCard,
          child: const Icon(
            Icons.add,
            color: buttonWhite,
          ),
        ),
      ),
    );
  }
}
