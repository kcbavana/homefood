import 'package:flutter/material.dart';
import 'package:home_food_delivery/src/common_tools/hamburger.dart';
import 'package:home_food_delivery/src/weather_api/screens/home_screen.dart';
import 'package:home_food_delivery/src/weather_api/services/weather.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoadingScreenState();
  }
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async {
    var weatherData = await WeatherModel().getLocationWeather();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomeScreen(
        locationWeather: weatherData,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Hamburger(
        title: '',
      ),
      backgroundColor: Colors.cyan.shade200,
      body: Center(
        child: SpinKitFadingFour(
          color: Colors.white,
          size: 25.0,
        ),
      ),
    );
  }
}
