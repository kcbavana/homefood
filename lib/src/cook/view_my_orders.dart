import 'package:flutter/material.dart';
import 'package:home_food_delivery/src/driver/driver_view.dart';

void main() => runApp(const MyApp());

// this is just a copy paste of the driver_view class but with the child name being Update Menu Page instead of driver page
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const appTitle = 'View My Orders';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: DriverView(title: appTitle),
    );
  }
}

class viewMyOrders extends StatelessWidget {
  const viewMyOrders({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(
        child: Text('View the Order Queue Here'),
      ),
    );
  }
}
