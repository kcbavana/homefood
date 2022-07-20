import 'package:flutter/material.dart';
import 'package:home_food_delivery/src/cook/cook_view.dart';
import 'package:home_food_delivery/src/customer/customer_view.dart';
import 'package:home_food_delivery/src/driver/driver_view.dart';
import 'package:home_food_delivery/src/signup/login_view.dart';
import 'package:home_food_delivery/src/signup/mysql.dart';
import 'package:home_food_delivery/src/signup/signup_cook.dart';
import 'package:home_food_delivery/src/signup/signup_driver.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const appTitle = 'Hamburger';
  get customer => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: Hamburger(
        title: appTitle,
      ),
    );
  }

  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: appTitle,
  //     home: Scaffold(
  //       appBar: AppBar(title: const Text(appTitle)),
  //       body: const MyStatefulWidget(),
  //     ),
  //   );
  // }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     Container(
  //       body: Center(
  //         height: 30,
  //         padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
  //         child: ElevatedButton(
  //           child: const Text("Log Out"),
  //           onPressed: () {},
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

Future<void> checkIfCookExists(context) async {
  var db = Mysql();
  final prefs = await SharedPreferences.getInstance();
  final user_id = prefs.getInt('user_id');
  db.getConnection().then((conn) {
    String sql = // checking if the cookid is in the database,
        'select cook_id from Home_Food_Delivery_Database.cook where user_id = \'$user_id\'';
    conn.query(sql).then((results) async {
      if (results.isEmpty) {
        //means cookid doesn't exist in database, goto cook signup page
        Navigator.pop(context);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => signupCook()));
      } else {
        //cookid exists, save cookid (for loop just to get row)
        for (var row in results) {
          await prefs.setInt('cook_id', row[0]);
        }
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CookView(
                  title: 'Cook',
                )));
      }
    }, onError: (error) {
      print("$error");
    }).whenComplete(() => conn.close());
  });
}

Future<void> checkIfDriverExists(context) async {
  var db = Mysql();
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('user_id');
  db.getConnection().then((conn) {
    String sql = // checking if the driverid is in the database,
        'select driver_id from Home_Food_Delivery_Database.driver where user_id = \'$userId\'';
    conn.query(sql).then((results) async {
      if (results.isEmpty) {
        //means driverid doesn't exist in database, goto driver signup page
        Navigator.pop(context);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => signupDriver()));
      } else {
        //driverid exists, save driverid (for loop just to get row)
        for (var row in results) {
          await prefs.setInt('driver_id', row[0]);
        }
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DriverView(
                  title: 'Driver',
                )));
      }
    }, onError: (error) {
      print("$error");
    }).whenComplete(() => conn.close());
  });
}

class Hamburger extends StatelessWidget {
  Hamburger({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              color: Colors.amber,
            ),
            // Update the state of the app
            //child: Text('Insert logo here'),
            child: Image.asset('assets/images/circle logo.png',
                height: 200, width: 200),
          ),
          ListTile(
            title: const Text('Customer'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CustomerView(
                        title: 'Customer',
                      )));
            },
          ),
          ListTile(
            title: const Text('Driver'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              checkIfDriverExists(context);
            },
          ),
          ListTile(
            title: const Text('Cook'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              checkIfCookExists(context);
              // //checkData(user_id, context);
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => CookView(
              //           title: 'Cook',
              //         )));
            },
          ),
          ListTile(
            //title: const Text('Log Out'),
            title: new Center(
                child: new Text(
              "Log Out",
              style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            )),
            tileColor: Colors.amber,
            onTap: () {
              // remove all the context until back at login view
              // this means you cant back button to another page if you hit logout
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => loginView()),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
        // Row(
        //   Container(
        //     height: 30,
        //     padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        //     child: ElevatedButton(
        //       child: const Text("Log Out"),
        //       onPressed: () {},
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
