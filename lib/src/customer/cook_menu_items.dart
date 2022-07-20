// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:home_food_delivery/src/signup/mysql.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common_tools/customer_page.dart';

class cookitems extends StatelessWidget {
  String title;
  String data = "Cook's Menu";
  List<List<String>> menu = <List<String>>[];
  cookitems({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(data),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const customerPage(title: '')),
            ),
            //Page1State
          ),
          backgroundColor: Colors.indigo.shade300,
        ),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

// ignore: camel_case_types
class menuItem {
  double price;
  String name;
  String description;
  int itemCount;
  int menuId;
  menuItem(
      this.name, this.description, this.price, this.itemCount, this.menuId);
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  List<menuItem> menu = []; // object list to store info
  List<String> menuString = [];
  List<String> priceString = [];
  List<String> quant = []; // List strings for share prefs
  List<String> menuIdStr = [];
  bool gotMenu = false;
  String cookName = "Cook Name";
  String converter = "9";
  int menuId = 0;

  getMenuItems(List<menuItem> menu) async {
    //get ID of cook was clicked and get their menu items
    var db = Mysql();
    final prefs = await SharedPreferences.getInstance();
    final cookID = prefs.getInt('selected_cook');
    db.getConnection().then((conn) {
      String sql =
          'select item, description, price, menu_id from Home_Food_Delivery_Database.menu where cook_id = \'$cookID\'';
      conn.query(sql).then((results) {
        for (var row in results) {
          var item = menuItem(row[0].toString(), row[1].toString(),
              double.parse(row[2].toString()), 0, row[3]);
          setState(() {
            menu.insert(0, item);
          });
        }
      }, onError: (error) {
        print("$error");
      }).whenComplete(() => conn.close());
    });

    //Get cook name
    db.getConnection().then((conn) {
      String sql =
          'select buisness_name from Home_Food_Delivery_Database.cook where cook_id = \'$cookID\'';
      conn.query(sql).then((results) {
        for (var row in results) {
          setState(() {
            cookName = row[0].toString();
          });
        }
      }, onError: (error) {
        print("$error");
      }).whenComplete(() => conn.close());
    });
  }

  void add(menuItem m) {
    // updates the count by +1 in obj
    setState(() {
      m.itemCount++;
    });
  }

  void sub(menuItem m) {
    setState(() {
      // updates the count by -1 in obj
      if (m.itemCount > 0) {
        m.itemCount--;
      }
    });
  }

  Future<void> setSharePref() async {
    // iterates through the object list and adds
    // the info to sharepref lists
    for (int i = 0; i < menu.length; i++) {
      if (menu[i].itemCount > 0) {
        // only if the count is greater than 0
        menuString.add(menu[i].name);
        priceString.add(menu[i].price.toString());
        quant.add(menu[i].itemCount.toString());
        menuIdStr.add(menu[i].menuId.toString());
      }
    }
    // opens the shared pref
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('items', menuString);
    await prefs.setStringList('price', priceString);
    await prefs.setStringList('quant', quant);
    await prefs.setStringList('menuId', menuIdStr);
    if (menuString.length == priceString.length &&
        priceString.length == quant.length) {
      // if all the sizes match, then we change the page to final order page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Page2()),
      );
    }
    // clears the lists to avoid data over flow
    menuString.clear();
    priceString.clear();
    quant.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (!gotMenu) {
      getMenuItems(menu);
      gotMenu = true;
    }
    return Column(children: [
      Row(
        children: <Widget>[
          const SizedBox(height: 20, width: 20),
          Container(
            height: 150,
            width: 100,
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Image.asset("assets/images/circle logo.png"),
          ),
          Text(
            cookName,
            style: const TextStyle(
                fontSize: 25.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          // _incrementButton(),
        ],
      ),
      const Text(
        "Menu",
        textAlign: TextAlign.center,
        textScaleFactor: 2.0,
        style: TextStyle(
            //color: Colors.blue,
            fontSize: 12.0),
      ),
      Expanded(
          //Menu List
          child: menu.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: menu.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        height: 200,
                        margin: const EdgeInsets.all(3),
                        color: Colors.indigo.shade300,
                        child: Row(children: [
                          Image.asset(
                            "assets/images/circle logo.png",
                            height: 75,
                            width: 75,
                          ),
                          Flexible(
                            child: Align(
                              alignment: const Alignment(0, 0),
                              child: Text(
                                //display name, description, and price from List<menuItem>
                                '${menu[index].name}\n${menu[index].description}\n\$${menu[index].price}',
                                style: const TextStyle(fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                height: 30,
                                width: 25,
                                // buttons for adding
                                child: FloatingActionButton(
                                  heroTag: null,
                                  onPressed: () => {
                                    // calls the add function to updates
                                    // the object list quantity
                                    add(menu[index]),
                                  },
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 25,
                                child: Text(
                                  menu[index].itemCount.toString(),
                                  style: const TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 25,
                                child: FloatingActionButton(
                                  heroTag: null,
                                  // calls the sub function to updates
                                  // the object list quantity
                                  onPressed: () => {
                                    sub(menu[index]),
                                  },
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.black,
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ]));
                  })
              : const Center(
                  child: Text('No Menu Item, Consider Adding Some'))),
      ElevatedButton(
        // when the button is pressed then the shared pref is set
        onPressed: () {
          setSharePref();
        },
        child: Text('Add to Cart'),
        style: ElevatedButton.styleFrom(primary: Colors.indigo.shade300),
      )
    ]);
  }
}
