// ignore_for_file: camel_case_types, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:home_food_delivery/src/common_tools/hamburger.dart';
import 'package:home_food_delivery/src/cook/update_menu.dart';
import 'package:home_food_delivery/src/signup/mysql.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:home_food_delivery/src/cook/cust_items.dart';
import 'package:intl/intl.dart';
import 'package:home_food_delivery/src/common_tools/update_password.dart';

void main() {
  runApp(const MyApp());
}

const String page1 = "Home";
const String page2 = "Profile";
const String page3 = "Revenue";
const String page4 = "My Menu";
const String title = "TaskBar";

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: cookPage(title: title),
    );
  }
}

// ignore: camel_case_types
class cookPage extends StatefulWidget {
  const cookPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<cookPage> createState() => _cookPageState();
}

// creating pages for taskbar
class _cookPageState extends State<cookPage> {
  late List<Widget> _pages;
  late Widget _page1;
  late Widget _page2;
  late Widget _page3;
  late Widget _page4;
  late int _currentIndex;
  late Widget _currentPage;

// initializing pages
  @override
  void initState() {
    super.initState();
    _page1 = Page1();
    _page2 = Page2(changePage: _changeTab);
    _page3 = Page3();
    _page4 = const Page4();
    _pages = [
      _page1,
      _page2,
      _page3,
      _page4,
    ];
    _currentIndex = 0;
    _currentPage = _page1;
  }

  // manages which page in the taskbar you are in and
  // updates accordingly
  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
      _currentPage = _pages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPage,
      // settign up taskbar icons and labels
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            _changeTab(index);
          },
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              label: page1, // home page
              icon: Icon(Icons.home),
              backgroundColor: Colors.orange.shade300,
            ),
            const BottomNavigationBarItem(
              label: page2, // profile page
              icon: Icon(Icons.person),
            ),
            const BottomNavigationBarItem(
              label: page3, // revenue page
              icon: Icon(Icons.money),
            ),
            const BottomNavigationBarItem(
              label: page4, // menu page *might not need*
              icon: Icon(Icons.menu),
            ),
          ]),
    );
  }

// Manages the page changing on tap of taskbar item
  Widget _navigationItemListTitle(String title, int index) {
    return ListTile(
      title: Text(
        '$title Page',
        style: TextStyle(color: Colors.blue[400], fontSize: 22.0),
      ),
      onTap: () {
        Navigator.pop(context);
        _changeTab(index);
      },
    );
  }
}

class customers {
  String name;
  int id;
  String order_time;
  String deliveryTime;
  customers(this.name, this.id, this.order_time, this.deliveryTime);
}

