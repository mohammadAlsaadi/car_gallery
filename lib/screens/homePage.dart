// ignore_for_file: avoid_print, file_names

import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/models/carModel.dart';
import 'package:task1/screens/addEdit.dart';
import 'package:task1/screens/detailPage.dart';
import 'package:task1/ColorsAndFont/colorTheme.dart';
import 'package:task1/screens/getStarted.dart';
import 'package:task1/screens/profile.dart';
import 'package:task1/utilis/constans.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dio/dio.dart';

import '../ColorsAndFont/fontStyle.dart';
import '../models/userAuthModel.dart';
import '../service/currentUser.dart';

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

enum SortOption {
  date,
  name,
  price,
}

class _HomePageState extends State<HomePage> {
  //___________________

  void _handleLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const GetStarted(),
      ),
      (route) => false,
    );
  }

  List<CarInfo> _carList = [];
  bool _isLoading = true;
  bool _isLoadingCar = true;

  @override
  void initState() {
    super.initState();
    _loadCars(shardUserId);
    _loadUserData();
  }

  void _loadUser(String? userId) async {
    if (userId == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonUsers = prefs.getString('users') ?? '[]';
    List<dynamic> userData = jsonDecode(jsonUsers);
    List<UserAuth> users =
        userData.map((user) => UserAuth.fromJson(user)).toList();

    // Find the user with the current user ID and update the user information
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
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadUserData() async {
    if (widget.currentUserID != null) {
      // ignore: await_only_futures
      _loadUser(widget.currentUserID);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCarImage(String imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('carImageLoaded') == "") {
      setState(() {
        _isLoadingCar = true;
      });
    }
  }

  void _loadCars(String? userId) async {
    if (userId != null) {
      setState(() {
        _isLoading = true;
      });
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonCars = prefs.getString('cars_$userId') ?? '[]';
    List<dynamic> carData = jsonDecode(jsonCars);
    List<CarInfo> cars = carData.map((car) => CarInfo.fromJson(car)).toList();

    setState(() {
      _carList = cars;
      _isLoading = false;
    });
  }

  void _saveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonUsers = prefs.getString('users') ?? '[]';
    List<dynamic> userData = jsonDecode(jsonUsers);
    List<UserAuth> users =
        userData.map((user) => UserAuth.fromJson(user)).toList();

    // Find the user with the current user ID and update the user information
    int index = users.indexWhere((user) => user.uid == shardUserId);
    if (index != -1) {
      users[index].name = widget.userName ?? '';
      users[index].phoneNumber = widget.phone ?? '';
      String updatedUsersJson = jsonEncode(users);
      prefs.setString('users', updatedUsersJson);
    }
  }

  void _saveCars() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonCars = jsonEncode(_carList);
    prefs.setString('cars_${shardUserId}',
        jsonCars); // Use the current user ID to save their cars
  }

  void _removeCar(int index) {
    setState(() {
      _carList.removeAt(index);
    });
    _saveCars(); // Update the list stored in shared_preferences after removal
  }

  void _navigateToDetailPage(BuildContext context, CarInfo car) async {
    final updatedCar = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          car: car,
        ),
      ),
    );

    if (updatedCar != null && updatedCar is CarInfo) {
      // Find the index of the edited car and update the list
      int index = _carList.indexWhere((element) => element == car);
      if (index != -1) {
        setState(() {
          _carList[index] = updatedCar;
        });
        _saveCars(); // Save the updated list of cars to storage
      }
    }
  }
  // Default selected option

  SortOption? selectedOption = SortOption.date;

  void _sortCards() {
    if (selectedOption == SortOption.date) {
      setState(() {
        _carList.sort((a, b) => a.carDate.compareTo(b.carDate));
      });
    } else if (selectedOption == SortOption.name) {
      setState(() {
        _carList.sort((a, b) => a.carName.compareTo(b.carName));
      });
    } else if (selectedOption == SortOption.price) {
      setState(() {
        _carList.sort((a, b) => a.carPrice.compareTo(b.carPrice));
      });
    }
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
                          style: TextStyle(color: button, fontSize: 17),
                        ),
                      ),
                    ),
                    RadioListTile<SortOption>(
                      title: const Text(
                        'by Date',
                        style: TextStyle(color: button),
                      ),
                      value: SortOption.date,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                      activeColor: button,
                    ),
                    RadioListTile<SortOption>(
                      title: const Text(
                        'by Car Name',
                        style: TextStyle(color: button),
                      ),
                      value: SortOption.name,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                      activeColor: button,
                    ),
                    RadioListTile<SortOption>(
                      title: const Text(
                        'by Price',
                        style: TextStyle(color: button),
                      ),
                      value: SortOption.price,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                      activeColor: button,
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
                            style: TextStyle(color: button),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(white),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(button),
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
                                  left: 10, right: 10, top: 5, bottom: 5),
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
        _carList.add(newCar);
      });
      _saveCars();
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
        int index = _carList.indexWhere((element) => element == car);
        if (index != -1) {
          _carList[index] = updatedCar;
          _saveCars(); // Save the updated list of cars to storage
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width;
    double cardHeight = MediaQuery.of(context).size.height * 0.3;
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
            Padding(
              padding: EdgeInsets.only(),
              child: DrawerHeader(
                padding: EdgeInsets.all(15),
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
                            style: TextStyle(color: button),
                          ),
                          Text("${widget.phone}",
                              style: TextStyle(color: button)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Row(
                children: [
                  Icon(
                    Icons.person,
                    color: button,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text("My Profile", style: TextStyle(color: button)),
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
                  Icon(Icons.logout_outlined, color: button),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Logout", style: TextStyle(color: button)),
                ],
              ),
              onTap: () {
                _handleLogout(context);
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
              padding: EdgeInsets.only(left: 50),
              child: Text("Antique Jo", style: appBarFont),
            ),
            SizedBox(
              width: cardWidth * 0.17,
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
                color: button,
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
        padding: EdgeInsets.only(left: cardHeight * 0.1),
        child: ListView.builder(
          itemCount: _carList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: cardHeight,
                width: cardWidth,
                child: GestureDetector(
                  onTap: () => _navigateToDetailPage(context, _carList[index]),
                  child: Card(
                    color: backgroundColor,
                    child: Hero(
                      tag: 'carImage_${_carList[index].carImage}',
                      child: Container(
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
                          Container(
                            width: containerImageWidth,
                            height: containerImageHeight,
                            child: Stack(
                              children: [
                                FutureBuilder<void>(
                                  future:
                                      _loadCarImage(_carList[index].carImage),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<void> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: containerImageWidth,
                                          height: containerImageHeight,
                                          color: Colors.white,
                                        ),
                                      );
                                    } else {
                                      return Image.network(
                                        _carList[index].carImage,
                                        width: containerImageWidth,
                                        height: containerImageHeight,
                                        fit: BoxFit.cover,
                                      );
                                    }
                                  },
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
                                          Color.fromARGB(255, 71, 71, 71)
                                              .withAlpha(210),
                                          Color.fromARGB(31, 79, 79, 79)
                                              .withAlpha(210),
                                          Color.fromARGB(179, 88, 88, 88)
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
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            child: Image.asset(
                                                "images/${_carList[index].carType}.png"),
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
                                                  Text(_carList[index].carName,
                                                      style: nameOfCarFont),
                                                  Text(
                                                      '${_carList[index].carDate}',
                                                      style: modelOfCarFont),
                                                ],
                                              ),
                                            )),
                                        Positioned(
                                          right: containerImageWidth * 0.05,
                                          top: fogContainerHeight * 0.03,
                                          child: Text(
                                              '${_carList[index].carPrice} \$',
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
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Row(
                                          children: [
                                            Text("Details",
                                                style: detailButtonFont),
                                            const Icon(
                                              Icons.arrow_forward_ios,
                                              color: appBarColor,
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
                ),
              ),
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
            color: button,
          ),
        ),
      ),
    );
  }
}
