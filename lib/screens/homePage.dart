import 'dart:convert';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/models/carModel.dart';
import 'package:task1/screens/auth/login_page.dart';
import 'package:task1/screens/auth/signup_page.dart';
import 'package:task1/screens/detailPage.dart';
import 'package:task1/Colors/colorTheme.dart';
import 'package:task1/screens/getStarted.dart';
import 'package:task1/screens/profile.dart';

import 'editPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }

  //_____________________nav Edit
  void _navigateToEditPage(BuildContext context, CarInfo car) async {
    final updatedCar = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPage(car: car),
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

  //_______________________
  void updateCarInfo(int index, CarInfo updatedCar) {
    setState(() {
      _carList[index] = updatedCar;
    });
  }

  List<CarInfo> _carList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  void _loadCars() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonCars = prefs.getString('cars') ?? '[]';
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
    prefs.setString('cars', jsonCars);
  }

  void _removeCar(int index) {
    setState(() {
      _carList.removeAt(index);
    });
    _saveCars(); // Update the list stored in shared_preferences after removal
  }

  void _navigateToAddCard() async {
    final newCard = await Navigator.pushNamed(context, '/AddPage');

    if (newCard != null && newCard is CarInfo) {
      setState(() {
        _carList.add(newCard);
      });
      _saveCars();
      // print(_carList);
    }
  }

  void _sortCardsByPrice() {
    setState(() {
      _carList.sort((a, b) => a.carDate.compareTo(b.carDate));
    });
  }

  void _sortCardsByLetters() {
    setState(() {
      _carList.sort((a, b) => a.carDate.compareTo(b.carDate));
    });
  }

  void _sortCardsByDate() {
    setState(() {
      _carList.sort((a, b) => a.carDate.compareTo(b.carDate));
    });
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

  SortOption? selectedOption;

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
  Future<void> _showSortDialog(BuildContext context) async {
    SortOption? newSelectedOption = await showDialog<SortOption>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appBarColor,
          title: Padding(
            padding: const EdgeInsets.only(
                left: 10, top: 10, right: 150, bottom: 50),
            child: Center(
              child: Text(
                'Choose One',
                style: TextStyle(color: button),
              ),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 50),
            child: Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0), color: button),
              child: Padding(
                padding: const EdgeInsets.only(left: 50),
                child: DropdownButton<SortOption>(
                  underline: SizedBox.shrink(),
                  iconEnabledColor: appBarColor,
                  iconDisabledColor: appBarColor,
                  dropdownColor: button,
                  focusColor: backgroundColor,
                  onChanged: (SortOption? newValue) {
                    setState(() {
                      selectedOption = newValue;
                    });
                  },
                  value: selectedOption,
                  items: [
                    DropdownMenuItem(
                      value: SortOption.date,
                      child: Text(
                        'by Date',
                        style: TextStyle(color: appBarColor),
                      ),
                    ),
                    DropdownMenuItem(
                      value: SortOption.name,
                      child: Text(
                        'by Car Name',
                        style: TextStyle(color: appBarColor),
                      ),
                    ),
                    DropdownMenuItem(
                      value: SortOption.price,
                      child: Text(
                        'by Price',
                        style: TextStyle(color: appBarColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: button),
              ),
            ),
            TextButton(
              onPressed: () {
                _sortCards();
                Navigator.pop(context);
              },
              child: Container(
                child: Text(
                  'Sort',
                  style: TextStyle(color: button),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (newSelectedOption != null) {
      selectedOption = newSelectedOption;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: appBarColor,
        child: ListView(children: [
          const Padding(
            padding: EdgeInsets.only(),
            child: DrawerHeader(
              padding: EdgeInsets.all(15),
              child:
                  Text("More option", style: TextStyle(color: backgroundColor)),
            ),
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(
                  Icons.person,
                  color: backgroundColor,
                ),
                SizedBox(
                  width: 20,
                ),
                Text("Profile", style: TextStyle(color: backgroundColor)),
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
                Icon(Icons.settings, color: backgroundColor),
                SizedBox(
                  width: 20,
                ),
                Text("Setting", style: TextStyle(color: backgroundColor)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUp(),
                ),
              );
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.logout_outlined, color: backgroundColor),
                SizedBox(
                  width: 20,
                ),
                Text("Logout", style: TextStyle(color: backgroundColor)),
              ],
            ),
            onTap: () {
              _handleLogout(context);
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
            SizedBox(
              width: 100,
            ),

            FloatingActionButton(
              elevation: 0,
              backgroundColor: appBarColor,
              onPressed: () {
                _showSortDialog(context);
              },
              child: Icon(
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
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
                                    style: const TextStyle(
                                        color: backgroundColor)),
                                Text(
                                  'Price : ${_carList[index].carPrice}',
                                  style:
                                      const TextStyle(color: backgroundColor),
                                ),
                                Text('date : ${_carList[index].carDate}',
                                    style: const TextStyle(
                                        color: backgroundColor)),
                              ],
                            ),
                          ],
                        ),
                        trailing: Stack(
                          children: [
                            IconButton(
                              onPressed: () {
                                _navigateToEditPage(context, _carList[index]);
                              },
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
                        onTap: () =>
                            _navigateToDetailPage(context, _carList[index])),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appBarColor,
        onPressed: _navigateToAddCard,
        child: const Icon(
          Icons.add,
          color: button,
        ),
      ),
    );
  }
}
