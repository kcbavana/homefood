// ignore_for_file: camel_case_types, duplicate_ignore

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:home_food_delivery/src/common_tools/hamburger.dart';
import 'package:home_food_delivery/src/common_tools/google_map.dart';
import 'package:home_food_delivery/src/common_tools/update_password.dart';
// imports for weather api
import 'package:home_food_delivery/src/weather_api/screens/loading_screen.dart';

void main() {
  runApp(const MyApp());
}

const String page1 = "Home";
const String page2 = "Maps";
const String page3 = "Profile";
const String page4 = "Weather";
const String page5 = "Gas Price";
const String title = "TaskBar";

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: const driverPage(title: title),
      theme: FlexColorScheme.light(scheme: FlexScheme.brandBlue).toTheme,
      darkTheme: FlexColorScheme.dark(scheme: FlexScheme.brandBlue).toTheme,
      themeMode: ThemeMode.system,
    );
  }
}

// ignore: camel_case_types
class driverPage extends StatefulWidget {
  const driverPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<driverPage> createState() => _driverPageState();
}

// creating pages for taskbar
class _driverPageState extends State<driverPage> {
  late List<Widget> _pages;
  late Widget _page1;
  late Widget _page2;
  late Widget _page3;
  late Widget _page4;
  late Widget _page5;
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
    _page5 = const Page5();
    _pages = [_page1, _page2, _page3, _page4, _page5];
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
              backgroundColor: Colors.cyan.shade400,
            ),
            BottomNavigationBarItem(
              label: page2, // map page
              icon: Icon(Icons.map),
              backgroundColor: Colors.cyan.shade400,
            ),
            BottomNavigationBarItem(
              label: page3, // profile page
              icon: Icon(Icons.person),
              backgroundColor: Colors.cyan.shade400,
            ),
            BottomNavigationBarItem(
              label: page4, // revenue page
              icon: Icon(Icons.cloud_rounded),
              backgroundColor: Colors.cyan.shade400,
            ),
            BottomNavigationBarItem(
              label: page5, // menu page *might not need*
              icon: Icon(Icons.car_repair),
              backgroundColor: Colors.cyan.shade400,
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

// home page
class Page1 extends StatefulWidget {
  //if want listview to update when click refresh, have to make stateful widget and extend State
  // https://googleflutter.com/flutter-add-item-to-listview-dynamically/#:~:text=Let%20us%20add%20a%20TextField,item%20to%20the%20list%20dynamically.&text=Run%20this%20application%2C%20and%20you,top%20of%20the%20list%20dynamically
  const Page1({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => DriverViewState();
}

// listview page1
class DriverViewState extends State<Page1> {
  int tracker = 0;
  late List<String> names = <String>[];
  List<String> names2 = <String>[
    // list of things that will be in the lsit
    'Bob',
    'Charlie',
    'Cook',
    'Carline',
    'Soham',
    'Hari',
    'Ish'
  ];
  List<String> temp = <String>[];
  final List<String> test = <String>[];
  //final String title;
  final List<List<String>> menu = <List<String>>[];
  List<bool> isSelected = List.generate(2, (_) => false);

  get child => null;

  Widget populateText() {
    return Column(
      children: const <Widget>[
        Text(
          "Current Available Orders",
          textAlign: TextAlign.center,
          textScaleFactor: 2.0,
          style: TextStyle(
              //color: Colors.blue,
              fontSize: 12.0),
        ),
      ],
    );
  }

  void populateList(int updater) {
    if (updater == 1) {
      print("Reached Here");
      names.clear();
    } else {
      for (int i = 0; i < names2.length; i++) {
        names.insert(i, names2[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tracker == 0) {
      isSelected[1] = true;
      tracker++;
    }
    int updater = 1;
    return Scaffold(
        drawer: Hamburger(
          title: '',
        ),
        appBar: AppBar(
          title: const Text("Home"),
          automaticallyImplyLeading: true,
          toolbarHeight: 100,
          centerTitle: true,
          backgroundColor: Colors.cyan.shade400,
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
        body: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(10.0)),
            const Text(
              "Set Active Status",
              textAlign: TextAlign.center,
              textScaleFactor: 2.0,
              style: TextStyle(
                  //color: Colors.blue,
                  fontSize: 12.0),
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            // ignore: prefer_const_literals_to_create_immutables
            ToggleButtons(
                children: const <Widget>[
                  Text("ON"),
                  Text("OFF"),
                ],
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < isSelected.length; i++) {
                      if (i == index) {
                        isSelected[i] = true;
                        updater = 1;
                        populateList(updater);
                      } else {
                        isSelected[i] = false;
                        updater = 2;
                        populateList(updater);
                      }
                    }
                  });
                },
                isSelected: isSelected),
            const Padding(padding: EdgeInsets.all(10.0)),
            populateText(),
            Expanded(
                //Orders List
                // list view part goes here in expanded
                child: names.isNotEmpty
                    ? ListView.builder(
                        padding:
                            const EdgeInsets.all(8), // just some initilization
                        itemCount: names.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 50,
                            margin: const EdgeInsets.all(2),
                            color: Colors.teal.shade100,
                            child: Center(
                                child: Text(
                              '${names[index]} ', // getting from names array
                              style: const TextStyle(fontSize: 18),
                            )),
                          );
                        })
                    : const Center(
                        child: Text("Turn On To See Available Orders"),
                      ))
          ],
        ));
  }
}

// Maps
class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maps"),
        toolbarHeight: 100,
        centerTitle: true,
        backgroundColor: Colors.cyan.shade400,
      ),
      drawer: Hamburger(
        title: '',
      ),
      body: const GoogleMapImplementation(),
    );
  }
}

// Profile page
class Page3 extends StatelessWidget {
  const Page3({Key? key, required this.changePage}) : super(key: key);
  final void Function(int) changePage;

  @override
  Widget build(BuildContext context) {
    // sets the status the textform fields in the beginning
    FocusNode vinNode = FocusNode();
    FocusNode contactAddressNode = FocusNode();
    // FocusNode deliveryAddressNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        toolbarHeight: 100,
        centerTitle: true,
        backgroundColor: Colors.cyan.shade400,
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
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "VIN Number",
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
                      focusNode: vinNode,
                      decoration: const InputDecoration(
                          labelText: "630-696-1245",
                          hintText: "Please Enter your New VIN Number"),
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
class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Weather"),
        toolbarHeight: 100,
        centerTitle: true,
        backgroundColor: Colors.cyan.shade400,
      ),
      drawer: Hamburger(
        title: '',
      ),
      body: LoadingScreen(),
    );
  }
}

// Menu page
class Page5 extends StatelessWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gas Price"),
        toolbarHeight: 100,
        centerTitle: true,
        backgroundColor: Colors.cyan.shade400,
      ),
      drawer: Hamburger(
        title: '',
      ),
      body: Column(children: <Widget>[
        const Text(
          "Gas Price",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 25.0),
        ),
        Container(
          width: 300,
          color: Colors.cyan.shade400,
          margin: const EdgeInsets.fromLTRB(90, 30, 90, 0),
          child: const Text(
            "Current Location",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
        Container(
            padding: const EdgeInsets.all(20),
            child:
                Image.asset('assets/images/gas.png', height: 200, width: 200)),
        Container(
          height: 150,
          width: 500,
          padding: const EdgeInsets.all(40),
          color: Colors.cyan.shade400,
          margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: const Text(
            "4.59 Dollars Per Gallon",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 25.0),
          ),
        ),
      ]),
    );
  }
}
