import 'package:flutter/material.dart';
import 'package:home_food_delivery/src/common_tools/driver_page.dart';

void main() => runApp(const MyApp());

const String title = "Driver Page";

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: title,
      home: DriverView(title: 'Driver'),
    );
  }
}

class DriverView extends StatelessWidget {
  //if want listview to update when click refresh, have to make stateful widget and extend State
  // https://googleflutter.com/flutter-add-item-to-listview-dynamically/#:~:text=Let%20us%20add%20a%20TextField,item%20to%20the%20list%20dynamically.&text=Run%20this%20application%2C%20and%20you,top%20of%20the%20list%20dynamically
  const DriverView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: driverPage(title: ''),
    );
  }
}
