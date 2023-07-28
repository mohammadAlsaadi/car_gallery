import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/models/carModel.dart';
import 'package:task1/screens/detailPage.dart';
import 'package:task1/Colors/colorTheme.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    }
  }

  void _sortCardsById() {
    setState(() {
      _carList.sort((a, b) => a.carDate.compareTo(b.carDate));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 120),
              child: Text("Car Show"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 85),
              child: TextButton(
                onPressed: _sortCardsById,
                child: const Text(
                  "Sort",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(
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
                      leading: Image.asset(carImage),
                      //title: Text(_carList[index].carName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_carList[index].carName,
                              style: TextStyle(color: backgroundColor)),
                          Text(
                            'Price : ${_carList[index].carPrice}',
                            style: TextStyle(color: backgroundColor),
                          ),
                          Text('date : ${_carList[index].carDate}',
                              style: TextStyle(color: backgroundColor)),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () => _removeCar(index),
                        icon: Icon(
                          Icons.delete,
                          color: button,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailPage()),
                        );
                      },
                    ),
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
