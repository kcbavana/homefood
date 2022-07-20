import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:home_food_delivery/src/signup/login_view.dart';

//void main() => runApp(loginView());

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: FlexColorScheme.light(scheme: FlexScheme.mandyRed).toTheme,
      //darkTheme: FlexColorScheme.dark(scheme: FlexScheme.mandyRed).toTheme,
      themeMode: ThemeMode.system,
      home: loginView(),
    );
  }
}
