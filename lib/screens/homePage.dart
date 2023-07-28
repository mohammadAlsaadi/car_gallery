import 'package:flutter/material.dart';
import 'package:task1/models/carModel.dart';
import 'package:task1/screens/detailPage.dart';
import 'package:task1/Colors/colorTheme.dart';

class HomePage extends StatefulWidget {
  final List<CarInfo> cardList = [];

  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _navigateToAddCard() async {
    final newCard = await Navigator.pushNamed(context, '/AddPage');

    if (newCard != null && newCard is CarInfo) {
      setState(() {
        widget.cardList.add(newCard);
        print(widget.cardList);
      });
    }
  }

  // CarInfo car = CarInfo();
  // ColorsTheme color = new ColorsTheme();

  void _sortCardsById() {
    setState(() {
      widget.cardList.sort((a, b) => a.carDate.compareTo(b.carDate));
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
                  )),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: widget.cardList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 15,
              child: ListTile(
                leading: Image.asset(carImage),
                title: Text(widget.cardList[index].carName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price : ${widget.cardList[index].carPrice}'),
                    Text('date : ${widget.cardList[index].carDate}'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DetailPage()),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appBarColor,
        onPressed: () {
          Navigator.pushNamed(context, '/AddPage').then((newCard) {
            // Handle the returned new card here.
            // You can update the card list in the CardListPage.
            if (newCard != null && newCard is CarInfo) {
              setState(() {
                widget.cardList.add(newCard);
              });
            }
          });
        },
        child: const Icon(
          Icons.add,
          color: button,
        ),
      ),
    );
  }
}



/*
 IconButton(
                
                  onPressed: () {},
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: Color(color.appBarColor),
                    size: 35,
                  )),
                  */






                  /*
                  ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              elevation: 4.0,
              child: ListTile(
                leading: Image.asset(carImage),
                title: const Text(' Dodge'),
                subtitle: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('29,000.00 JD'),
                    Text('2010'),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DetailPage()),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DetailPage()),
                  );
                },
              ),
            ),
            Card(
              elevation: 4.0,
              child: ListTile(
                leading: Image.asset(carImage),
                title: const Text(""),
                subtitle: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('29,000.00 JD'),
                    Text('2010'),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DetailPage()),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
                onTap: () {
                  // Handle card tap
                  print('Card tapped!');
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 380),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddPage()),
                    );
                  },
                  backgroundColor: appBarColor,
                  child: const Icon(
                    Icons.add_circle_outline_sharp,
                  ),
                ),
              ),
            ),
          ],
        ), 
        */