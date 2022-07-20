import 'package:flutter/material.dart';
import 'package:home_food_delivery/src/common_tools/cook_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const appTitle = 'Cook Page';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: CookView(title: appTitle),
    );
  }
}

class CookView extends StatelessWidget {
  const CookView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: cookPage(title: ''),
    );
  }
}
