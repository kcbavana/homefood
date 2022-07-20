import 'package:home_food_delivery/src/driver/location.dart';
import 'package:home_food_delivery/src/driver/route.dart';

// ignore: camel_case_types
class OpenWeatherAPI extends Route {
  OpenWeatherAPI(
      Location pickupAddress,
      Location deliveryAddress,
      double cost,
      int distance,
      int time,
      String weather,
      String conditions,
      double gasPrice)
      : super(pickupAddress, deliveryAddress, cost, distance, time, weather,
            conditions, gasPrice);

  String getCurrentWeather() {
    return "";
  }

  String getRoadConditions() {
    return "";
  }
}
