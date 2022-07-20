import 'package:flutter/material.dart';
import 'package:home_food_delivery/src/common_tools/cook_page.dart';
import 'package:home_food_delivery/src/signup/mysql.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cook_view.dart';

class custitems extends StatelessWidget {
  String title;
  String data = "Customer's Order";
  List<List<String>> menu = <List<String>>[];
  custitems({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo.shade300,
          title: Text(data),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const cookPage(title: '')),
            ),
          ),
        ),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class menuItem {
  String name;
  int quantity;
  menuItem(this.name, this.quantity);
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  getMenuItems() async {
    //get ID of cook was clicked and get their menu items
    var db = Mysql();
    final prefs = await SharedPreferences.getInstance();
    final customerID = prefs.getInt('selected_customer');
    final cookID = prefs.getInt('cook_id');
    final time = prefs.getString('selected_customer_time');
    db.getConnection().then((conn) {
      String sql =
          'select menu.item, orders.item_quantity, orders.specialRequest from orders join menu on orders.menu_id = menu.menu_id where orders.user_id = \'$customerID\' and orders.cook_id = \'$cookID\' and orders.order_date = \'$time\'';
      conn.query(sql).then((results) {
        for (var row in results) {
          var item = menuItem(
            row[0].toString(),
            int.parse(row[1].toString()),
          );
          setState(() {
            menu.insert(0, item);
            specialRequest = row[2].toString();
          });
        }
      }, onError: (error) {
        print("$error");
      }).whenComplete(() => conn.close());
    });
    db.getConnection().then((conn) {
      String sql =
          "SELECT concat(user.first_name, ' ', user.last_name) FROM Home_Food_Delivery_Database.user WHERE user.user_id = '$customerID'";
      conn.query(sql).then((results) {
        for (var row in results) {
          setState(() {
            custName = row[0].toString();
          });
        }
      }, onError: (error) {
        print("$error");
      }).whenComplete(() => conn.close());
    });
  }

  void completeOrder() async {
    // when the cook is done making the order
    var db = Mysql();
    final prefs = await SharedPreferences.getInstance();
    final customerID = prefs.getInt('selected_customer');
    final cookID = prefs.getInt('cook_id');
    final time = prefs.getString('selected_customer_time');
    db.getConnection().then((conn) {
      String sql = // set the flag to 2 now
          "UPDATE Home_Food_Delivery_Database.orders SET orders.order_progress = 2 WHERE orders.user_id = '$customerID' and orders.cook_id = '$cookID' and orders.cook_id = '$cookID' and orders.order_date = '$time'";
      conn.query(sql).then((results) {}, onError: (error) {
        print("$error");
      }).whenComplete(() => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CookView(
                title: 'Cook',
              )))); // go back to prev page
    });
  }

  List<menuItem> menu = [];
  bool gotMenu = false;
  String custName = "Customer Name";
  String specialRequest = " ";
  @override
  Widget build(BuildContext context) {
    if (!gotMenu) {
      getMenuItems();
      gotMenu = true;
    }
    return Column(children: [
      Row(
        children: [
          const SizedBox(height: 20, width: 20),
          Container(
            height: 150,
            width: 100,
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Image.asset("assets/images/home_foods_logo.png"),
          ),
          Text(
            custName,
            style: const TextStyle(
                fontSize: 25.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      const Text(
        "Items Ordered\n",
        textAlign: TextAlign.center,
        textScaleFactor: 2.0,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
      ),
      Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Text(
            "Special Requests/Instructions:\n $specialRequest",
            textAlign: TextAlign.center,
            textScaleFactor: 2.0,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
                fontSize: 10.0,
                fontStyle: FontStyle.italic),
            overflow: TextOverflow.visible,
          )),
      Expanded(
          //Menu List
          child: menu.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: menu.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        height: 100,
                        margin: const EdgeInsets.all(2),
                        color: Colors.indigo.shade300,
                        child: Row(children: [
                          Image.asset("assets/images/home_foods_logo.png"),
                          Flexible(
                            child: Align(
                              alignment: const Alignment(0, 0),
                              child: Text(
                                //display name, description, and price from List<menuItem>
                                // kept this same from krish's code
                                '${menu[index].name}\nQuantity:${menu[index].quantity}\n',
                                style: const TextStyle(fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ]));
                  })
              : const Center(
                  child: Text('No Menu Items Purchased from this customer'))),
      Container(
          height: 60,
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo.shade300,
              ),
              child: const Text("Complete Order"),
              onPressed: () {
                completeOrder(); // go back to prev page
              })),
    ]);
  }
}