// home page
class Page1 extends StatefulWidget {
  //if want listview to update when click refresh, have to make stateful widget and extend State
  // https://googleflutter.com/flutter-add-item-to-listview-dynamically/#:~:text=Let%20us%20add%20a%20TextField,item%20to%20the%20list%20dynamically.&text=Run%20this%20application%2C%20and%20you,top%20of%20the%20list%20dynamically
  const Page1({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => Page1State();
} // do not touch this class

//This is the code for Page1
class Page1State extends State<Page1> {
  int firstSet = 0;
  final List<String> names = <String>[
    // list of things that will be in the list
  ];
  final List<int> ids = <int>[];
  late customers cust_instance; // instance of customer order
  List<customers> cust = <customers>[]; // list of objects

// to get the data of the users that have an order from a cook
  Future<void> getData() async {
    var db = Mysql();
    final prefs = await SharedPreferences.getInstance();
    final cook_id = prefs.getInt('cook_id');
    db.getConnection().then((conn) {
      String sql =
          "SELECT DISTINCT concat(user.first_name, ' ', user.last_name), user.user_id, orders.order_date, orders.deliveryDate FROM Home_Food_Delivery_Database.orders JOIN user ON orders.user_id = user.user_id WHERE orders.order_progress = 1 and orders.cook_id = $cook_id ORDER BY deliveryDate";
      conn.query(sql).then((results) {
        for (var row in results) {
          String str = row[0].toString();
          customers person = customers(str, int.parse(row[1].toString()),
              row[2].toString(), row[3].toString());
          setState(() {
            cust.add(person);
          });
        }
      }, onError: (error) {
        print("$error");
      }).whenComplete(() => conn.close());
    });
  }

  Future<void> saveSelectedCustID(customers person) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_customer', person.id);
    await prefs.setString('selected_customer_time', person.order_time);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => custitems(
              title: "orderitems",
            )));
  }

  final List<List<String>> menu = <List<String>>[];
  bool gotData = false;

  void populateMenu() async {
    var db = Mysql();
    final prefs = await SharedPreferences.getInstance();
    var cookId = prefs.getInt('cook_id');
    db.getConnection().then((conn) {
      String sql =
          'select item, description, price from Home_Food_Delivery_Database.menu where cook_id = \'$cookId\'';
      conn.query(sql).then((results) {
        menu.clear();
        for (var row in results) {
          //grabs the results and puts it into the menu ListView
          List<String> item = [
            row[0].toString(),
            row[1].toString(),
            row[2].toString()
          ];
          setState(() {
            menu.insert(0, item);
          });
        }
      }, onError: (error) {
        print("$error");
      }).whenComplete(() => conn.close());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!gotData) {
      populateMenu();
      getData();
      gotData = true;
    }
    return Scaffold(
      drawer: Hamburger(
        title: '',
      ),
      appBar: AppBar(
        title: const Text("Home"),
        automaticallyImplyLeading: true,
        toolbarHeight: 100,
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        // actions: <Widget>[
        //   IconButton(
        //     highlightColor: Colors.transparent,
        //     splashRadius: 27.5,
        //     icon: const Icon(
        //       Icons.menu,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) {
        //             return Hamburger(title: '');
        //           },
        //         ),
        //       );
        //     },
        //   ),
        // ],
      ),
      body: Column(children: <Widget>[
        const Text(
          "Current Orders",
          textAlign: TextAlign.center,
          textScaleFactor: 2.0,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
        ),
        Expanded(
            child: cust.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: cust.length,
                    itemBuilder: (_, i) {
                      String custName = cust[i].name;
                      String deliveryDate = DateFormat('MM-dd-yyyy @ h:mma')
                          .format(DateTime.parse(cust[i].deliveryTime))
                          .toString();
                      // print(cust_name);
                      return GestureDetector(
                          child: Container(
                              height: 50,
                              margin: const EdgeInsets.all(2),
                              color: Colors.amber,
                              child: Center(
                                child: Text(
                                  "$custName\nDelivery Date: $deliveryDate",
                                  style: const TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                          onTap: () {
                            saveSelectedCustID(cust[i]);
                          });
                    })
                : const Center(
                    child: Text("Please Wait for Orders"),
                  )),
        const Text(
          "Menu",
          textAlign: TextAlign.center,
          textScaleFactor: 2.0,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
        ),
        Expanded(
            //Menu List
            child: menu
                    .isNotEmpty //if menu isn't empty then fill in the items (this is a glorified if statement)
                ? ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: menu.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 150,
                        margin: const EdgeInsets.all(2),
                        color: Colors.amber,
                        child: Center(
                            child: Text(
                          '${menu[index][0]} \n ${menu[index][1]} \n \$${menu[index][2]}', // message count used here to get the second list(will be needed for menu)
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        )),
                      );
                    })
                : const Center(
                    child: Text('No Menu Item, Consider Adding Some'))),
        Row(children: <Widget>[
          TextButton(
              child: const Text('Add Menu Item'),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UpdateMenuView()));
              }),
          TextButton(
              child: const Text('Refresh'),
              onPressed: () {
                populateMenu();
              }),
        ])
      ]),
    );
  } // class
}

