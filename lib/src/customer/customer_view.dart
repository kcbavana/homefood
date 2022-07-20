import 'package:flutter/material.dart';
import 'package:home_food_delivery/src/common_tools/customer_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const appTitle = 'Customer Page';

  get customer => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // i removed const from here
      title: appTitle,
      home: CustomerView(
        title: appTitle,
      ),
    );
  }
}

class CustomerView extends StatelessWidget {
  CustomerView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // this calls the customer_page.dart and sets up the taskbar and
      // other pages on the customer screen
      bottomNavigationBar: customerPage(title: ''),
    );
  }
}
