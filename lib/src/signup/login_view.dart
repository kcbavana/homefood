// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:home_food_delivery/src/customer/customer_view.dart';
import 'package:home_food_delivery/src/signup/signup_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'mysql.dart';

//TODO: add hash function for password

class loginView extends StatelessWidget {
  static const String _title = "Home Food Delivery";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
        //backgroundColor: const Color(0x00ae2929),
      ),
      theme: FlexColorScheme.light(scheme: FlexScheme.redWine).toTheme,
      //darkTheme: FlexColorScheme.dark(scheme: FlexScheme.rosewood).toTheme,
      themeMode: ThemeMode.system,
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

Widget _buildPopupDialog(BuildContext context) {
  //can make different ones for password and username if wanted
  return new AlertDialog(
    title: const Text('Error'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Username or Password is incorrect"),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Close'),
      ),
    ],
  );
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  //connection to MySql database
  var db = Mysql();
  Future<void> checkData(userName, password) async {
    db.getConnection().then((conn) {
      String sql =
          'select password, user_id from Home_Food_Delivery_Database.user where username = \'$userName\'';
      conn.query(sql).then((results) async {
        if (results.isEmpty) {
          //means username doesn't exist in database
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupDialog(context),
          );
        } else {
          for (var row in results) {
            if (row[0] == password) {
              //password is correct, procede to customer screen
              // Obtain shared preferences and save user id
              final prefs = await SharedPreferences.getInstance();
              await prefs.setInt('user_id', row[1]);
              // clear the fields here
              userNameController
                  .clear(); // clear username and password field for logout
              passwordController.clear();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CustomerView(
                        title: 'Customer',
                      )));
            } else {
              //password for inputted username is incorrect
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildPopupDialog(context),
              );
            }
          }
        }
      }, onError: (error) {
        print("$error");
      }).whenComplete(() => conn.close());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        // key to set the global key is only accepted in form
        key: formkey, // set the key to form key to get state of the widet
        /// padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                padding: const EdgeInsets.all(30.0),
                child: Image.asset('assets/images/circle logo.png',
                    height: 300, width: 300)),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                // updated to text form field
                validator: (value) {
                  // if the values are null, means the user needs to add values
                  if (value == null || value.isEmpty) {
                    return "Please enter the username";
                  } else {
                    return null; // else returns null
                  }
                },
                controller: userNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                // validators to check the status of the form field
                validator: (value) {
                  // if the state of the widget is empty, then validators are
                  // activated
                  if (value == null || value.isEmpty) {
                    return "Please Enter the password";
                  } else {
                    return null;
                  }
                },
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignUpView()));
              },
              child: const Text(
                "Don't have an account? Sign Up",
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Log in'),
                  onPressed: () {
                    // if the fields are not empty, then continue to checkdata
                    if (userNameController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      checkData(
                          userNameController.text, passwordController.text);
                    }
                    // if the form state is activated by the widget
                    if (formkey.currentState != null) {
                      // then check the validate status
                      // if no validator issues, then proced
                      if (formkey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    }

                    print(userNameController.text);
                    print(passwordController.text);

                    //add loading screen (if needed)
                  },
                )),
          ],
        ));
  }
}