// Profile page
/*
* Created a stateful classes to add setState to the buttons
*/
class Page2 extends StatefulWidget {
  //if want listview to update when click refresh, have to make stateful widget and extend State
  // https://googleflutter.com/flutter-add-item-to-listview-dynamically/#:~:text=Let%20us%20add%20a%20TextField,item%20to%20the%20list%20dynamically.&text=Run%20this%20application%2C%20and%20you,top%20of%20the%20list%20dynamically
  const Page2({Key? key, required this.changePage}) : super(key: key);
  final void Function(int) changePage;
  @override
  State<StatefulWidget> createState() => Page2State();
}

// // Profile page
class Page2State extends State<Page2> {
  // const Page3({Key? key, required this.changePage}) : super(key: key);
  // final void Function(int) changePage;
  @override
  Widget build(BuildContext context) {
    // sets the status the textform fields in the beginning
    FocusNode deliveryAddressNode = FocusNode();
    FocusNode openHoursNode = FocusNode();
    FocusNode contactAddressNode = FocusNode();
    FocusNode stateIDNode = FocusNode();
    // FocusNode deliveryAddressNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        toolbarHeight: 100,
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      drawer: Hamburger(
        title: '',
      ),
      body: Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          // Listview widget so the screen doesn't overflow
          child: ListView(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset('assets/images/profile_pic.png',
                            height: 100, width: 100)),
                    const Text(
                      "FirstName LastName",
                      style: TextStyle(fontSize: 25),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          child: const Text("Change Password"),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UpdatePassword()));
                          },
                        ),
                        ElevatedButton(
                          // no action is required
                          child: const Text("Change Picture"),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "PickUp Address",
                            style: TextStyle(fontSize: 15),
                            //textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          // margin: const EdgeInsets.only(bottom: 1.0),

                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 10),
                            ),
                            // calls the widget to rebuild the function
                            onPressed: () {
                              // deliveryAddressNode.requestFocus();
                            },
                            child: const Text('Save'),
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      showCursor: false,
                      focusNode: deliveryAddressNode,
                      decoration: const InputDecoration(
                          labelText: "940 W Harrision Street",
                          hintText: "Please Enter your New Address"),
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "Open Hours",
                            style: TextStyle(fontSize: 15),
                            //textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          // margin: const EdgeInsets.only(bottom: 1.0),

                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 10),
                            ),
                            // calls the widget to rebuild the function
                            onPressed: () {
                              // deliveryAddressNode.requestFocus();
                            },
                            child: const Text('Save'),
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      showCursor: false,
                      focusNode: openHoursNode,
                      decoration: const InputDecoration(
                          labelText: "9am - 10pm",
                          hintText: "Please Enter your New Hours"),
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "Contact Number",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Container(
                          // margin: const EdgeInsets.only(bottom: 1.0),

                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 10),
                            ),
                            // calls the widget to rebuild the function
                            onPressed: () {},
                            child: const Text('Save'),
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      showCursor: false,
                      focusNode: contactAddressNode,
                      decoration: const InputDecoration(
                          labelText: "630-696-1245",
                          hintText: "Please Enter your New Phone Number"),
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "State ID",
                            style: TextStyle(fontSize: 15),
                            //textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          // margin: const EdgeInsets.only(bottom: 1.0),

                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 10),
                            ),
                            // calls the widget to rebuild the function
                            onPressed: () {
                              // deliveryAddressNode.requestFocus();
                            },
                            child: const Text('Save'),
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      showCursor: false,
                      focusNode: stateIDNode,
                      decoration: const InputDecoration(
                          labelText: "ABCD564",
                          hintText: "Please Enter Correct State ID"),
                    ),
                  ],
                ),
              ),
            ],
          )
          // adding profile pic and centering change password button

          ),
    );
  }
}

// Revenue page
class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Revenue"),
        toolbarHeight: 100,
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      drawer: Hamburger(
        title: '',
      ),
    );
  }
}

// Menu page
class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Menu"),
        toolbarHeight: 100,
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      drawer: Hamburger(
        title: '',
      ),
    );
  }
}
