import 'package:flutter/material.dart';
import 'package:home_food_delivery/src/cook/cook_view.dart';
import 'package:home_food_delivery/src/signup/mysql.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateMenuView extends StatelessWidget {
  static const String _title = "Add Menu Item";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

Future<void> addMenuItem(item, description, price, context) async {
  var db = Mysql();
  final prefs = await SharedPreferences.getInstance();
  final cookId = prefs.getInt('cook_id');
  db.getConnection().then((conn) {
    String sql = // add menu item into database
        'insert into Home_Food_Delivery_Database.menu (item, description, price, cook_id) values (?, ?, ?, ?)';
    conn.query(sql, [item, description, price, cookId]).then((results) {},
        onError: (error) {
      print("$error");
    }).whenComplete(() => conn.close());
  });
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
  final String title = "Add Menu Item";
  TextEditingController itemNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        // key to set the global key is only accepted in form
        key: formkey, // set the key to form key to get state of the widet

        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                // updated to text form field
                validator: (value) {
                  // if the values are null, means the user needs to add values
                  if (value == null || value.isEmpty) {
                    return "Please Enter an item name";
                  } else {
                    return null; // else returns null
                  }
                },
                controller: itemNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Item Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                // validators to check the status of the form field
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                // updated to text form field
                validator: (value) {
                  // if the values are null, means the user needs to add values
                  if (value == null || value.isEmpty) {
                    return "Please Enter a price";
                  } else {
                    return null; // else returns null
                  }
                },
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Price',
                ),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Add Item'),
                  onPressed: () {
                    // if the fields are not empty, then addMenuItem
                    if (itemNameController.text.isNotEmpty &&
                        priceController.text.isNotEmpty) {
                      addMenuItem(
                          itemNameController.text,
                          descriptionController.text,
                          priceController.text,
                          context);
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
