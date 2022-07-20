import 'package:flutter/material.dart';
import 'package:home_food_delivery/src/common_tools/hamburger.dart';
import 'package:home_food_delivery/src/weather_api/services/weather.dart';
import 'package:home_food_delivery/src/weather_api/utilities/constants.dart';
import 'package:home_food_delivery/src/weather_api/screens/city_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.locationWeather});

  final locationWeather;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherModel weather = WeatherModel();

  DateTime date = DateTime.now();

  int? temperature;
  int? temperatureMin;
  int? temperatureMax;
  String? weatherIcon;
  String? cityName;
  String? dayName;
  String? weatherCondition;

  @override
  void initState() {
    super.initState();

    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        temperatureMin = 0;
        temperatureMax = 0;
        weatherIcon = 'Error';
        cityName = '';
        weatherCondition = '';
        return;
      }

      var temp = weatherData['main']['temp'];
      temperature = temp.toInt();

      var tempMin = weatherData['main']['temp_min'];
      temperatureMin = tempMin.toInt();

      var tempMax = weatherData['main']['temp_max'];
      temperatureMax = tempMax.toInt();

      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);

      cityName = weatherData['name'];

      dayName = DateFormat('EEEE').format(date);

      weatherCondition = weatherData['weather'][0]['main'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: Hamburger(
          title: '',
        ),
        appBar: buildAppBar(),
        backgroundColor: Colors.cyan.shade200,
        body: Container(
          alignment: Alignment.center,
          // constraints: BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      '$cityName',
                      style: kCityNameTextStyle,
                    ),
                  ),
                  Text(
                    '$dayName',
                    style: kTimeTextStyle,
                  ),
                ],
              ),
              Image.asset(
                'assets/images/$weatherIcon.png',
                height: 160,
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      '$temperature°',
                      style: kTemperatureTextStyle,
                    ),
                  ),
                  Text(
                    '$weatherCondition'.toUpperCase(),
                    style: kConditionTextStyle,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/thermometer_low.png',
                    height: 50,
                  ),
                  Text(
                    '$temperatureMin°',
                    style: kSmallTemperatureTextStyle,
                  ),
                  Image.asset(
                    'assets/images/thermometer_high.png',
                    height: 50,
                  ),
                  Text(
                    '$temperatureMax°',
                    style: kSmallTemperatureTextStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: IconButton(
        highlightColor: Colors.transparent,
        splashRadius: 27.5,
        icon: const Icon(
          Icons.near_me,
          color: Colors.white,
        ),
        onPressed: () async {
          var weatherData = await weather.getLocationWeather();
          updateUI(weatherData);
        },
      ),
      actions: <Widget>[
        IconButton(
          highlightColor: Colors.transparent,
          splashRadius: 27.5,
          icon: const Icon(
            Icons.my_location,
            color: Colors.white,
          ),
          onPressed: () async {
            var typedName = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return CityScreen();
                },
              ),
            );
            if (typedName != null) {
              var weatherData = await weather.getCityWeather(typedName);
              updateUI(weatherData);
            }
          },
        ),
        IconButton(
          highlightColor: Colors.transparent,
          splashRadius: 27.5,
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Hamburger(title: '');
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
