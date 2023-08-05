// ignore_for_file: avoid_print, file_names

import 'dart:convert';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/models/carModel.dart';
import 'package:task1/screens/addEdit.dart';
import 'package:task1/screens/auth/signup_page.dart';
import 'package:task1/screens/detailPage.dart';
import 'package:task1/Colors/colorTheme.dart';
import 'package:task1/screens/getStarted.dart';
import 'package:task1/screens/profile.dart';
import 'package:task1/utilis/constans.dart';

import '../models/userAuthModel.dart';
import '../service/currentUser.dart';

class HomePage extends StatefulWidget {
  final String? currentUserID;
  final String? userName;
  final String? phone;
  const HomePage({super.key, this.currentUserID, this.userName, this.phone});

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

  //_______________________
  // void updateCarInfo(int index, CarInfo updatedCar) {
  //   setState(() {
  //     _carList[index] = updatedCar;
  //   });
  // }

  List<CarInfo> _carList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCars(shardUserId);
    _loadUser(shardUserId);
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
  }

  void _loadCars(String? userId) async {
    if (userId == null) {
      setState(() {
        _isLoading = false;
      });
      return;
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
                          padding: const EdgeInsets.all(11.0),
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
            AddEditPage(isEdit: false, currentUserID: widget.currentUserID),
      ),
    );

    if (newCar != null && newCar is CarInfo) {
      setState(() {
        _carList.add(newCar);
        print(newCar);
      });
      _saveCars();
    }
  }

  void _navigateToEditPage1(BuildContext context, CarInfo car) async {
    final updatedCar = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditPage(isEdit: true, car: car),
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
    // final currentUser = Provider.of<CurrentUser>(context);

    return Scaffold(
      bottomSheet: Text(
        'Current User: {_loadUser(widget.currentUserID) ?? "Not logged in"}',
        style: const TextStyle(fontSize: 18),
      ),
      drawer: Drawer(
        shadowColor: appBarColor,
        backgroundColor: appBarColor,
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 60),
              child: Text("Car Show"),
            ),
            const SizedBox(
              width: 100,
            ),

            FloatingActionButton(
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
      body: ListView.builder(
        itemCount: _carList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: appBarColor,
              elevation: 15,
              child: ListTile(
                  leading: Image.asset("images/car.png"),
                  //title: Text(_carList[index].carName),
                  subtitle: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_carList[index].carName,
                              style: const TextStyle(color: backgroundColor)),
                          Text(
                            'Price : ${_carList[index].carPrice}',
                            style: const TextStyle(color: backgroundColor),
                          ),
                          Text('date : ${_carList[index].carDate}',
                              style: const TextStyle(color: backgroundColor)),
                        ],
                      ),
                    ],
                  ),
                  trailing: Stack(
                    children: [
                      IconButton(
                        onPressed: () =>
                            _navigateToEditPage1(context, _carList[index]),
                        icon: const Icon(
                          Icons.edit,
                          color: button,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: IconButton(
                          onPressed: () => _removeCar(index),
                          icon: const Icon(
                            Icons.delete,
                            color: button,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () => _navigateToDetailPage(context, _carList[index])),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appBarColor,
        onPressed: _navigateToAddEditCard,
        child: const Icon(
          Icons.add,
          color: button,
        ),
      ),
    );
  }
}
