import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:home_food_delivery/src/cook/cook_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mysql.dart';

class signupCook extends StatelessWidget {
  static const String _title = "Signup to be a Cook";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
      theme: FlexColorScheme.light(scheme: FlexScheme.mango).toTheme,
      //darkTheme: FlexColorScheme.dark(scheme: FlexScheme.mango).toTheme,
      themeMode: ThemeMode.system,
    );
  }
}

//connection to MySql database
Future<void> signUpCook(buisnessName, stateId, context) async {
  var db = Mysql();
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('user_id');
  //TODO: will have to make sure buisness_name is unique (also change it in database)
  db.getConnection().then((conn) {
    String sql =
        'insert into Home_Food_Delivery_Database.cook (buisness_name, state_id, avg_rating, user_id) values (?, ?, ?, ?)';
    conn.query(sql, [buisnessName, stateId, 0, userId]).then((results) {},
        onError: (error) {
      print("$error");
    }).whenComplete(() => conn.close());
  });

  //save cook_id
  var db2 = Mysql();
  db2.getConnection().then((conn) {
    String sql = // getting the cookid is in the database
        'select cook_id from Home_Food_Delivery_Database.cook where user_id = \'$userId\'';
    conn.query(sql).then((results) async {
      for (var row in results) {
        await prefs.setInt('cook_id', row[0]);
      }
    }, onError: (error) {
      print("$error");
    }).whenComplete(() => conn.close());
  });
  //after saving cookid goto cook page
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CookView(
            title: 'Cook',
          )));
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController buisnessNameController = TextEditingController();
  TextEditingController stateIdController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        // key to set the global key is only accepted in form
        key: formkey, // set the key to form key to get state of the widet

        /// padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                // updated to text form field
                validator: (value) {
                  // if the values are null, means the user needs to add values
                  if (value == null || value.isEmpty) {
                    return "Please Enter your buisness name";
                  } else {
                    return null; // else returns null
                  }
                },
                controller: buisnessNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Business Name',
                ),
                maxLength: 45,
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
                    return "Please Enter your state Id number";
                  } else {
                    return null;
                  }
                },
                controller: stateIdController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'stateID',
                ),
                maxLength: 14,
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Sign up'),
                  onPressed: () {
                    // if the fields are not empty, then continue to checkdata
                    if (buisnessNameController.text.isNotEmpty &&
                        stateIdController.text.isNotEmpty) {
                      signUpCook(buisnessNameController.text,
                          stateIdController.text, context);
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
                    //add loading screen (if needed)
                  },
                )),
          ],
        ));
  }
}
