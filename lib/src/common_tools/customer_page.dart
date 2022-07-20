// ignore_for_file: camel_case_types, duplicate_ignore, must_be_immutable, unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:home_food_delivery/src/common_tools/google_map.dart';
import 'package:home_food_delivery/src/common_tools/hamburger.dart';
import 'package:home_food_delivery/src/common_tools/update_password.dart';
import 'package:home_food_delivery/src/customer/cook_menu_items.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:home_food_delivery/src/signup/mysql.dart';
import "package:intl/intl.dart";
import "package:date_time_picker/date_time_picker.dart";
//
// This file contains the taskbar set up and its pages
// for the customer. Home contains a search bar and list view.
// This file is called in customer_view.dart and sets up the
// basic customer page view.
//

void main() {
  runApp(const MyApp());
}

const String page1 = "Home";
const String page2 = "Orders";
const String page3 = "Profile";
const String page4 = "Maps";
const String title = "TaskBar";

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: title,
      home: customerPage(title: title),
    );
  }
}

// ignore: camel_case_types
class customerPage extends StatefulWidget {
  const customerPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<customerPage> createState() => _customerPageState();
}

// creating pages for taskbar
class _customerPageState extends State<customerPage> {
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
    _page2 = const Page2();
    _page3 = Page3(changePage: _changeTab);
    _page4 = const Page4();
    _pages = [_page1, _page2, _page3, _page4];
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
              backgroundColor: Colors.deepOrange.shade800,
            ),
            BottomNavigationBarItem(
              label: page2, // orders page
              icon: Icon(Icons.inbox_outlined),
              backgroundColor: Colors.deepOrange.shade800,
            ),
            BottomNavigationBarItem(
              label: page3, // profile page
              icon: Icon(Icons.person),
              backgroundColor: Colors.deepOrange.shade800,
            ),
            BottomNavigationBarItem(
              label: page4, // menu page *might not need*
              icon: Icon(Icons.map),
              backgroundColor: Colors.deepOrange.shade800,
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

// Floating Search bar
// https://pub.dev/packages/material_floating_search_bar
Widget buildFloatingSearchBar(BuildContext context) {
  final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

  return FloatingSearchBar(
    hint: 'Search...',
    scrollPadding: const EdgeInsets.only(top: 20, bottom: 56),
    transitionDuration: const Duration(milliseconds: 200),
    transitionCurve: Curves.easeInOut,
    physics: const BouncingScrollPhysics(),
    axisAlignment: isPortrait ? 0.0 : -1.0,
    openAxisAlignment: 0.0,
    width: isPortrait ? 600 : 500,
    debounceDelay: const Duration(milliseconds: 500),
    onQueryChanged: (query) {
      // Call your model, bloc, controller here.
    },
    // Specify a custom transition to be used for
    // animating between opened and closed stated.
    transition: CircularFloatingSearchBarTransition(),
    actions: [
      FloatingSearchBarAction(
        showIfOpened: false,
        child: CircularButton(
          icon: const Icon(Icons.place),
          onPressed: () {},
        ),
      ),
      FloatingSearchBarAction.searchToClear(
        showIfClosed: false,
      ),
    ],
    builder: (context, transition) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: Colors.white,
          elevation: 4.0,
          child: Container(
            height: 75,
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  title: const Text("Search for Cooks Here"),
                  subtitle: const Text(
                      "Only Cooks Within a 5 mile Radius will Appear"),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class Page1 extends StatefulWidget {
  //if want listview to update when click refresh, have to make stateful widget and extend State
  // https://googleflutter.com/flutter-add-item-to-listview-dynamically/#:~:text=Let%20us%20add%20a%20TextField,item%20to%20the%20list%20dynamically.&text=Run%20this%20application%2C%20and%20you,top%20of%20the%20list%20dynamically
  const Page1({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => Page1State();
}

// home page
class Page1State extends State<Page1> {
  // Page1({Key? key}) : super(key: key);
  List<String> cookNames = <String>[];
  var db = Mysql();

  Future<void> getData() async {
    db.getConnection().then((conn) {
      String str = "";
      String sql = // checking if the cookid is in the database, for validating
          'select buisness_name from Home_Food_Delivery_Database.cook';
      conn.query(sql).then((results) {
        for (var row in results) {
          str = row.toString().substring(24);
          setState(() {
            cookNames.insert(0, str.substring(0, str.length - 1));
          });
        }
      }, onError: (error) {
        print("$error");
      }).whenComplete(() => conn.close());
    });
  }

  Future<void> saveSelectedCookID(String name) async {
    //save cook_id so menu page can get cook's menu items
    var db = Mysql();
    final prefs = await SharedPreferences.getInstance();
    db.getConnection().then((conn) {
      String sql = // checking if the cookid is in the database, for validating
          'select cook_id from cook where buisness_name = "$name"';
      conn.query(sql).then((results) async {
        for (var row in results) {
          await prefs.setInt('selected_cook', row[0]);
        }
      }, onError: (error) {
        print("$error");
      }).whenComplete(() {
        conn.close();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => cookitems(
                  title: "cookitems",
                )));
      });
    });

    //go to menu page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        automaticallyImplyLeading: true,
        toolbarHeight: 100,
        centerTitle: true,
        backgroundColor: Colors.deepOrange.shade800,
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
      drawer: Hamburger(
        title: '',
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: buildFloatingSearchBar(context),
            ),
            Expanded(
                // list view container
                child: cookNames.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: cookNames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              child: Container(
                                  height: 50,
                                  margin: const EdgeInsets.all(2),
                                  color: Colors.orangeAccent,
                                  child: Center(
                                    child: Text(
                                      cookNames[index],
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  )),
                              onTap: () {
                                saveSelectedCookID(cookNames[index]);
                              });
                        })
                    : const Center(
                        child: Text("Please Search for Cooks"),
                      )),
            Container(
              height: 30,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text("Search"),
                onPressed: () {
                  cookNames.clear();
                  getData();
                },
              ),
            ),
            Container(padding: const EdgeInsets.all(10)),
          ],
        ),
      ),
    );
  }
}

// Orders page
class Page2 extends StatefulWidget {
  //if want listview to update when click refresh, have to make stateful widget and extend State
  // https://googleflutter.com/flutter-add-item-to-listview-dynamically/#:~:text=Let%20us%20add%20a%20TextField,item%20to%20the%20list%20dynamically.&text=Run%20this%20application%2C%20and%20you,top%20of%20the%20list%20dynamically
  const Page2({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => Page2State();
}

class custOrder {
  String menuItem;
  double price;
  int count;
  int menuId;
  custOrder(this.menuItem, this.price, this.count, this.menuId);
}

class Page2State extends State<Page2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      print("WidgetsBinding");
    });
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      print("SchedulerBinding");
    });
  }

  @override
  void dispose() {
    //save state of the order when user leaves order page
    setSharePref();
    super.dispose();
  }

  Widget _buildPopupDialog(BuildContext context) {
    //can make different ones for password and username if wanted
    return AlertDialog(
      title: const Text('Error'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
              "Please enter a date and time at least 1 hour in the future to give our cooks time to make your order and drivers time to deliver your order.",
              textAlign: TextAlign.center)
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }

  TextEditingController specialRequestsController = TextEditingController();
  int firstSet = 0;
  String deliveryDateTime = DateTime.now().toString();
  List<String> items = <String>[];
  List<double> price = <double>[];
  List<int> count = <int>[];
  List<int> menuId = <int>[];

  late custOrder order; // instance of customer order

  // gets the shared pref and data will be updated
  // this function also converts into their types
  Future<void> getSharePref() async {
    //get order info from sharedPreferences and store it in local variables
    final prefs = await SharedPreferences.getInstance();
    final List<String>? itemsTest = prefs.getStringList('items');
    final List<String>? pricesTest = prefs.getStringList('price');
    final List<String>? quanTest = prefs.getStringList('quant');
    final List<String>? menuIdTest = prefs.getStringList('menuId');
    if (itemsTest != null && itemsTest.isNotEmpty) {
      for (int i = 0; i < itemsTest.length; i++) {
        items.add(itemsTest[i]);
        // changes the types of the items
        price.add(double.parse(pricesTest![i]));
        count.add(int.parse(quanTest![i]));
        menuId.add(int.parse(menuIdTest![i]));
      }
      setDataFromList();
    }
  }

  Future<void> setSharePref() async {
    List<String> priceString = [];
    List<String> quant = []; // List strings for share prefs
    List<String> menuIdStr = [];
    // iterates through the object list and adds
    // the info to sharepref lists
    for (int i = 0; i < items.length; i++) {
      priceString.add(price[i].toString());
      quant.add(count[i].toString());
      menuIdStr.add(menuId[i].toString());
    }
    // opens the shared pref
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('items', items);
    await prefs.setStringList('price', priceString);
    await prefs.setStringList('quant', quant);
    await prefs.setStringList('menuId', menuIdStr);
  }

  List<custOrder> ord = <custOrder>[]; // list of objects
  void setDataFromList() {
    for (var i = 0; i < price.length; i++) {
      order = custOrder(items[i], price[i], count[i],
          menuId[i]); // assigning to order and adding to list
      setState(() {
        ord.add(order);
      });
    }
  }

  void getCookID(List<custOrder> order) {
    var db = Mysql();
    int cookID = 0;
    int menuID = order[0].menuId;
    db.getConnection().then((conn) {
      //get cookID for the order being placed
      String sql =
          'select cook_id from Home_Food_Delivery_Database.menu where menu_id = \'$menuID\'';
      conn.query(sql).then((results) {
        for (var row in results) {
          cookID = int.parse(row[0].toString());
        }
      }, onError: (error) {
        print("$error");
      }).whenComplete(() {
        conn.close();
        //call placeOrder once cookID is known
        placeOrder(order, cookID);
      });
    });
  }

  //order progress: 1 = order placed (cook can see order);
  // 2 = cook completed order (driver can now see order to deliver it)
  Future<void> placeOrder(List<custOrder> order, int cookID) async {
    var db = Mysql();
    final prefs = await SharedPreferences.getInstance();
    //actually customer but we didn't use that table so customerID=userID
    final userID = prefs.getInt('user_id');
    DateTime now = DateTime.now();
    String stringDate = now.toString();
    int counter = 0;
    //insert every order into the database
    for (var ord in order) {
      db.getConnection().then((conn) {
        //get cookID for the order being placed
        String sql =
            'insert into Home_Food_Delivery_Database.orders (menu_id, cook_id, user_id, item_quantity, order_progress, order_date, deliveryDate, specialRequest) values (?,?,?,?,?,?,?,?)';
        conn.query(sql, [
          ord.menuId,
          cookID,
          userID,
          ord.count,
          1,
          stringDate,
          deliveryDateTime,
          specialRequestsController.text
        ]).then((results) {}, onError: (error) {
          print("$error");
        }).whenComplete(() {
          setSharePref(); //clear sharedPreferences for order details
          conn.close();
          counter++;
          if (counter == order.length) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order Placed!')),
            );
            setState(() {
              //clear order because order was placed
              order.clear();
              items.clear();
              price.clear();
              count.clear();
              menuId.clear();
            });
            specialRequestsController.clear();
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (firstSet == 0) {
      // to make sure that this function runs once
      getSharePref();
      // setDataFromList();
      firstSet = 1;
    }
    //getSharePref();
    return Scaffold(
        drawer: Hamburger(
          title: '',
        ),
        appBar: AppBar(
          // title bar
          title: const Text('Final Order'),

          toolbarHeight: 100,
          centerTitle: true,
          backgroundColor: Colors.deepOrange.shade800,
          actions: <Widget>[
            IconButton(
              highlightColor: Colors.transparent,
              splashRadius: 27.5,
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Column(children: <Widget>[
          Expanded(
              child: items.isNotEmpty
                  ? ListView.builder(
                      // list view
                      itemBuilder: (_, i) {
                        String name = ord[i].menuItem; // assigning values
                        double cost = ord[i].price;
                        int ct = ord[i].count;
                        double sum = 0;
                        String sumStr = '';
                        for (var j = 0; j < ord.length; j++) {
                          // getting sum of your order
                          sum = double.parse(
                              (sum + (ord[j].price * ord[j].count))
                                  .toStringAsFixed(2)); // gets sum as double
                          sumStr = NumberFormat.simpleCurrency().format(
                              sum); // numberformat converts it to currency format
                        }
                        bool isLast = false;
                        if (i == ord.length - 1) {
                          isLast = true;
                        }
                        return ListTile(
                          // leading: CircleAvatar(  //if we want to add an image or logo, the comment is how to do so
                          //   child: Text('${items[0]}'),
                          // ),
                          title: isLast
                              ? Text(
                                  "$name\n\$$cost\n$ct\n\n\nFinal Total: $sumStr") // printing last item and the total
                              : Text("$name\n\$$cost\n$ct\n"),

                          trailing: PopupMenuButton(
                            // the : part of the UI
                            itemBuilder: (context) {
                              return [
                                const PopupMenuItem(
                                  // blue squigly bc it wants to be const...i will wait to do that
                                  value: 'add',
                                  child: Text('Add'),
                                ),
                                const PopupMenuItem(
                                  value: 'remove',
                                  child: Text('Remove One'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete Menu Item'),
                                )
                              ];
                            },
                            onSelected: (String value) {
                              // dealing with onclick events with the popmenu
                              if (value == "add") {
                                setState(() {
                                  ord[i].count++;
                                  count[i]++;
                                });
                                print('You Click on add menu item');
                              } else if (value == "delete") {
                                setState(() {
                                  ord[i].count = 0;
                                  print('You Click on delete menu item');
                                });
                              } else if (value == "remove") {
                                if (ord[i].count > 0) {
                                  setState(() {
                                    ord[i].count--;
                                    count[i]--;
                                    print('You Click on remove menu item');
                                  });
                                }
                              }
                              if (ord[i].count == 0) {
                                // pop  off the list when at 0, the GUI will be updated
                                setState(() {
                                  ord.removeAt(i);
                                  items.removeAt(i);
                                  price.removeAt(i);
                                  count.removeAt(i);
                                  menuId.removeAt(i);
                                  print(items);
                                });
                                print('Trying to pop menu item when at 0');
                              }
                            },
                          ),
                        );
                      }, // itembuilder
                      itemCount: ord.length,
                      // added , in next line
                    )
                  : const Center(
                      child: Text(
                          "No Items in your cart yet"), // when the cart is empty
                    )),
          Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'd MMM, yyyy',
                initialValue: DateTime.now()
                    .add(const Duration(hours: 1, minutes: 1))
                    .toString(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2050),
                icon: Icon(Icons.event),
                autovalidate: true,
                dateLabelText: 'Delivery Date',
                timeLabelText: 'Delivery Time',
                onChanged: (val) {
                  deliveryDateTime = val.toString();
                  print(deliveryDateTime);
                },
                validator: (val) {
                  if (DateTime.now()
                      .add(const Duration(minutes: 59))
                      .isAfter(DateTime.parse(val!))) {
                    return "Select a time at least 1hr in the future";
                  }
                  return null;
                },
                onSaved: (val) {
                  deliveryDateTime = val.toString();
                  print(deliveryDateTime);
                },
              )),
          Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: TextFormField(
                controller: specialRequestsController,
                maxLength: 150,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Special Requests/Instructions',
                ),
              )),
          Row(children: <Widget>[
            Container(
              height: 30,
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: ElevatedButton(
                child: const Text("Place Order"),
                onPressed: () {
                  //Only place order if there are items to order
                  if (ord.isNotEmpty) {
                    if (DateTime.now()
                        .add(const Duration(minutes: 59))
                        .isAfter(DateTime.parse(deliveryDateTime))) {
                      //check if delivery date is valid
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupDialog(context),
                      );
                    } else {
                      //calls place order once code knows the CookID that user is placing the order to
                      getCookID(ord);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Placing Order...')),
                      );
                    }
                  }
                },
              ),
            ),
            Container(
              height: 30,
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: ElevatedButton(
                child: const Text("Clear Order"),
                onPressed: () {
                  setState(() {
                    ord.clear();
                    items.clear();
                    price.clear();
                    count.clear();
                    menuId.clear();
                  });
                  setSharePref(); //set variables in shared preferences to the cleared lists
                  specialRequestsController.clear();
                },
              ),
            )
          ])
        ]));
  }
}

/*
* Created a stateful classes to add setState to the buttons
*/
class Page3 extends StatefulWidget {
  //if want listview to update when click refresh, have to make stateful widget and extend State
  // https://googleflutter.com/flutter-add-item-to-listview-dynamically/#:~:text=Let%20us%20add%20a%20TextField,item%20to%20the%20list%20dynamically.&text=Run%20this%20application%2C%20and%20you,top%20of%20the%20list%20dynamically
  const Page3({Key? key, required this.changePage}) : super(key: key);
  final void Function(int) changePage;
  @override
  State<StatefulWidget> createState() => Page3State();
}

// // Profile page
class Page3State extends State<Page3> {
  // const Page3({Key? key, required this.changePage}) : super(key: key);
  // final void Function(int) changePage;

  @override
  Widget build(BuildContext context) {
    // sets the status the textform fields in the beginning
    FocusNode deliveryAddressNode = FocusNode();
    FocusNode contactAddressNode = FocusNode();
    // FocusNode deliveryAddressNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        toolbarHeight: 100,
        centerTitle: true,
        backgroundColor: Colors.deepOrange.shade800,
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
                            "Delivery Address",
                            style: TextStyle(fontSize: 15),
                            //textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          // margin: const EdgeInsets.only(bottom: 1.0),

                          alignment: Alignment.topRight,
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

                          alignment: Alignment.topRight,
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

// Menu page
class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maps"),
        toolbarHeight: 100,
        centerTitle: true,
        backgroundColor: Colors.deepOrange.shade800,
      ),
      drawer: Hamburger(
        title: '',
      ),
      body: const GoogleMapImplementation(),
    );
    // // @override
    // Widget build(BuildContext context) {
    //   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: const Text("Maps"),
    //       toolbarHeight: 100,
    //       centerTitle: true,
    //       backgroundColor: Colors.deepOrange.shade800,
    //     ),
    //     drawer: Hamburger(
    //       title: '',
    //     ),
    //     key: _scaffoldKey,
    //     endDrawerEnableOpenDragGesture: false, // This!
    //   );
  }
}
